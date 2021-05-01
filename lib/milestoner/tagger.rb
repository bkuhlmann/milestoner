# frozen_string_literal: true

require "thor"
require "versionaire"

module Milestoner
  # Handles the tagging of a project repository.
  # :reek:TooManyInstanceVariables
  class Tagger
    attr_reader :commit_prefixes

    def initialize commit_prefixes: [],
                   repository: GitPlus::Repository.new,
                   presenter: Presenters::Commit
      @commit_prefixes = commit_prefixes
      @repository = repository
      @presenter = presenter
      @shell = Thor::Shell::Color.new
    end

    def commit_prefix_regex
      commit_prefixes.empty? ? Regexp.new("") : Regexp.union(commit_prefixes)
    end

    def commits
      groups = build_commit_prefix_groups
      group_by_commit_prefix groups
      groups.each_value { |commits| commits.sort_by!(&:subject) }
      groups.values.flatten.uniq(&:subject)
    end

    def commit_list
      commits.map { |source| presenter.new source }
             .map { |commit| "- #{commit.subject_author}" }
    end

    # :reek:BooleanParameter
    # :reek:ControlParameter
    # :reek:TooManyStatements
    def create version, sign: false
      version = Versionaire::Version version

      return if local? version
      fail Errors::Git, "Unable to tag without commits." if computed_commits.empty?

      content = message version
      sign ? repository.tag_sign(version, content) : repository.tag_unsign(version, content)
    end

    private

    attr_reader :repository, :presenter, :shell

    def saved_commits
      repository.commits
    end

    def tagged_commits
      repository.commits "#{repository.tag_last}..HEAD"
    end

    def computed_commits
      (repository.tagged? ? tagged_commits : saved_commits)
    end

    def build_commit_prefix_groups
      commit_prefixes.map
                     .with_object({}) { |prefix, group| group.merge! prefix => [] }
                     .merge! "Other" => []
    end

    def group_by_commit_prefix groups = {}
      computed_commits.each do |commit|
        prefix = commit.subject[commit_prefix_regex]
        key = groups.key?(prefix) ? prefix : "Other"
        groups[key] << commit
      end
    end

    def message version
      %(Version #{version}\n\n#{commit_list.join "\n"}\n\n)
    end

    def local? version
      return false unless repository.tag_local? version

      shell.say_status :warn, "Local tag exists: #{version}. Skipped.", :yellow
      true
    end
  end
end
