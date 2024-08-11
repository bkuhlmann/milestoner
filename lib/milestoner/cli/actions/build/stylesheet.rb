# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build stylesheet.
        class Stylesheet < Sod::Action
          include Import[:settings]

          description "Set stylesheet file name or relative path."

          ancillary "Only used by web format. Use false to disable."

          on %w[-s --stylesheet], argument: "[NAME]"

          default { Container[:settings].build_stylesheet }

          def call name = default
            settings.build_stylesheet = name == "false" ? false : name
          end
        end
      end
    end
  end
end
