# frozen_string_literal: true

require "dry/monads"
require "refinements/pathname"
require "refinements/struct"
require "versionaire"

module Milestoner
  module Commits
    # Assembles all commits for a tag.
    class Tagger
      include Milestoner::Dependencies[:git, :settings, :logger]
      include Enrichers::Dependencies[author_enricher: :author]
      include Dry::Monads[:result]

      using Refinements::Pathname
      using Versionaire::Cast
      using Refinements::Struct

      def initialize(enricher: Commits::Enricher.new, model: Models::Tag, **)
        super(**)
        @enricher = enricher
        @model = model
      end

      def call
        collect.fmap { |tags| tail tags.last(settings.build_max).map(&:version) }
               .fmap { |references| slice(references).reverse }
               .bind { |tags| tags.empty? ? Failure("No tags or commits.") : Success(tags) }
      end

      private

      attr_reader :enricher, :model

      def collect = git.tagged? ? git.tags("--sort=taggerdate") : placeholder_with_commits

      # :reek:FeatureEnvy
      def tail references
        references.append "HEAD" if settings.build_tail == "head"
        references.prepend nil if references.one?
        references
      end

      def slice references
        references.each_cons(2).with_object [] do |(min, max), entries|
          add_enrichment entries, min, max
        end
      end

      def add_enrichment(all, *) = enrich(*).bind { |entry| all.append entry }

      def enrich min, max
        enricher.call(min:, max:).bind { |commits| build_record git.tag_show(max), commits }
      end

      def build_record result, commits
        result.fmap { |tag| record_for tag, commits }
      rescue Versionaire::Error => error
        logger.error error.message
        Failure error
      end

      def record_for tag, commits
        model[
          author: author(tag),
          commits:,
          committed_at: committed_at(tag.committed_at),
          sha: tag.sha,
          signature: tag.signature,
          version: Version(tag.version || settings.project_version),
        ]
      end

      def placeholder_with_commits = enricher.call.fmap { |commits| placeholder_for commits }

      def placeholder_for commits
        return commits if commits.empty?

        [
          model[
            author: commits.last.author,
            commits:,
            committed_at: Time.now,
            version: settings.project_version
          ]
        ]
      end

      def author tag
        author_enricher.call tag.with(author_name: tag.author_name || settings.project_author)
      end

      def committed_at(at) = at ? Time.at(at.to_i) : settings.loaded_at
    end
  end
end
