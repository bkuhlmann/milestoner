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
    end

    desc "-t, [--tag=TAG]", "Tag local repository with new version."
    map %w(-t --tag) => :tag
    method_option :sign, aliases: "-s", desc: "Sign tag with GPG key.", type: :boolean, default: false
    def tag version
      tagger = Milestoner::Tagger.new version
      tagger.create sign: options[:sign]
      say "Repository tagged: #{tagger.version_label}."
    rescue Milestoner::VersionError => version_error
      error version_error.message
    end

    desc "-p, [--push]", "Push tags to remote repository."
    map %w(-p --push) => :push
    def push
      pusher = Milestoner::Pusher.new
      pusher.push
      info "Tags pushed to remote repository."
    end

    desc "-P, [--publish=PUBLISH]", "Tag and push to remote repository."
    map %w(-P --publish) => :publish
    method_option :sign, aliases: "-s", desc: "Sign tag with GPG key.", type: :boolean, default: false
    def publish version
      tagger = Milestoner::Tagger.new version
      pusher = Milestoner::Pusher.new

      if tagger.create(sign: options[:sign]) && pusher.push
        say "Repository tagged: #{tagger.version_label}."
        say "Repository tags pushed."
        say "Milestone published!"
      end
    rescue Milestoner::VersionError => version_error
      error version_error.message
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
  end
end
