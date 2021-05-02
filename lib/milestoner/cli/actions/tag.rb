# frozen_string_literal: true

module Milestoner
  module CLI
    module Actions
      # Handles tag creation.
      class Tag
        def initialize tagger: Tagger.new
          @tagger = tagger
        end

        def call(configuration) = tagger.call(configuration)

        private

        attr_reader :tagger, :container
      end
    end
  end
end
