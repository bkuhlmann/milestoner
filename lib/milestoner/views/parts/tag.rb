# frozen_string_literal: true

require "hanami/view"
require "refinements/string"

module Milestoner
  module Views
    module Parts
      # The tag presentation logic.
      class Tag < Hanami::View::Part
        include Dependencies[:settings]

        using Refinements::String

        decorate :commits
        decorate :author, as: :user

        def commit_count = value.commits.size

        def committed_at fallback: Time.now
          value.committed_at.then { |at| at ? Time.at(at) : fallback }
        end

        def committed_date = committed_at.strftime "%Y-%m-%d"

        def committed_datetime = committed_at.strftime "%Y-%m-%dT%H:%M:%S%z"

        def deletion_count = value.commits.sum(&:deletions)

        def empty? = value.commits.empty?

        def file_count = value.commits.sum(&:files_changed)

        def insertion_count = value.commits.sum(&:insertions)

        def security = value.signature ? "🔒 Tag (secure)" : "🔓 Tag (insecure)"

        def total_commits = commit_count.then { |total| "#{total} commit".pluralize "s", total }

        def total_files = file_count.then { |total| "#{total} file".pluralize "s", total }

        def total_deletions
          deletion_count.then { |total| "#{total} deletion".pluralize "s", total }
        end

        def total_insertions
          insertion_count.then { |total| "#{total} insertion".pluralize "s", total }
        end

        def uri = format settings.project_uri_version, id: value.version
      end
    end
  end
end
