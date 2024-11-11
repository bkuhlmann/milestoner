# frozen_string_literal: true

require "core"
require "dry/monads"

module Milestoner
  module Tags
    # Handles the creation of project repository tags.
    class Creator
      include Dependencies[:git, :logger]
      include Dry::Monads[:result]

      def initialize(
        collector: Commits::Collector.new,
        builder: Builders::Stream.new(io: StringIO.new),
        **
      )
        @collector = collector
        @builder = builder
        super(**)
      end

      def call version
        return Success version if local? version

        collect.bind { create version }
      end

      private

      attr_reader :collector, :builder

      def local? version
        if git.tag_local? version
          logger.warn { "Local tag exists: #{version}. Skipped." }
          true
        else
          false
        end
      end

      def collect = collector.call.alt_map { |message| message.sub("fatal: y", "Y").sub("\n", ".") }

      def create(version) = build(version).bind { |body| git.tag_create version, body }

      def build(version) = builder.call.fmap { |body| "Version #{version}\n\n#{body}\n\n" }
    end
  end
end
