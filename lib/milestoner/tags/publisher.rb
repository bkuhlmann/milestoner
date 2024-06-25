# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Tags
    # Handles the tagging and pushing of a tag to a remote repository.
    class Publisher
      include Import[:logger]
      include Dry::Monads[:result]

      def initialize(creator: Tags::Creator.new, pusher: Tags::Pusher.new, **)
        super(**)
        @creator = creator
        @pusher = pusher
      end

      def call version
        creator.call(version)
               .bind { pusher.call version }
               .bind { log_info version }
      end

      private

      attr_reader :creator, :pusher

      def log_info version
        logger.info { "Published: #{version}" }
        Success version
      end
    end
  end
end
