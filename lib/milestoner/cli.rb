require "yaml"
require "thor"
require "thor/actions"
require "thor_plus/actions"

module Milestoner
  # The Command Line Interface (CLI) for the gem.
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions

    package_name Milestoner::Identity.version_label

    def initialize args = [], options = {}, config = {}
      super args, options, config
      @configuration = Milestoner::Configuration.new Milestoner::Identity.file_name, defaults: defaults
      @tagger = Milestoner::Tagger.new configuration.settings[:version],
                                       commit_prefixes: configuration.settings[:git_commit_prefixes]
      @pusher = Milestoner::Pusher.new
      @publisher = Milestoner::Publisher.new tagger, pusher
    end

    desc "-c, [--commits]", "Show commits for next milestone."
    map %w(-c --commits) => :commits
    def commits
      tagger.commit_list.each { |commit| say commit }
    rescue Milestoner::Errors::Base => base_error
      error base_error.message
    end

    desc "-t, [--tag=TAG]", "Tag local repository with new version."
    map %w(-t --tag) => :tag
    method_option :sign, aliases: "-s", desc: "Sign tag with GPG key.", type: :boolean, default: false
    def tag version = configuration.settings[:version]
      tagger.create version, sign: sign_tag?(options[:sign])
      say "Repository tagged: #{tagger.version_label}."
    rescue Milestoner::Errors::Base => base_error
      error base_error.message
    end

    desc "-p, [--push]", "Push local tag to remote repository."
    map %w(-p --push) => :push
    def push
      pusher.push
      info "Tags pushed to remote repository."
    rescue Milestoner::Errors::Base => base_error
      error base_error.message
    end

    desc "-P, [--publish=PUBLISH]", "Tag and push milestone to remote repository."
    map %w(-P --publish) => :publish
    method_option :sign, aliases: "-s", desc: "Sign tag with GPG key.", type: :boolean, default: false
    def publish version = configuration.settings[:version]
      publisher.publish version, sign: sign_tag?(options[:sign])
      info "Repository tagged and pushed: #{tagger.version_label}."
      info "Milestone published!"
    rescue Milestoner::Errors::Base => base_error
      error base_error.message
    end

    desc "-e, [--edit]", "Edit #{Milestoner::Identity.label} settings in default editor."
    map %w(-e --edit) => :edit
    def edit
      info "Editing: #{configuration.computed_file_path}..."
      `#{editor} #{configuration.computed_file_path}`
    end

    desc "-v, [--version]", "Show #{Milestoner::Identity.label} version."
    map %w(-v --version) => :version
    def version
      say Milestoner::Identity.version_label
    end

    desc "-h, [--help=HELP]", "Show this message or get help for a command."
    map %w(-h --help) => :help
    def help task = nil
      say && super
    end

    private

    attr_reader :configuration, :tagger, :pusher, :publisher

    def defaults
      {
        version: "",
        git_commit_prefixes: %w(Fixed Added Updated Removed Refactored),
        git_tag_sign: false
      }
    end

    def sign_tag? sign
      sign | configuration.settings[:git_tag_sign]
    end
  end
end
