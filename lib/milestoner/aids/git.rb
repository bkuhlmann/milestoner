# frozen_string_literal: true

module Milestoner
  module Aids
    # Augments an object with Git support.
    module Git
      def git_supported?
        File.exist? File.join(Dir.pwd, ".git")
      end

      def git_remote?
        !`git config remote.origin.url`.empty?
      end
    end
  end
end
