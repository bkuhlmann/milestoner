# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches commit text by rendering as HTML based on trailer information.
      class Body
        include Milestoner::Import[:input]

        def initialize(key: "Format", renderer: Renderers::Universal.new, **)
          @key = key
          @renderer = renderer
          super(**)
        end

        def call commit
          commit.trailer_value_for(key)
                .value_or(input.commit_format)
                .then { |format| renderer.call commit.body, for: format.to_sym }
        end

        private

        attr_reader :key, :renderer
      end
    end
  end
end
