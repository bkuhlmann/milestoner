# frozen_string_literal: true

module Milestoner
  module Tags
    # Handles the tagging and pushing of a tag to a remote repository.
    class Publisher
      include Import[:logger]

      def initialize(creator: Tags::Creator.new, pusher: Tags::Pusher.new, **)
        super(**)
        @creator = creator
        @pusher = pusher
      end

      def call configuration = Container[:configuration]
        creator.call configuration
        pusher.call configuration
        logger.info { "Published: #{configuration.version}!" }
      end

      private

      attr_reader :creator, :pusher
    end
  end
end
