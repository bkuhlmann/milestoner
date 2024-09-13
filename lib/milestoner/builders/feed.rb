# frozen_string_literal: true

require "dry/monads"
require "refinements/pathname"

module Milestoner
  module Builders
    # Builds syndicated feed output.
    class Feed
      include Milestoner::Import[:settings, :logger]

      using Refinements::Pathname

      def initialize(tagger: Commits::Tagger.new, syndicator: Syndication::Builder.new, **)
        @tagger = tagger
        @syndicator = syndicator
        super(**)
      end

      def call
        tagger.call
              .bind { |tags| syndicator.call tags }
              .fmap { |body| write body }
              .alt_map { |message| failure message }
      end

      private

      attr_reader :tagger, :syndicator

      def write body
        root = settings.build_root
        path = root.join(settings.build_basename).make_ancestors.sub_ext(".xml").write body

        logger.info { "Built: #{path}." }
        root
      end

      def failure message
        logger.error { message }
        message
      end
    end
  end
end
