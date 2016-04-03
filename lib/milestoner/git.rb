# frozen_string_literal: true

module Milestoner
  # A lightweight Git wrapper.
  class Git
    def supported?
      File.exist? File.join(Dir.pwd, ".git")
    end

    def commits?
      system "git log > /dev/null 2>&1"
    end

    def remote?
      system "git config remote.origin.url"
    end
  end
end
