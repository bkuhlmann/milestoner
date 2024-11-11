# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches commit notes by rendering as HTML based on trailer information.
      class Note
        include Milestoner::Dependencies[:settings]

        def initialize(key: "Format", renderer: Renderers::Universal.new, **)
          super(**)
          @key = key
          @renderer = renderer
        end

        def call commit
          commit.trailer_value_for(key)
                .value_or(settings.commit_format)
                .then { |format| renderer.call commit.notes, for: format.to_sym }
        end

        private

        attr_reader :key, :renderer
      end
    end
  end
end
