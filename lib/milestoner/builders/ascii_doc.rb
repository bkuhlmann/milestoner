# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds ASCII Doc output.
    class ASCIIDoc
      include Milestoner::Dependencies[:settings, :logger]

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
        settings.build_output
      end

      def write tag
        path = make_path tag

        path.write view.call(tag:, layout: settings.build_layout, format: :adoc)
        logger.info { "Built: #{path}." }
      end

      def make_path tag
        version = settings.build_max == 1 ? "" : tag.version
        settings.build_output.join(version, settings.build_basename).make_ancestors.sub_ext ".adoc"
      end

      def failure message
        logger.error { message }
        message
      end
    end
  end
end
