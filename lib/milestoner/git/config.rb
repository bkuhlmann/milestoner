# frozen_string_literal: true

require "open3"

module Milestoner
  module Git
    # A lightweight Git Config wrapper.
    class Config
      def initialize shell: Open3
        @shell = shell
      end

      def get key
        shell.capture3 "git config --get #{key}"
      end

      def set key, value
        shell.capture3 %(git config --add #{key} "#{value}")
      end

      def value key
        get(key).first.chomp
      end

      private

      attr_reader :shell
    end
  end
end
