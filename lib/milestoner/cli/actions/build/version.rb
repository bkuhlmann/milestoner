# frozen_string_literal: true

require "pathname"
require "sod"
require "spek"
require "versionaire"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build version.
        class Version < Sod::Action
          include Import[:input]

          using Versionaire::Cast

          description "Set version."

          ancillary "Calculated from commit trailers when not supplied."

          on %w[-v --version], argument: "[VERSION]"

          default { Commits::Versioner.new.call }

          def call(version = nil) = input.project_version = Version(version || default)
        end
      end
    end
  end
end
