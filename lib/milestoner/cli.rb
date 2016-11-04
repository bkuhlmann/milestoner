# frozen_string_literal: true

require "yaml"
require "thor"
require "thor/actions"
require "thor_plus/actions"

module Milestoner
  # The Command Line Interface (CLI) for the gem.
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions

    package_name Identity.version_label

    def self.defaults
      {
        version: "0.1.0",
        git_commit_prefixes: %w[Fixed Added Updated Removed Refactored],
        git_tag_sign: false
      }
    end

    def initialize args = [], options = {}, config = {}
      super args, options, config
      @configuration = Configuration.new Identity.file_name, defaults: self.class.defaults
      @tagger = Tagger.new configuration.settings[:version],
                           commit_prefixes: configuration.settings[:git_commit_prefixes]
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

    desc "-t, [--tag=TAG]", "Tag local repository with new version."
    map %w[-t --tag] => :tag
    method_option :sign, aliases: "-s", desc: "Sign tag with GPG key.", type: :boolean, default: false
    def tag version = configuration.settings[:version]
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

    desc "-P, [--publish=PUBLISH]", "Tag and push milestone to remote repository."
    map %w[-P --publish] => :publish
    method_option :sign, aliases: "-s", desc: "Sign tag with GPG key.", type: :boolean, default: false
    def publish version = configuration.settings[:version]
      publisher.publish version, sign: sign_tag?(options[:sign])
      info "Repository tagged and pushed: #{tagger.version_label}."
      info "Milestone published!"
    rescue StandardError => exception
      error exception.message
    end

    desc "-c, [--config]", "Show/manage gem configuration."
    map %w[-c --config] => :config
    method_option :edit, aliases: "-e", desc: "Edit gem configuration.", type: :boolean, default: false
    def config
      if options[:edit]
        `#{editor} #{configuration.computed_file_path}`
      else
        print_config_info
      end
    end

    desc "-v, [--version]", "Show gem version."
    map %w[-v --version] => :version
    def version
      say Identity.version_label
    end

    desc "-h, [--help=HELP]", "Show this message or get help for a command."
    map %w[-h --help] => :help
    def help task = nil
      say and super
    end

    private

    attr_reader :configuration, :tagger, :pusher, :publisher

    def sign_tag? sign
      sign | configuration.settings[:git_tag_sign]
    end

    def print_config_info
      if configuration.local? then say("Using local configuration: #{configuration.computed_file_path}.")
      elsif configuration.global? then say("Using global configuration: #{configuration.computed_file_path}.")
      else say("Local or global gem configuration not defined, using defaults instead.")
      end
    end
  end
end
