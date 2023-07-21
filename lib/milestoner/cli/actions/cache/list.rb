# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Cache
        # Handles listing users within the cache.
        class List < Sod::Action
          include Import[:kernel, :logger, client: :cache]

          description "List users."

          on %w[-l --list]

          def call(*)
            logger.info { "Listing users..." }
            client.commit(:users, &:all).bind { |users| print users }
          end

          private

          def print users
            return logger.info { "No users found." } if users.empty?

            users.each { |user| kernel.puts user.to_h.values.join ", " }
          end
        end
      end
    end
  end
end
