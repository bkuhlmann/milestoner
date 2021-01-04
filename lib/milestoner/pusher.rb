# frozen_string_literal: true

module Milestoner
  # Handles publishing of Git tags to remote repository.
  class Pusher
    def initialize repository: GitPlus::Repository.new
      @repository = repository
    end

    def push version
      version = Versionaire::Version version

      fail Errors::Git, "Remote repository not configured." unless repository.config_origin?
      fail Errors::Git, "Remote tag exists: #{version}." if tag_exists? version
      return if push_tags

      fail Errors::Git, "Tags could not be pushed to remote repository."
    end

    private

    attr_reader :repository, :version

    def tag_exists? version
      repository.tag_remote? version
    end

    def push_tags
      repository.tag_push.then do |_stdout, stderr, status|
        status.success? && stderr.match?(/[new tag]/)
      end
    end
  end
end
