# frozen_string_literal: true

require "thor"
require "thor/actions"
require "runcom"

module Milestoner
  # The Command Line Interface (CLI) for the gem.
  class CLI < Thor
    include Thor::Actions

    package_name Identity.version_label

    def self.configuration
      Runcom::Configuration.new Identity.name, defaults: {
        git_commit_prefixes: %w[Fixed Added Updated Removed Refactored],
        git_tag_sign: false
      }
    end

    def initialize args = [], options = {}, config = {}
      super args, options, config
      @configuration = self.class.configuration
      @tagger = Tagger.new commit_prefixes: @configuration.to_h[:git_commit_prefixes]
      @pusher = Pusher.new
      @publisher = Publisher.new tagger: tagger, pusher: pusher
    rescue Runcom::Errors::Base => error
      abort error.message
    end

    desc "-C, [--commits]", "Show commits for next milestone."
    map %w[-C --commits] => :commits
    def commits
      tagger.commit_list.each { |commit| say commit }
    rescue StandardError => exception
      say_status :error, exception.message, :red
    end

    desc "-t, [--tag=VERSION]", "Tag local repository with new version."
    map %w[-t --tag] => :tag
    method_option :sign,
                  aliases: "-s",
                  desc: "Sign tag with GPG key.",
                  type: :boolean,
                  default: false
    def tag version
      tagger.create version, sign: sign_tag?(options[:sign])
      say "Repository tagged: #{tagger.version}."
    rescue StandardError => exception
      say_status :error, exception.message, :red
    end

    desc "-p, [--push=VERSION]", "Push local tag to remote repository."
    map %w[-p --push] => :push
    def push version
      pusher.push version
      say_status :info, "Tags pushed to remote repository.", :green
    rescue StandardError => exception
      say_status :error, exception.message, :red
    end

    desc "-P, [--publish=VERSION]", "Tag and push milestone to remote repository."
    map %w[-P --publish] => :publish
    method_option :sign,
                  aliases: "-s",
                  desc: "Sign tag with GPG key.",
                  type: :boolean,
                  default: false
    def publish version
      publisher.publish version, sign: sign_tag?(options[:sign])
      say_status :info, "Repository tagged and pushed: #{tagger.version}.", :green
      say_status :info, "Milestone published!", :green
    rescue StandardError => exception
      say_status :error, exception.message, :red
    end

    desc "-c, [--config]", "Manage gem configuration."
    map %w[-c --config] => :config
    method_option :edit,
                  aliases: "-e",
                  desc: "Edit gem configuration.",
                  type: :boolean, default: false
    method_option :info,
                  aliases: "-i",
                  desc: "Print gem configuration.",
                  type: :boolean, default: false
    def config
      path = configuration.path

      if options.edit? then `#{ENV["EDITOR"]} #{path}`
      elsif options.info?
        path ? say(path) : say("Configuration doesn't exist.")
      else help(:config)
      end
    end

    desc "-v, [--version]", "Show gem version."
    map %w[-v --version] => :version
    def version
      say Identity.version_label
    end

    desc "-h, [--help=COMMAND]", "Show this message or get help for a command."
    map %w[-h --help] => :help
    def help task = nil
      say and super
    end

    private

    attr_reader :configuration, :tagger, :pusher, :publisher

    def sign_tag? sign
      sign | configuration.to_h[:git_tag_sign]
    end
  end
end
