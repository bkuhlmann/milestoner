# frozen_string_literal: true

require "pathname"
require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build root path.
        class Root < Sod::Action
          include Import[:settings]

          description "Set root output path."

          on %w[-r --root], argument: "[PATH]"

          default { Container[:settings].build_root }

          def call(path = nil) = settings.build_root = Pathname(path || default).expand_path
        end
      end
    end
  end
end
