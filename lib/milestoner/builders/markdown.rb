# frozen_string_literal: true

require "refinements/array"
require "refinements/pathname"

module Milestoner
  module Builders
    # Builds Markdown files.
    class Markdown
      include Milestoner::Dependencies[:settings, :logger]
      include MD::Dependencies[:indexer, :pager]

      using Refinements::Array
      using Refinements::Pathname

      def initialize(tagger: Commits::Tagger.new, view: Views::Milestones::Show.new, **)
        super(**)
        @tagger = tagger
        @view = view
      end

      def call
        tagger.call
              .fmap { |tags| build tags }
              .alt_map { |message| failure message }
      end

      private

      attr_reader :tagger, :view

      def build tags
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
