# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds Markdown page output.
    class Markdown
      include Milestoner::Import[:settings]

      using Refinements::Pathname

      def initialize(view: Views::Milestones::Show.new, enricher: Commits::Enricher.new, **)
        @view = view
        @enricher = enricher
        super(**)
      end

      def call = settings.build_root.join("index.md").make_ancestors.tap { |path| write path }

      private

      attr_reader :view, :enricher

      def write path
        enricher.call.fmap do |commits|
          path.write view.call commits:, layout: settings.build_layout, format: :md
        end
      end
    end
  end
end
