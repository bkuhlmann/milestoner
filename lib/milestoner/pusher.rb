module Milestoner
  # Handles publishing of Git tags to remote repository.
  class Pusher
    include Aids::Git

    def initialize kernel: Kernel
      fail(GitError) unless git_supported?
      @kernel = kernel
    end

    def push
      kernel.system "git push --tags"
    end

    private

    attr_reader :kernel
  end
end
