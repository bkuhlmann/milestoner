# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build tail.
        class Tail < Sod::Action
          include Dependencies[:settings]

          description "Set tail reference."

          ancillary "Defines the Git reference at which to cap the build."

          on %w[-t --tail], argument: "[REFERENCE]", allow: %w[head tag]

          default { Container[:settings].build_tail }

          def call(reference = default) = settings.build_tail = reference
        end
      end
    end
  end
end
