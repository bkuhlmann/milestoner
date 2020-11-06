# frozen_string_literal: true

require "open3"
require "thor"
require "versionaire"
require "tempfile"
require "git/kit"

module Milestoner
  # Handles the tagging of a project repository.
  # :reek:TooManyMethods
  # :reek:InstanceVariableAssumption
  class Tagger
    attr_reader :version, :commit_prefixes

    def initialize commit_prefixes: [], git: Git::Kit::Core.new
      @commit_prefixes = commit_prefixes
      @git = git
      @shell = Thor::Shell::Color.new
    end

    def commit_prefix_regex
      return Regexp.new "" if commit_prefixes.empty?

      Regexp.union commit_prefixes
    end

    def commits
      groups = build_commit_prefix_groups
      group_by_commit_prefix groups
      groups.each_value(&:sort!)
      groups.values.flatten.uniq
    end

    def commit_list
      commits.map { |commit| "- #{commit}" }
    end

    # :reek:BooleanParameter
    def create version, sign: false
      @version = Versionaire::Version version
      fail Errors::Git, "Unable to tag without commits." unless git.commits?
      return if existing_tag?

      git_tag sign: sign
    end

    private

    attr_reader :git, :shell

    def git_log_command
      "git log --oneline --no-merges --format='%s'"
    end

    def git_tag_command
      "$(git describe --abbrev=0 --tags --always)..HEAD"
    end

    def git_commits_command
      return "#{git_log_command} #{git_tag_command}" if git.tagged?

      git_log_command
    end

    def raw_commits
      `#{git_commits_command}`.split "\n"
    end

    def build_commit_prefix_groups
      groups = commit_prefixes.map.with_object({}) { |prefix, group| group.merge! prefix => [] }
      groups.merge! "Other" => []
    end

    def group_by_commit_prefix groups = {}
      raw_commits.each do |commit|
        prefix = commit[commit_prefix_regex]
        key = groups.key?(prefix) ? prefix : "Other"
        groups[key] << commit.gsub(/\[ci\sskip\]/, "").squeeze(" ").strip
      end
    end

    def git_message
      %(Version #{@version}\n\n#{commit_list.join "\n"}\n\n)
    end

    # :reek:BooleanParameter
    # :reek:ControlParameter
    def git_options message_file, sign: false
      options = %(--sign --annotate "#{@version}" ) +
                %(--cleanup verbatim --file "#{message_file.path}")
      return options.gsub "--sign ", "" unless sign

      options
    end

    def existing_tag?
      return false unless git.tag_local? @version

      shell.say_status :warn, "Local tag exists: #{@version}. Skipped.", :yellow
      true
    end

    # :reek:BooleanParameter
    # :reek:TooManyStatements
    def git_tag sign: false
      message_file = Tempfile.new Identity::NAME
      File.open(message_file, "w") { |file| file.write git_message }
      status = system "git tag #{git_options message_file, sign: sign}"
      fail Errors::Git, "Unable to create tag: #{@version}." unless status
    ensure
      message_file.close
      message_file.unlink
    end
  end
end
