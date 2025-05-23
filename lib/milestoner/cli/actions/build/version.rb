# frozen_string_literal: true

require "sod"
require "versionaire"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build version.
        class Version < Sod::Action
          include Dependencies[:settings, :logger]

          using Versionaire::Cast

          description "Set version."

          ancillary "Calculated from commit trailers when not supplied."

          on %w[-v --version], argument: "[VERSION]"

          default { Container[:settings].project_version }

          def call version = default
            settings.project_version = Version version
          rescue Versionaire::Error => error
            logger.error { error.message }
          end
        end
      end
    end
  end
end
