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
        copy_stylesheet
        write.bind { html_path.parent }
      end

      private

      attr_reader :view, :enricher

      def copy_stylesheet
        file_name = settings.build_stylesheet

        return unless file_name

        settings.build_template_paths
                .map { |path| path.join "public/page.css.erb" }
                .find(&:exist?)
                .copy settings.build_root.make_path.join "#{Pathname(file_name).name}.css"
      end

      def write
        enricher.call.fmap do |commits|
          html_path.write view.call commits:, layout: settings.build_layout
        end
      end

      def html_path = settings.build_root.join "#{settings.build_basename}.html"
    end
  end
end
