# frozen_string_literal: true

require "core"
require "dry/monads"

module Milestoner
  module Tags
    # Handles the creation of project repository tags.
    class Creator
      include Dependencies[:settings, :git, :logger]
      include Dry::Monads[:result]

      def initialize(collector: Commits::Collector.new, builder: Builder.new, **)
        super(**)
        @collector = collector
        @builder = builder
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

      def create version
        builder.call(version).bind { |body| git.tag_create version, "#{subject}\n\n#{body}\n\n" }
      end

      def subject = format(settings.tag_subject, **settings.to_h)
    end
  end
end
