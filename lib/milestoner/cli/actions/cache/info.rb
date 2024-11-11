# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Cache
        # Handles cache information.
        class Info < Sod::Action
          include Dependencies[:logger, client: :cache]

          description "Show information."

          on %w[-i --info]

          def call(*)
            path = client.path
            path.exist? ? log_info("Path: #{path}.") : log_info("No cache found.")
          end

          private

          def log_info(message) = logger.info { message }
        end
      end
    end
  end
end
