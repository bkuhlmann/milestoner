# frozen_string_literal: true

require "hanami/view"
require "refinements/array"
require "refinements/string"

module Milestoner
  module Views
    module Parts
      # The tag presentation logic.
      class Tag < Hanami::View::Part
        include Dependencies[:settings, :color, :durationer]

        using Refinements::Array
        using Refinements::String

        decorate :commits
        decorate :author, as: :user
        decorate :contributors, as: :user

        def colored_total_deletions(*custom)
          custom.push :green if custom.empty?
          color[total_deletions, *custom]
        end

        def colored_total_insertions(*custom)
          custom.push :red if custom.empty?
          color[total_insertions, *custom]
        end

        def commit_count = commits.size

        def committed_at fallback: Time.now
          value.committed_at.then { |at| at ? Time.at(at) : fallback }
        end

        def committed_date = committed_at.strftime "%Y-%m-%d"

        def committed_datetime = committed_at.strftime "%Y-%m-%dT%H:%M:%S%z"

        def contributor_names = contributors.map(&:name).to_sentence

        def deletion_count = commits.sum(&:deletions)

        def duration
          return 0 if commits.empty?

          min = commits.min_by(&:created_at)
          max = commits.max_by(&:updated_at)
          (max.updated_at - min.created_at).to_i
        end

        def empty? = commits.empty?

        def file_count = commits.sum(&:files_changed)

        def index? = settings.build_index

        def insertion_count = commits.sum(&:insertions)

        def security = signature ? "🔒 Tag (secure)" : "🔓 Tag (insecure)"

        def total_commits = commit_count.then { |total| "#{total} commit".pluralize "s", total }

        def total_files = file_count.then { |total| "#{total} file".pluralize "s", total }

        def total_deletions
          deletion_count.then { |total| "#{total} deletion".pluralize "s", total }
        end

        def total_duration = duration.zero? ? "0 seconds" : durationer.call(duration)

        def total_insertions
          insertion_count.then { |total| "#{total} insertion".pluralize "s", total }
        end

        def uri = format settings.project_uri_version, id: version
      end
    end
  end
end
