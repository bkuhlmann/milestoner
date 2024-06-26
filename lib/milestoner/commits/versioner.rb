# frozen_string_literal: true

require "core"
require "dry/monads"
require "versionaire"

module Milestoner
  module Commits
    # Calculates next version based on commit trailer version keys.
    class Versioner
      include Import[:git, :logger]
      include Dry::Monads[:result]

      using Versionaire::Cast

      DEFAULTS = {trailer_key: "Milestone", fallback: Versionaire::Version.new}.freeze

      def initialize(defaults: DEFAULTS, collector: Collector.new, **)
        @defaults = defaults
        @collector = collector
        super(**)
      end

      def call
        trailer_milestones.then { |milestones| bump milestones }
                          .value_or(fallback)
      end

      private

      attr_reader :defaults, :collector

      def trailer_milestones
        collector.call.value_or(Core::EMPTY_ARRAY).each.with_object [] do |commit, values|
          commit.trailer_value_for(trailer_key).bind { |milestone| values.append milestone.to_sym }
        end
      end

      def bump milestones
        last_tag_or_fallback_for milestones
      rescue Versionaire::Error => error
        logger.debug { error.message }
        Failure error
      end

      def last_tag_or_fallback_for milestones
        target = fallback.members.intersection(milestones).first
        git.tag_last.fmap { |tag| target ? Version(tag).bump(target) : fallback }
      end

      def trailer_key = defaults.fetch __method__

      def fallback = defaults.fetch __method__
    end
  end
end
