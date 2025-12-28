# frozen_string_literal: true

require "core"
require "forwardable"
require "hanami/view"
require "refinements/array"

module Milestoner
  module Views
    # The view context.
    class Context < Hanami::View::Context
      extend Forwardable

      include Dependencies[:settings]

      using Refinements::Array

      delegate %i[
        build_stylesheet
        generator_label
        generator_uri
        generator_version
        organization_label
        organization_uri
        project_author
        project_description
        project_label
        project_name
        project_uri_home
        project_uri_icon
        project_uri_logo
        project_uri_version
        project_version
        stylesheet_uri
      ] => :settings

      def page_title delimiter: " | "
        project_title = [project_label, project_version].compact.join " "

        [project_title, organization_label].compress.join delimiter
      end

      def project_slug
        [project_name, project_version].compact.join("_").tr ".", Core::EMPTY_STRING
      end
    end
  end
end
