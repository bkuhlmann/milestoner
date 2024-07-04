# frozen_string_literal: true

require "hanami/view"

module Milestoner
  module Views
    module Milestones
      # Renders release notes.
      class Show < Hanami::View
        include Import[:settings]

        config.default_context = Context.new
        config.part_namespace = Parts
        config.paths = Container[:settings].build_template_paths
        config.template = "milestones/show"

        expose :tag
      end
    end
  end
end
