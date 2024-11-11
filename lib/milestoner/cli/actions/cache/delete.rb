# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Cache
        # Handles deleting a user from the cache.
        class Delete < Sod::Action
          include Dependencies[:logger, client: :cache]

          description "Delete user."

          on %w[-d --delete], argument: "NAME"

          def call name
            client.write(:users) { delete name }
                  .either(method(:success), method(:failure))
          end

          private

          def success(user) = logger.info { "Deleted: #{user.name.inspect}." }

          def failure(message) = logger.abort message
        end
      end
    end
  end
end
