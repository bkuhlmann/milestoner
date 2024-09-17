# frozen_string_literal: true

require "core"
require "forwardable"
require "hanami/view"

module Milestoner
  module Views
    # Provides a custom context.
    class Context < Hanami::View::Context
      extend Forwardable

      include Import[:settings]

      delegate %i[
        build_stylesheet
        generator_label
        generator_uri
        generator_version
        project_author
        project_description
        project_label
        project_name
        project_uri_home
        project_uri_icon
        project_uri_logo
        project_uri_version
        project_version
      ] => :settings

      def project_slug
        [project_name, project_version].compact.join("_").tr ".", Core::EMPTY_STRING
      end

      def project_title = [project_label, project_version].compact.join " "
    end
  end
end
