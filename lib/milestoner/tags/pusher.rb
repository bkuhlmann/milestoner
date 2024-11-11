# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Tags
    # Handles publishing of tags to a remote repository.
    class Pusher
      include Dependencies[:git, :logger]
      include Dry::Monads[:result]

      def call version
        check_remote_repo(version).bind { check_remote_tag version }
                                  .bind { push version }
      end

      private

      def check_remote_repo version
        git.origin? ? Success(version) : Failure("Remote repository not configured.")
      end

      def check_remote_tag version
        git.tag_remote?(version) ? Failure("Remote tag exists: #{version}.") : Success(version)
      end

      def push version
        git.tags_push
           .either proc { debug version },
                   proc { Failure "Tags could not be pushed to remote repository." }
      end

      def debug version
        logger.debug { "Local tag pushed: #{version}." }
        Success version
      end
    end
  end
end
