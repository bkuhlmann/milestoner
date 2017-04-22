# frozen_string_literal: true

module Milestoner
  module Git
    # A lightweight Git wrapper.
    class Kit
      def initialize
        @git_dir = File.join Dir.pwd, ".git"
      end

      def supported?
        File.exist? git_dir
      end

      def commits?
        !shell("git log").empty?
      end

      def push_tags
        shell "git push --tags"
      end

      def tagged?
        !shell("git tag").empty?
      end

      def tag_local? tag
        shell("git tag --list #{tag}").match?(/\A#{tag}\Z/)
      end

      def tag_remote? tag
        shell("git ls-remote --tags origin #{tag}").match?(%r(.+tags\/#{tag}\Z))
      end

      def remote?
        !shell("git config remote.origin.url").empty?
      end

      private

      attr_reader :git_dir

      def shell command
        String `#{command}`
      end
    end
  end
end
