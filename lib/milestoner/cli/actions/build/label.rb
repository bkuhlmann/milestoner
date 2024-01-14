# frozen_string_literal: true

require "pathname"
require "sod"
require "spek"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build label.
        class Label < Sod::Action
          include Import[:input]

          description "Set label."

          on %w[-l --label], argument: "[TEXT]"

          default { Container[:configuration].project_label }

          def call(label = nil) = input.project_label = label || default
        end
      end
    end
  end
end
