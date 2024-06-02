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

          def call(layout = nil) = settings.build_layout = parse(layout)

          private

          def parse value
            case value
              in "false" then false
              in String then value
              else default
            end
          end
        end
      end
    end
  end
end
