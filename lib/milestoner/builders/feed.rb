# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds syndicated feed output.
    class Feed
      include Milestoner::Dependencies[:logger]

      using Refinements::Pathname

      def initialize(tagger: Commits::Tagger.new, indexer: Syndication::Indexer.new, **)
        super(**)
        @tagger = tagger
        @indexer = indexer
      end

      def call
        tagger.call
              .bind { |tags| indexer.call tags }
              .alt_map { |message| failure message }
      end

      private

      attr_reader :tagger, :indexer

      def failure message
        logger.error { message }
        message
      end
    end
  end
end
