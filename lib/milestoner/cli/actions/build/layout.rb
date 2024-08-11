# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build layout.
        class Layout < Sod::Action
          include Import[:settings]

          description "Set view template layout."

          ancillary "Use false to disable."

          on %w[-L --layout], argument: "[NAME]"

          default { Container[:settings].build_layout }

          def call layout = default
            settings.build_layout = layout == "false" ? false : layout
          end
        end
      end
    end
  end
end
