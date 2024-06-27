# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds I/O stream output.
    class Stream
      include Milestoner::Import[:settings, :logger, :io]

      using Refinements::Pathname

      def initialize(tagger: Commits::Tagger.new, view: Views::Milestones::Show.new, **)
        @tagger = tagger
        @view = view
        super(**)
      end

      def call
        tagger.call
              .fmap { |tags| build tags }
              .alt_map { |message| failure message }
      end

      private

      attr_reader :tagger, :view

      def build tags
        tags.each { |tag| write tag }
        io
      end

      def write(tag) = io.write view.call(tag:, layout: settings.build_layout, format: :stream)

      def failure message
        logger.error { message }
        message
      end
    end
  end
end
