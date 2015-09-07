module Milestoner
  # Handles the tagging of a project repository.
  class Tagger
    attr_reader :version

    def self.commit_prefixes
      %w(Fixed Added Updated Removed Refactored) # Order is important for controlling the sort.
    end

    def self.commit_prefix_regex
      /\A(#{commit_prefixes.join "|"})/
    end

    def self.version_regex
      /\A\d{1}\.\d{1}\.\d{1}\z/
    end

    def initialize version
      @version = validate_version version
    end

    def version_label
      "v#{version}"
    end

    def version_message
      "Version #{version}."
    end

    def tagged?
      response = `git tag`
      !(response.nil? || response.empty?)
    end

    def commits
      groups = build_commit_prefix_groups
      group_by_commit_prefix! groups
      groups.values.flatten
    end

    def create sign: false
      `git tag #{tag_options sign: sign}`
    end

    def destroy
      `git tag --delete #{version_label}`
    end

    private

    def validate_version version
      message = "Invalid version: #{version}. Use: <major>.<minor>.<maintenance>."
      fail(VersionError, message) unless version.match(self.class.version_regex)
      version
    end

    def raw_commits
      tag_command = "$(git describe --abbrev=0 --tags --always)..HEAD"
      full_command = "git log --oneline --reverse --no-merges --format='%s' #{tag_command}"
      full_command.gsub!(tag_command, "") unless tagged?

      `#{full_command}`.split("\n")
    end

    def build_commit_prefix_groups
      groups = self.class.commit_prefixes.map.with_object({}) do |prefix, group|
        group.merge! prefix => []
      end
      groups.merge! "Other" => []
    end

    def group_by_commit_prefix! groups = {}
      raw_commits.each do |commit|
        prefix = commit[self.class.commit_prefix_regex]
        key = groups.key?(prefix) ? prefix : "Other"
        groups[key] << commit
      end
    end

    def tag_message
      commit_list = commits.map { |commit| "- #{commit}\n" }
      %(#{version_message}\n\n#{commit_list.join})
    end

    def tag_options sign: false
      options = %(--sign --annotate "#{version_label}" --message "#{tag_message}")
      return options.gsub("--sign ", "") unless sign
      options
    end
  end
end
