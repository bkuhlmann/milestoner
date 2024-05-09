# frozen_string_literal: true

require "core"
require "gitt"
require "refinements/string_io"
require "versionaire"

module Milestoner
  module Tags
    # Handles the creation of project repository tags.
    class Creator
      include Import[:input, :git, :logger]

      using Refinements::StringIO
      using Versionaire::Cast

      def initialize(
        collector: Commits::Collector.new,
        builder: Builders::Stream.new(kernel: StringIO.new),
        **
      )
        @collector = collector
        @builder = builder
        super(**)
      end

      def call override = nil
        version = compute_version override

        return false if local? version

        collection = collector.call.value_or Core::EMPTY_ARRAY

        fail Error, "Unable to tag without commits." if collection.empty?

        create version
      end

      private

      attr_reader :collector, :builder

      def compute_version value
        Version value || input.project_version
      rescue Versionaire::Error => error
        raise Error, error
      end

      def local? version
        if git.tag_local? version
          logger.warn { "Local tag exists: #{version}. Skipped." }
          true
        else
          false
        end
      end

      def create version
        build(version).fmap { |body| git.tag_create version, body }
                      .or { |error| fail Error, error }
                      .bind { true }
      end

      def build version
        builder.call.fmap do |body|
          "Version #{version}\n\n#{body.reread}\n\n"
        end
      end
    end
  end
end
