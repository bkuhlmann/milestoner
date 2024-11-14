# frozen_string_literal: true

require "refinements/array"
require "refinements/pathname"

module Milestoner
  module Builders
    # Builds web files,
    class Web
      include Milestoner::Dependencies[:settings, :logger]
      include Site::Dependencies[:indexer, :pager, :styler]

      using Refinements::Array
      using Refinements::Pathname

      def initialize(tagger: Tags::Enricher.new, **)
        super(**)
        @tagger = tagger
      end

      def call
        tagger.call
              .fmap { |tags| build tags }
              .alt_map { |message| failure message }
      end

      private

      attr_reader :tagger

      def build tags
        styler.call
        indexer.call tags
        tags.ring { |future, present, past| pager.call past, present, future }
        settings.build_output
      end

      def failure message
        logger.error { message }
        message
      end
    end
  end
end
