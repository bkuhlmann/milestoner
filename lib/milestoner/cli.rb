require "yaml"
require "thor"
require "thor/actions"
require "thor_plus/actions"

module Milestoner
  # The Command Line Interface (CLI) for the gem.
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions

    package_name Milestoner::Identity.label

    def initialize args = [], options = {}, config = {}
      super args, options, config
      @configuration = Milestoner::Configuration.new ".#{Milestoner::Identity.name}rc", defaults: defaults
    end

    desc "-c, [--commits]", "Show tag message commits for next milestone."
    map %w(-c --commits) => :commits
    def commits version
      tagger = Milestoner::Tagger.new version, commit_prefixes: configuration.settings[:git_commit_prefixes]
      say "Milestone #{version} Commits:"
      tagger.commit_list.each { |commit| say commit }
    rescue Milestoner::Errors::Base => base_error
      error base_error.message
    end

    desc "-t, [--tag=TAG]", "Tag local repository with new version."
    map %w(-t --tag) => :tag
    method_option :sign, aliases: "-s", desc: "Sign tag with GPG key.", type: :boolean, default: false
    def tag version
      tagger = Milestoner::Tagger.new version, commit_prefixes: configuration.settings[:git_commit_prefixes]
      tagger.create sign: options[:sign]
      say "Repository tagged: #{tagger.version_label}."
    rescue Milestoner::Errors::Base => base_error
      error base_error.message
    end

    desc "-p, [--push]", "Push tags to remote repository."
    map %w(-p --push) => :push
    def push
      pusher = Milestoner::Pusher.new
      pusher.push
      info "Tags pushed to remote repository."
    rescue Milestoner::Errors::Base => base_error
      error base_error.message
    end

    desc "-P, [--publish=PUBLISH]", "Tag and push to remote repository."
    map %w(-P --publish) => :publish
    method_option :sign, aliases: "-s", desc: "Sign tag with GPG key.", type: :boolean, default: false
    def publish version
      tagger = Milestoner::Tagger.new version, commit_prefixes: configuration.settings[:git_commit_prefixes]
      pusher = Milestoner::Pusher.new
      tag_and_push tagger, pusher, options
    rescue Milestoner::Errors::Base => base_error
      error base_error.message
    end

    desc "-v, [--version]", "Show version."
    map %w(-v --version) => :version
    def version
      say Milestoner::Identity.label_version
    end

    desc "-h, [--help=HELP]", "Show this message or get help for a command."
    map %w(-h --help) => :help
    def help task = nil
      say && super
    end

    private

    attr_reader :configuration

    def defaults
      {git_commit_prefixes: %w(Fixed Added Updated Removed Refactored)}
    end

    def tag_and_push tagger, pusher, options
      if tagger.create(sign: options[:sign]) && pusher.push
        say "Repository tagged and pushed: #{tagger.version_label}."
        say "Milestone published!"
      else
        tagger.destroy
      end
    end
  end
end
