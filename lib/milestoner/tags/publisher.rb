# frozen_string_literal: true

module Milestoner
  module Tags
    # Handles the tagging and pushing of a tag to a remote repository.
    class Publisher
      def initialize tagger: Tags::Creator.new, pusher: Tags::Pusher.new, container: Container
        @tagger = tagger
        @pusher = pusher
        @container = container
      end

      def call configuration = CLI::Configuration::Loader.call
        tagger.call configuration
        pusher.call configuration
        logger.info { "Published: #{configuration.git_tag_version}!" }
      end

      private

      attr_reader :tagger, :pusher, :container

      def logger = container[__method__]
    end
  end
end
