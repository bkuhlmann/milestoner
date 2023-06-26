# frozen_string_literal: true

require "versionaire"

module Milestoner
  module Tags
    # Handles publishing of tags to a remote repository.
    class Pusher
      include Import[:git, :logger]

      using Versionaire::Cast

      def call configuration = Container[:configuration]
        version = Version configuration.project_version

        fail Error, "Remote repository not configured." unless git.origin?
        fail Error, "Remote tag exists: #{version}." if git.tag_remote? version
        fail Error, "Tags could not be pushed to remote repository." if git.tags_push.failure?

        logger.debug "Local tag pushed: #{version}."
      end
    end
  end
end
