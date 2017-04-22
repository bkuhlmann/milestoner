# frozen_string_literal: true

require "forwardable"
require "open3"
require "versionaire"

module Milestoner
  # Handles the tagging of a project repository.
  class Tagger
    extend Forwardable

    attr_reader :version, :commit_prefixes

    def_delegator :version, :label, :version_label

    def initialize version = "0.1.0", commit_prefixes: [], git: Git::Kit.new
      @version = Versionaire::Version version
      @commit_prefixes = commit_prefixes
      @git = git
    end

    def commit_prefix_regex
      return Regexp.new("") if commit_prefixes.empty?
      Regexp.union commit_prefixes
    end

    def commits
      groups = build_commit_prefix_groups
      group_by_commit_prefix! groups
      sort_by_commit_prefix! groups
      groups.values.flatten.uniq
    end

    def commit_list
      commits.map { |commit| "- #{commit}" }
    end

    def create raw_version = version, sign: false
      @version = Versionaire::Version raw_version
      fail(Errors::Git, "Unable to tag without commits.") unless git.commits?
      fail(Errors::DuplicateTag, "Duplicate tag exists: #{version.label}.") if git_duplicate_tag?
      git_tag sign: sign
    end

    def delete raw_version = version
      @version = Versionaire::Version raw_version
      Open3.capture3 "git tag --delete #{version.label}" if git_duplicate_tag?
    end

    private

    attr_reader :git

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
      `#{git_commits_command}`.split("\n")
    end

    def git_duplicate_tag?
      git.tag? version.label
    end

    def build_commit_prefix_groups
      groups = commit_prefixes.map.with_object({}) { |prefix, group| group.merge! prefix => [] }
      groups.merge! "Other" => []
    end

    def sanitize_commit commit
      commit.gsub(/\[ci\sskip\]/, "").squeeze(" ").strip
    end

    def group_by_commit_prefix! groups = {}
      raw_commits.each do |commit|
        prefix = commit[commit_prefix_regex]
        key = groups.key?(prefix) ? prefix : "Other"
        groups[key] << sanitize_commit(commit)
      end
    end

    def sort_by_commit_prefix! groups = {}
      groups.each { |_, values| values.sort! }
    end

    def git_message
      %(Version #{version}.\n\n#{commit_list.join "\n"}\n\n)
    end

    def git_options message_file, sign: false
      options = %(--sign --annotate "#{version.label}" ) +
                %(--cleanup verbatim --file "#{message_file.path}")
      return options.gsub("--sign ", "") unless sign
      options
    end

    def git_tag sign: false
      message_file = Tempfile.new Identity.name
      File.open(message_file, "w") { |file| file.write git_message }
      status = system "git tag #{git_options message_file, sign: sign}"
      fail(Errors::Git, "Unable to create tag: #{version.label}.") unless status
    ensure
      message_file.close
      message_file.unlink
    end
  end
end
