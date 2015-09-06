module Milestoner
  # Handles the release of new project milestones.
  class Release
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
      command = "git log --oneline --reverse --no-merges --format='%s'"

      return `#{command}` unless tagged?
      `#{command} $(git describe --abbrev=0 --tags --always)..HEAD`
    end

    def commits_sorted
      prefix_regex = self.class.commit_prefix_regex

      commits.split("\n").sort do |a, b|
        next 1 unless a.match(prefix_regex) && b.match(prefix_regex)
        sort_by_prefix a, b
      end
    end

    def tag sign: false
      `git tag #{tag_options sign: sign}`
    end

    private

    def validate_version version
      message = "Invalid version: #{version}. Use: <major>.<minor>.<maintenance>."
      raise(VersionError, message) unless version.match(self.class.version_regex)
      version
    end

    def index_for_prefix message
      self.class.commit_prefixes.index message[self.class.commit_prefix_regex]
    end

    def sort_by_prefix a, b
      a_index = index_for_prefix a
      b_index = index_for_prefix b

      case
        when a_index > b_index then 1
        when a_index == b_index then 0
        when a_index < b_index then -1
        else
          a <=> b
      end
    end

    def tag_message
      commit_list = commits_sorted.map { |commit| "- #{commit}\n" }
      %(#{version_message}\n\n#{commit_list.join})
    end

    def tag_options sign: false
      options = %(--sign --annotate "#{version_label}" --message "#{tag_message}")
      return options.gsub("--sign ", "") unless sign
      options
    end
  end
end
