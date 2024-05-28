# frozen_string_literal: true

require "hanami/view"
require "refinements/string"

module Milestoner
  module Views
    module Milestones
      # Produces release notes in HTML format.
      class Show < Hanami::View
        include Import[:settings]

        using Refinements::String

        config.default_context = Context.new
        config.part_namespace = Parts
        config.paths = Container[:settings].build_template_paths
        config.template = "milestones/show"

        expose :commits
        expose(:project_uri_home) { settings.project_uri_home }
        expose(:project_uri_logo) { settings.project_uri_logo }
        expose :at, default: Time.now.utc
        expose(:date) { |at| at.strftime "%Y-%m-%d" }
        expose(:datetime) { |at| at.strftime "%Y-%m-%dT%H:%M:%S%z" }

        expose :total_commits do |commits|
          total = commits.size
          "#{total} commit".pluralize "s", total
        end

        expose :total_files do |commits|
          total = commits.sum(&:files_changed)
          "#{total} file".pluralize "s", total
        end

        expose :total_deletions do |commits|
          total = commits.sum(&:deletions)
          "#{total} deletion".pluralize "s", total
        end

        expose :total_insertions do |commits|
          total = commits.sum(&:insertions)
          "#{total} insertion".pluralize "s", total
        end
      end
    end
  end
end
