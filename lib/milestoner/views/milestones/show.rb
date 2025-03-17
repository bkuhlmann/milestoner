# frozen_string_literal: true

require "hanami/view"

module Milestoner
  module Views
    module Milestones
      # The show view.
      class Show < Hanami::View
        include Dependencies[:settings]

        config.default_context = Context.new
        config.part_namespace = Parts
        config.paths = Container[:settings].build_template_paths
        config.scope_namespace = Scopes
        config.template = "milestones/show"

        expose :past, :tag, :future
      end
    end
  end
end
