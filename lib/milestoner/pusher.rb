module Milestoner
  # Handles publishing of Git tags to remote repository.
  class Pusher
    include Aids::Git

    def initialize kernel: Kernel
      @kernel = kernel
    end

    def push
      fail(Errors::Git) unless git_supported?
      fail(Errors::Git, "Git remote repository is not configured.") unless git_remote?
      kernel.system "git push --tags"
    end

    private

    attr_reader :kernel
  end
end
