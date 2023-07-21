# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Cache
        # Handles creating or updating a user within the cache.
        class Create < Sod::Action
          include Import[:logger, client: :cache]

          description "Create user."

          ancillary %(Example: "1,zoe,Zoë Washburne".)

          on %w[-c --create], argument: "external_id,handle,name"

          def call values
            process(values).bind { |user| log_info "Created: #{user.name.inspect}" }
          end

          private

          def process values
            external_id, handle, name = values.split ","
            client.commit(:users) { upsert({external_id:, handle:, name:}) }
          end

          def log_info(message) = logger.info { message }
        end
      end
    end
  end
end
