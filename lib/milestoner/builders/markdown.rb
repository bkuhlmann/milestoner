# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds Markdown page output.
    class Markdown
      include Milestoner::Import[:settings, :logger]

      using Refinements::Pathname

      def initialize(view: Views::Milestones::Show.new, enricher: Commits::Enricher.new, **)
        @view = view
        @enricher = enricher
        super(**)
      end

      def call
        enricher.call
                .fmap { |commits| write commits }
                .fmap { |path| success path }
                .alt_map { |message| failure message }
      end

      private

      attr_reader :view, :enricher

      def write commits
        settings.build_root
                .join(settings.build_file)
                .sub("%<extension>s", "md")
                .make_ancestors
                .write view.call(commits:, layout: settings.build_layout, format: :md)
      end

      def success path
        logger.info { "Milestone built: #{path}." }
        path
      end

      def failure message
        logger.error { message }
        message
      end
    end
  end
end
