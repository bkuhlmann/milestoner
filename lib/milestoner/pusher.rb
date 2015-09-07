module Milestoner
  # Handles publishing of Git tags to remote repository.
  class Pusher
    def initialize kernel: Kernel
      @kernel = kernel
    end

    def push
      kernel.system "git push --tags"
    end

    private

    attr_reader :kernel
  end
end
