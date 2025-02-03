# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Builders
    # Builds JSON manifest.
    class Manifest
      include Dry::Monads[:result]
      include Milestoner::Dependencies[:settings, :git, :logger]

      def initialize(writer: Tags::Manifest.new, path_resolver: PathResolver, **)
        super(**)
        @writer = writer
        @path_resolver = path_resolver
      end

      def call
        return Success writer.build_path unless settings.build_manifest

        git.tags.either -> tags { write tags }, -> message { failure message }
      end

      private

      attr_reader :writer, :path_resolver

      def write tags
        path_resolver.call writer.build_path, logger: do
          versions = tags.map(&:version)
          writer.write latest: versions.last, versions:
        end
      end

      def failure message
        logger.error { message }
        Failure message
      end
    end
  end
end
