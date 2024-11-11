# frozen_string_literal: true

module Milestoner
  module Builders
    # Builds I/O stream output.
    class Stream
      include Milestoner::Dependencies[:settings, :logger, :io]

      def initialize(tagger: Commits::Tagger.new, view: Views::Milestones::Show.new, **)
        super(**)
        @tagger = tagger
        @view = view
      end

      def call
        tagger.call
              .fmap { |tags| write tags }
              .alt_map { |message| failure message }
      end

      private

      attr_reader :tagger, :view

      def write(tags) = build(tags).tap { |content| io.write content }

      def build tags
        tags.reduce([]) { |content, tag| content.append render(tag) }
            .join(%(\n#{"-" * 80}\n\n))
      end

      def render(tag) = view.call tag:, layout: settings.build_layout, format: :stream

      def failure message
        logger.error { message }
        message
      end
    end
  end
end
