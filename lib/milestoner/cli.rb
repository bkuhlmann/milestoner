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

    desc "-t, [--tag=TAG]", "Tag repository with new version."
    map %w(-t --tag) => :tag
    method_option :sign, aliases: "-s", desc: "Sign tag with GPG key.", type: :boolean, default: false
    def tag version
      release = Milestoner::Release.new version
      release.tag sign: options[:sign]
      say "Repository tagged: #{release.version_label}."
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
