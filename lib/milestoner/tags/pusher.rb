# frozen_string_literal: true

require "versionaire"

module Milestoner
  module Tags
    # Handles publishing of tags to a remote repository.
    class Pusher
      include Import[:input, :git, :logger]

      using Versionaire::Cast

      def call override = nil
        version = compute_version override

        fail Error, "Remote repository not configured." unless git.origin?
        fail Error, "Remote tag exists: #{version}." if git.tag_remote? version
        fail Error, "Tags could not be pushed to remote repository." if git.tags_push.failure?

        logger.debug "Local tag pushed: #{version}."
      end

      def compute_version value
        Version value || input.project_version
      rescue Versionaire::Error => error
        raise Error, error
      end
    end
  end
end
