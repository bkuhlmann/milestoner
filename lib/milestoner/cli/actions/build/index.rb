# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build index.
        class Index < Sod::Action
          include Dependencies[:settings]

          description "Enable/disable versions index."

          ancillary "Only used by web format."

          on "--[no-]index"

          default { Container[:settings].build_index }

          def call(boolean) = settings.build_index = boolean
        end
      end
    end
  end
end
