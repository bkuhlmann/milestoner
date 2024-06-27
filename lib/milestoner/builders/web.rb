# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds web page output (i.e. HTML and CSS).
    class Web
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
        copy_stylesheet

        settings.build_root
                .join(settings.build_file)
                .sub("%<extension>s", "html")
                .write view.call(commits:, layout: settings.build_layout)
      end

      def copy_stylesheet
        file_name = settings.build_stylesheet

        return unless file_name

        stylesheet_template_path.copy settings.build_root.make_path.join "#{file_name}.css"
      end

      def stylesheet_template_path
        settings.build_template_paths
                .map { |path| path.join "public/page.css.erb" }
                .find(&:exist?)
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
