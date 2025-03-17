# frozen_string_literal: true

require "hanami/view"

module Milestoner
  module Views
    module Milestones
      # The index view.
      class Index < Hanami::View
        include Dependencies[:settings]

        config.default_context = Context.new
        config.part_namespace = Parts
        config.paths = Container[:settings].build_template_paths
        config.scope_namespace = Scopes
        config.template = "milestones/index"

        expose :tags
      end
    end
  end
end
