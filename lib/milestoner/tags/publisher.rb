# frozen_string_literal: true

module Milestoner
  module Tags
    # Handles the tagging and pushing of a tag to a remote repository.
    class Publisher
      include Import[:logger]

      def initialize tagger: Tags::Creator.new, pusher: Tags::Pusher.new, **dependencies
        super(**dependencies)
        @tagger = tagger
        @pusher = pusher
      end

      def call configuration = Container[:configuration]
        tagger.call configuration
        pusher.call configuration
        logger.info { "Published: #{configuration.version}!" }
      end

      private

      attr_reader :tagger, :pusher
    end
  end
end
