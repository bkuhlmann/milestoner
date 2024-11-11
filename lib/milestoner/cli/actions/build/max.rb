# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build maximum.
        class Max < Sod::Action
          include Dependencies[:settings]

          description "Set maximum number of tags to process."

          on %w[-m --max], argument: "[NUMBER]", type: Integer

          default { Container[:settings].build_max }

          def call(max = default) = settings.build_max = max
        end
      end
    end
  end
end
