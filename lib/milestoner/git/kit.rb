# frozen_string_literal: true

module Milestoner
  module Git
    # A lightweight Git wrapper.
    class Kit
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
end
