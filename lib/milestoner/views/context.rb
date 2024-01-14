# frozen_string_literal: true

require "forwardable"
require "hanami/view"

module Milestoner
  module Views
    # Provides a common context for all views.
    class Context < Hanami::View::Context
      extend Forwardable

      include Import[:input]

      delegate %i[
        generator_label
        generator_uri
        project_author
        project_description
        project_generator
        project_label
        project_version
      ] => :input

      def project_title = [project_label, project_version].compact.join " "
    end
  end
end
