# frozen_string_literal: true

module Milestoner
  module CLI
    module Actions
      # Handles tag creation and pushing of tag to local repository.
      class Publish
        def initialize publisher: Publisher.new
          @publisher = publisher
        end

        def call(configuration) = publisher.call(configuration)

        private

        attr_reader :publisher
      end
    end
  end
end
