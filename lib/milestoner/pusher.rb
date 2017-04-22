# frozen_string_literal: true

module Milestoner
  # Handles publishing of Git tags to remote repository.
  class Pusher
    def initialize git: Git::Kit.new, shell: Kernel
      @git = git
      @shell = shell
    end

    def push
      fail(Errors::Git, "Git remote repository not configured.") unless git.remote?
      return if shell.system("git push --tags")
      fail(Errors::Git, "Git tags could not be pushed to remote repository.")
    end

    private

    attr_reader :git, :shell
  end
end
