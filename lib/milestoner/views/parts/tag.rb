# frozen_string_literal: true

require "hanami/view"
require "refinements/string"

module Milestoner
  module Views
    module Parts
      # Represents an individual tag.
      class Tag < Hanami::View::Part
        include Import[:settings]

        using Refinements::String

        decorate :commits
        decorate :author, as: :user

        def avatar_url(user) = format settings.avatar_uri, id: user.external_id

        def committed_at fallback: Time.now.utc
          value.committed_at.then { |at| at ? Time.at(at) : fallback }
        end

        def committed_date = committed_at.strftime "%Y-%m-%d"

        def committed_datetime = committed_at.strftime "%Y-%m-%dT%H:%M:%S%z"

        def empty? = value.commits.empty?

        def profile_url(user) = format settings.profile_uri, id: user.handle

        def security = value.signature ? "🔒 Tag (secure)" : "🔓 Tag (insecure)"

        def total_commits
          value.commits.size.then { |total| "#{total} commit".pluralize "s", total }
        end

        def total_files
          value.commits.sum(&:files_changed).then { |total| "#{total} file".pluralize "s", total }
        end

        def total_deletions
          value.commits.sum(&:deletions).then { |total| "#{total} deletion".pluralize "s", total }
        end

        def total_insertions
          value.commits.sum(&:insertions).then { |total| "#{total} insertion".pluralize "s", total }
        end
      end
    end
  end
end
