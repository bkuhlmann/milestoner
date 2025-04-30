# frozen_string_literal: true

require "dry/monads"
require "refinements/pathname"
require "refinements/struct"
require "versionaire"

module Milestoner
  module Tags
    # Builds a collection of enriched tags and associated commits.
    class Enricher
      include Milestoner::Dependencies[:git, :settings, :logger]
      include Commits::Enrichers::Dependencies[author_enricher: :author]
      include Dry::Monads[:result]

      using Refinements::Pathname
      using Versionaire::Cast
      using Refinements::Struct

      def initialize(committer: Commits::Enricher.new, model: Models::Tag, **)
        super(**)
        @committer = committer
        @model = model
      end

      def call
        collect.fmap { |tags| adjust tags }
               .fmap { |references| slice(references).reverse }
               .bind { |tags| tags.empty? ? Failure("No tags or commits.") : Success(tags) }
      end

      private

      attr_reader :committer, :model

      def collect = git.tagged? ? git.tags("--sort=taggerdate") : placeholder_with_commits

      def adjust tags
        references = tags.last(settings.build_max).map(&:version)

        maybe_append_head references
        maybe_prepend_nil references, tags
        references
      end

      def maybe_append_head references
        references.append "HEAD" if settings.build_tail == "head"
      end

      def maybe_prepend_nil references, tags
        max =  settings.build_max
        tail = settings.build_tail

        references.prepend nil if references.one? || (tail == "tag" && max >= tags.size)
      end

      def slice references
        references.each_cons(2).with_object [] do |(min, max), entries|
          add_enrichment entries, min, max
        end
      end

      def add_enrichment(all, *) = enrich(*).bind { |entry| all.append entry }

      def enrich min, max
        committer.call(min:, max:).bind { |commits| build_record git.tag_show(max), commits }
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
          version: Version(tag.version || settings.project_version)
        ]
      end

      def placeholder_with_commits = committer.call.fmap { |commits| placeholder_for commits }

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
