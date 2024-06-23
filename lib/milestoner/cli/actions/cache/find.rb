# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Cache
        # Handles finding a user in the cache.
        class Find < Sod::Action
          include Import[:logger, :io, client: :cache]

          description "Find user."

          on %w[-f --find], argument: "NAME"

          def call name
            client.read(:users) { find name }
                  .either(method(:success), method(:failure))
          end

          private

          def success(user) = io.puts user.to_h.values.join(", ")

          def failure(message) = logger.abort message
        end
      end
    end
  end
end
