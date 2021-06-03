# frozen_string_literal: true

module Milestoner
  module CLI
    module Actions
      # Handles pushing of local tag to remote repository.
      class Push
        def initialize pusher: Tags::Pusher.new, container: Container
          @pusher = pusher
          @container = container
        end

        def call configuration
          pusher.call configuration
          logger.info { "Tags pushed to remote repository." }
        end

        private

        attr_reader :pusher, :container

        def logger = container[__method__]
      end
    end
  end
end
