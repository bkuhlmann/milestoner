# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Cache
        # Handles listing users within the cache.
        class List < Sod::Action
          include Import[:logger, :io, client: :cache]

          description "List users."

          on %w[-l --list]

          def call(*)
            logger.info { "Listing users..." }
            client.read(:users, &:all).bind { |users| print users }
          end

          private

          def print users
            return logger.info { "No users found." } if users.empty?

            header
            users.each { |user| io.puts user.to_h.values.map(&:inspect).join ", " }
          end

          def header
            header = "External ID, Handle, Name"

            io.puts header
            io.puts "-" * header.size
          end
        end
      end
    end
  end
end
