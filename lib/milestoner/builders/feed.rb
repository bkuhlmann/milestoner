# frozen_string_literal: true

require "dry/monads"
require "refinements/pathname"

module Milestoner
  module Builders
    # Builds syndicated feed output.
    class Feed
      include Milestoner::Import[:settings, :logger]
      include Dry::Monads[:result]

      using Refinements::Pathname

      def initialize(tagger: Commits::Tagger.new, syndicator: Syndication::Builder.new, **)
        @tagger = tagger
        @syndicator = syndicator
        super(**)
      end

      def call
        tagger.call
              .bind { |milestones| syndicator.call milestones }
              .fmap { |body| write body }
              .fmap { |path| success path }
              .alt_map { |message| failure message }
      end

      private

      attr_reader :tagger, :syndicator

      def write body
        settings.build_root
                .join(settings.build_file)
                .sub("%<extension>s", "xml")
                .make_ancestors
                .write body
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
