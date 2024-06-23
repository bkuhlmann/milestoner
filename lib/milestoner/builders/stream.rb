# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds I/O stream output.
    class Stream
      include Milestoner::Import[:settings, :io]

      using Refinements::Pathname

      def initialize(view: Views::Milestones::Show.new, enricher: Commits::Enricher.new, **)
        @view = view
        @enricher = enricher
        super(**)
      end

      def call
        enricher.call.fmap do |commits|
          io.puts view.call(commits:, layout: settings.build_layout, format: :stream)
          io
        end
      end

      private

      attr_reader :view, :enricher
    end
  end
end
