# frozen_string_literal: true

module Milestoner
  module Builders
    # Builds Markdown page output.
    class ASCIIDoc
      include Milestoner::Import[:input]

      using Refinements::Pathname

      def initialize(view: Views::Milestones::Show.new, enricher: Commits::Enricher.new, **)
        @view = view
        @enricher = enricher
        super(**)
      end

      def call at: Time.now.utc
        input.build_root.join("index.adoc").make_ancestors.tap { |path| write path, at }
      end

      private

      attr_reader :view, :enricher

      def write path, at
        enricher.call.fmap do |commits|
          path.write view.call commits:, at:, layout: input.build_layout, format: :adoc
        end
      end
    end
  end
end
