# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build manifest.
        class Manifest < Sod::Action
          include Dependencies[:settings]

          description "Enable/disable manifest."

          on "--[no-]manifest"

          default { Container[:settings].build_manifest }

          def call(boolean) = settings.build_manifest = boolean
        end
      end
    end
  end
end
