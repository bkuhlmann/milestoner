# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds I/O stream output.
    class Stream
      include Milestoner::Import[:settings, :kernel]

      using Refinements::Pathname

      def initialize(view: Views::Milestones::Show.new, enricher: Commits::Enricher.new, **)
        @view = view
        @enricher = enricher
        super(**)
      end

      def call
        enricher.call.fmap do |commits|
          kernel.puts view.call(commits:, layout: settings.build_layout, format: :stream).to_s
          kernel
        end
      end

      private

      attr_reader :view, :enricher
    end
  end
end
