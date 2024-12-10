# frozen_string_literal: true

require "pathname"
require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build output path.
        class Output < Sod::Action
          include Dependencies[:settings]

          description "Set output path."

          on %w[-o --output], argument: "[PATH]"

          default { Container[:settings].build_output }

          def call(path = default) = settings.build_output = Pathname(path).expand_path
        end
      end
    end
  end
end
