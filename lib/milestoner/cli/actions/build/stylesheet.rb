# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build stylesheet.
        class Stylesheet < Sod::Action
          include Dependencies[:settings]

          description "Enable/disable stylesheet."

          ancillary "Only used by web format."

          on "--[no-]stylesheet"

          default { Container[:settings].build_stylesheet }

          def call(boolean) = settings.build_stylesheet = boolean
        end
      end
    end
  end
end
