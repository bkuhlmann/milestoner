# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds I/O stream output.
    class Stream
      include Milestoner::Import[:settings, :logger, :io]

      using Refinements::Pathname

      def initialize(view: Views::Milestones::Show.new, enricher: Commits::Enricher.new, **)
        @view = view
        @enricher = enricher
        super(**)
      end

      def call
        enricher.call
                .fmap { |commits| write commits }
                .alt_map { |message| failure message }
      end

      private

      attr_reader :view, :enricher

      def write commits
        io.puts view.call(commits:, layout: settings.build_layout, format: :stream)
        io
      end

      def failure message
        logger.error { message }
        message
      end
    end
  end
end
