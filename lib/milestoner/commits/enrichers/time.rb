# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches raw time as a Time instance.
      class Time
        def initialize key:
          @key = key
        end

        def call(commit) = ::Time.at commit.public_send(key).to_i

        private

        attr_reader :key
      end
    end
  end
end
