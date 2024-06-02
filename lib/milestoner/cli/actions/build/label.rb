# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build label.
        class Label < Sod::Action
          include Import[:settings]

          description "Set label."

          on %w[-l --label], argument: "[TEXT]"

          default { Container[:settings].project_label }

          def call(label = nil) = settings.project_label = label || default
        end
      end
    end
  end
end
