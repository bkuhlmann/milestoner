# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds web page output (i.e. HTML and CSS).
    class Web
      include Milestoner::Import[:settings]

      using Refinements::Pathname

      def initialize(view: Views::Milestones::Show.new, enricher: Commits::Enricher.new, **)
        @view = view
        @enricher = enricher
        super(**)
      end

      def call
        settings.build_root.tap do |path|
          stylesheet_path.copy path.make_path.join("page.css")
          write path
        end
      end

      private

      attr_reader :view, :enricher

      def stylesheet_path
        settings.build_template_paths
                .map { |path| path.join "public/page.css.erb" }
                .find(&:exist?)
      end

      def write path
        enricher.call.fmap do |commits|
          path.join("index.html").write view.call commits:, layout: settings.build_layout
        end
      end
    end
  end
end
