# frozen_string_literal: true

module Milestoner
  # Handles publishing of Git tags to remote repository.
  class Pusher
    def initialize git: Git.new, kernel: Kernel
      @git = git
      @kernel = kernel
    end

    def push
      fail(Errors::Git) unless git.supported?
      fail(Errors::Git, "Git remote repository not configured.") unless git.remote?
      fail(Errors::Git, "Git tags could not be pushed to remote repository.") unless kernel.system("git push --tags")
    end

    private

    attr_reader :git, :kernel
  end
end
