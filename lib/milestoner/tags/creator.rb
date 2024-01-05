# frozen_string_literal: true

require "gitt"
require "refinements/string_io"
require "versionaire"

module Milestoner
  module Tags
    # Handles the creation of project repository tags.
    class Creator
      include Import[:git, :logger]

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

      def call configuration = Container[:configuration]
        return false if local? configuration
        fail Error, "Unable to tag without commits." if collector.call.value_or([]).empty?

        create configuration
      rescue Versionaire::Error => error
        raise Error, error.message
      end

      private

      attr_reader :collector, :builder

      def local? configuration
        version = Version configuration.project_version

        if git.tag_local? version
          logger.warn { "Local tag exists: #{version}. Skipped." }
          true
        else
          false
        end
      end

      def create configuration
        build(configuration).fmap { |body| git.tag_create configuration.project_version, body }
                            .or { |error| fail Error, error }
                            .bind { true }
      end

      def build configuration
        builder.call.fmap do |body|
          "Version #{configuration.project_version}\n\n#{body.reread}\n\n"
        end
      end
    end
  end
end
