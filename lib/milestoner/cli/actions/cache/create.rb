# frozen_string_literal: true

require "core"
require "sod"

module Milestoner
  module CLI
    module Actions
      module Cache
        # Handles creating or updating a user within the cache.
        class Create < Sod::Action
          include Dependencies[:logger, client: :cache]

          description "Create user."

          ancillary %(Example: "1,zoe,Zoë Washburne".)

          on %w[-c --create], argument: "external_id,handle,name"

          def call values
            case values.split ","
              in String => external_id, String => handle, String => name
                client.write(:users) { upsert({external_id:, handle:, name:}) }
                      .bind { |user| log_info "Created: #{user.name.inspect}" }
              in String, String then log_error "Name must be supplied."
              in [String] then log_error "Handle and Name must be supplied."
              in Core::EMPTY_ARRAY then log_error "No values given."
              else log_error "Too many values given."
            end
          end

          private

          def log_info(message) = logger.info { message }

          def log_error(message) = logger.error { message }
        end
      end
    end
  end
end
