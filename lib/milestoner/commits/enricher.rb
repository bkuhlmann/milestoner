# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Commits
    # Enriches commits and associated trailers for final processing.
    class Enricher
      include Import[:settings]

      include Enrichers::Import[
        :author,
        :body,
        :collaborators,
        :created_at,
        :format,
        :issue,
        :milestone,
        :notes,
        :review,
        :signers,
        :updated_at,
        :uri
      ]

      include Dry::Monads[:result]

      def initialize(categorizer: Commits::Categorizer.new, model: Models::Commit, **)
        super(**)
        @categorizer = categorizer
        @model = model
      end

      def call min: Collector::MIN, max: Collector::MAX
        categorizer.call(min:, max:)
                   .map { |commit| model.for(commit, **build_attributes(commit)) }
                   .then { |commits| Success commits }
      end

      private

      attr_reader :categorizer, :model

      def build_attributes commit
        infused_keys.each.with_object({}) do |key, attributes|
          attributes[key] = __send__(key).call commit
        end
      end
    end
  end
end
