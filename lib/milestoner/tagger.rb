module Milestoner
  # Handles the tagging of a project repository.
  class Tagger
    include Aids::Git

    attr_reader :version_number, :commit_prefixes

    def self.version_regex
      /\A\d{1}\.\d{1}\.\d{1}\z/
    end

    def initialize version = nil, commit_prefixes: []
      @version_number = version
      @commit_prefixes = commit_prefixes
    end

    def version_label
      "v#{version_number}"
    end

    def version_message
      "Version #{version_number}."
    end

    def commit_prefix_regex
      return // if commit_prefixes.empty?
      Regexp.union commit_prefixes
    end

    def tagged?
      fail(Errors::Git) unless git_supported?
      response = `git tag`
      !(response.nil? || response.empty?)
    end

    def duplicate?
      fail(Errors::Git) unless git_supported?
      system "git rev-parse #{version_label} > /dev/null 2>&1"
    end

    def commits
      fail(Errors::Git) unless git_supported?
      groups = build_commit_prefix_groups
      group_by_commit_prefix! groups
      sort_by_commit_prefix! groups
      groups.values.flatten.uniq
    end

    def commit_list
      commits.map { |commit| "- #{commit}" }
    end

    def create version = version_number, sign: false
      fail(Errors::Git) unless git_supported?
      @version_number = validate_version version
      fail(Errors::DuplicateTag, "Duplicate tag exists: #{version_label}.") if duplicate?
      create_tag sign: sign
    end

    def destroy
      fail(Errors::Git) unless git_supported?
      `git tag --delete #{version_label}`
    end

    private

    def validate_version version
      message = "Invalid version: #{version}. Use: <major>.<minor>.<maintenance>."
      fail(Errors::Version, message) unless version.match(self.class.version_regex)
      version
    end

    def raw_commits
      tag_command = "$(git describe --abbrev=0 --tags --always)..HEAD"
      full_command = "git log --oneline --reverse --no-merges --format='%s' #{tag_command}"
      full_command.gsub!(tag_command, "") unless tagged?

      `#{full_command}`.split("\n")
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

    def tag_message
      %(#{version_message}\n\n#{commit_list.join "\n"})
    end

    def tag_options message_file, sign: false
      options = %(--sign --annotate "#{version_label}" --file "#{message_file.path}")
      return options.gsub("--sign ", "") unless sign
      options
    end

    def create_tag sign: false
      message_file = Tempfile.new Milestoner::Identity.name
      File.open(message_file, "w") { |file| file.write tag_message }
      `git tag #{tag_options message_file, sign: sign}`
    ensure
      message_file.close
      message_file.unlink
    end
  end
end
