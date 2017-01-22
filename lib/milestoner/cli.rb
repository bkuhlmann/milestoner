# frozen_string_literal: true

require "thor"
require "thor/actions"
require "thor_plus/actions"
require "runcom"

module Milestoner
  # The Command Line Interface (CLI) for the gem.
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions

    package_name Identity.version_label

    def self.configuration
      Runcom::Configuration.new file_name: Identity.file_name, defaults: {
        version: "0.1.0",
        git_commit_prefixes: %w[Fixed Added Updated Removed Refactored],
        git_tag_sign: false
      }
    end

    # rubocop:disable Metrics/AbcSize
    def initialize args = [], options = {}, config = {}
      super args, options, config
      @tagger = Tagger.new self.class.configuration.to_h[:version],
                           commit_prefixes: self.class.configuration.to_h[:git_commit_prefixes]
      @pusher = Pusher.new
      @publisher = Publisher.new tagger: tagger, pusher: pusher
    end

    desc "-C, [--commits]", "Show commits for next milestone."
    map %w[-C --commits] => :commits
    def commits
      tagger.commit_list.each { |commit| say commit }
    rescue StandardError => exception
      error exception.message
    end

    desc "-t, [--tag=VERSION]", "Tag local repository with new version."
    map %w[-t --tag] => :tag
    method_option :sign,
                  aliases: "-s",
                  desc: "Sign tag with GPG key.",
                  type: :boolean,
                  default: false
    def tag version = self.class.configuration.to_h[:version]
      tagger.create version, sign: sign_tag?(options[:sign])
      say "Repository tagged: #{tagger.version_label}."
    rescue StandardError => exception
      error exception.message
    end

    desc "-p, [--push]", "Push local tag to remote repository."
    map %w[-p --push] => :push
    def push
      pusher.push
      info "Tags pushed to remote repository."
    rescue StandardError => exception
      error exception.message
    end

    desc "-P, [--publish=VERSION]", "Tag and push milestone to remote repository."
    map %w[-P --publish] => :publish
    method_option :sign,
                  aliases: "-s",
                  desc: "Sign tag with GPG key.",
                  type: :boolean,
                  default: false
    def publish version = self.class.configuration.to_h[:version]
      publisher.publish version, sign: sign_tag?(options[:sign])
      info "Repository tagged and pushed: #{tagger.version_label}."
      info "Milestone published!"
    rescue StandardError => exception
      error exception.message
    end

    desc "-c, [--config]", %(Manage gem configuration ("#{configuration.computed_path}").)
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
      path = self.class.configuration.computed_path

      if options.edit? then `#{editor} #{path}`
      elsif options.info? then say(path)
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
      sign | self.class.configuration.to_h[:git_tag_sign]
    end
  end
end
