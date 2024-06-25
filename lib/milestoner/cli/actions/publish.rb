# frozen_string_literal: true

require "dry/monads"
require "sod"
require "versionaire"

module Milestoner
  module CLI
    module Actions
      # Handles tag creation and pushing of tag to local repository.
      class Publish < Sod::Action
        include Import[:settings, :logger]
        include Dry::Monads[:result]

        using Versionaire::Cast

        description "Publish milestone."

        ancillary "Tag and push to remote repository."

        on %w[-p --publish], argument: "[VERSION]"

        default { Container[:settings].project_version }

        def initialize(publisher: Tags::Publisher.new, **)
          super(**)
          @publisher = publisher
        end

        def call version = nil
          case publisher.call Version(version || default)
            in Success(version) then version
            in Failure(message) then log_error message
            else log_error "Publish failed, unable to parse result."
          end
        rescue Versionaire::Error => error
          log_error error.message
        end

        private

        attr_reader :publisher

        def log_error message
          logger.error { message }
          message
        end
      end
    end
  end
end
