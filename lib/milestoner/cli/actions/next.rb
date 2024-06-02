# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      # Handles calculation of next version.
      class Next < Sod::Action
        include Import[:settings, :kernel]

        description "Show next version."

        ancillary "Calculated from commit trailers."

        on %w[-n --next]

        def call(*) = kernel.puts settings.project_version
      end
    end
  end
end
