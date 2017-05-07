# frozen_string_literal: true

module Milestoner
  # Handles publishing of Git tags to remote repository.
  class Pusher
    def initialize git: Git::Kit.new
      @git = git
    end

    def push
      fail(Errors::Git, "Git remote repository not configured.") unless git.remote?
      return if git.push_tags.empty?
      fail(Errors::Git, "Git tags could not be pushed to remote repository.")
    end

    private

    attr_reader :git
  end
end
