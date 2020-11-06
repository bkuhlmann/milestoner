# frozen_string_literal: true

require "git/kit"

module Milestoner
  # Handles publishing of Git tags to remote repository.
  class Pusher
    def initialize git: Git::Kit::Core.new
      @git = git
    end

    def push version
      version = Versionaire::Version version

      fail Errors::Git, "Remote repository not configured." unless git.remote?
      fail Errors::Git, "Remote tag exists: #{version}." if tag_exists? version
      return if git.push_tags.empty?

      fail Errors::Git, "Tags could not be pushed to remote repository."
    end

    private

    attr_reader :git, :version

    def tag_exists? version
      git.tag_remote? version
    end
  end
end
