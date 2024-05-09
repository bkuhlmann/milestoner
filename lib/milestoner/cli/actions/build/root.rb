# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build root path.
        class Root < Sod::Action
          include Import[:input]

          description "Set root output path."

          on %w[-r --root], argument: "[PATH]"

          default { Container[:configuration].build_root }

          def call(path = nil) = input.build_root = (path || default).expand_path
        end
      end
    end
  end
end
