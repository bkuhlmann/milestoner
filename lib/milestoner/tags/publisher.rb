# frozen_string_literal: true

module Milestoner
  module Tags
    # Handles the tagging and pushing of a tag to a remote repository.
    class Publisher
      include Import[:input, :logger]

      def initialize(creator: Tags::Creator.new, pusher: Tags::Pusher.new, **)
        super(**)
        @creator = creator
        @pusher = pusher
      end

      def call override = nil
        creator.call override
        pusher.call override
        logger.info { "Published: #{input.project_version}!" }
      end

      private

      attr_reader :creator, :pusher
    end
  end
end
