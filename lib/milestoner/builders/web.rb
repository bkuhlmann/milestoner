# frozen_string_literal: true

require "refinements/pathname"

module Milestoner
  module Builders
    # Builds web output (i.e. HTML and CSS).
    class Web
      include Milestoner::Import[:settings, :logger]

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
        make_root
        copy_stylesheet
        tags.each { |tag| write tag }
        settings.build_root
      end

      def make_root = settings.build_root.make_path

      def copy_stylesheet
        return unless settings.build_stylesheet

        stylesheet_template.copy stylesheet_path
        logger.info { "Built: #{stylesheet_path}." }
      end

      def stylesheet_template
        settings.build_template_paths
                .map { |path| path.join "public/page.css.erb" }
                .find(&:exist?)
                .copy settings.build_root.make_path.join stylesheet_path
      end

      def stylesheet_path
        settings.build_root.join "#{Pathname(settings.build_stylesheet).name}.css"
      end

      def write tag
        path = make_path tag
        settings.project_version = tag.version

        path.write view.call(tag:, layout: settings.build_layout)
        logger.info { "Built: #{path}." }
      end

      def make_path tag
        version = settings.build_max == 1 ? "" : tag.version
        settings.build_root.join(version, settings.build_basename).make_ancestors.sub_ext ".html"
      end

      def failure message
        logger.error { message }
        message
      end
    end
  end
end
