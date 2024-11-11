# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build label.
        class Label < Sod::Action
          include Dependencies[:settings]

          description "Set label."

          on %w[-l --label], argument: "[TEXT]"

          default { Container[:settings].project_label }

          def call(label = default) = settings.project_label = label
        end
      end
    end
  end
end
