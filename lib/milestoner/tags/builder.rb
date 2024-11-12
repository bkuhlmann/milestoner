# frozen_string_literal: true

module Milestoner
  module Tags
    # Builds tag message.
    class Builder
      include Milestoner::Dependencies[:settings, :logger]

      def initialize(enricher: Enricher.new, view: Views::Milestones::Show.new, **)
        super(**)
        @enricher = enricher
        @view = view
      end

      def call version
        force_minimum

        enricher.call
                .fmap { |tags| render tags.first, version }
                .alt_map { |message| failure message }
      end

      private

      attr_reader :enricher, :view

      def force_minimum = settings.build_max = 1

      def render tag, version
        tag.version = version
        view.call(tag:, layout: settings.build_layout, format: :git).to_s.lstrip
      end

      def failure message
        logger.error { message }
        message
      end
    end
  end
end
