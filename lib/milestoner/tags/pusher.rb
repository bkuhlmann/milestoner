# frozen_string_literal: true

require "versionaire"

module Milestoner
  module Tags
    # Handles publishing of tags to a remote repository.
    class Pusher
      using Versionaire::Cast

      def initialize container: Container
        @container = container
      end

      def call configuration = CLI::Configuration::Loader.call
        version = Version configuration.version

        fail Error, "Remote repository not configured." unless repository.config_origin?
        fail Error, "Remote tag exists: #{version}." if repository.tag_remote? version
        fail Error, "Tags could not be pushed to remote repository." unless push

        logger.debug "Local tag pushed: #{version}."
      end

      private

      attr_reader :container

      def push
        repository.tag_push.then do |_stdout, stderr, status|
          status.success? && stderr.match?(/[new tag]/)
        end
      end

      def repository = container[__method__]

      def logger = container[__method__]
    end
  end
end
