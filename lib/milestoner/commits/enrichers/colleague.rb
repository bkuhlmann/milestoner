# frozen_string_literal: true

require "gitt"

module Milestoner
  module Commits
    module Enrichers
      # Enriches a commit colleague by using cache.
      class Colleague
        include Milestoner::Import[:cache]

        def initialize(key:, parser: Gitt::Parsers::Person.new, **)
          super(**)
          @key = key
          @parser = parser
        end

        def call(commit) = commit.find_trailers(key).bind { |trailers| users_for(trailers).compact }

        private

        attr_reader :key, :parser

        def users_for(trailers) = trailers.map { |trailer| user_for parser.call(trailer.value) }

        def user_for person
          cache.read(:users) { find person.name }
               .value_or(nil)
        end
      end
    end
  end
end
