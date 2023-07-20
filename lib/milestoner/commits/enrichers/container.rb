# frozen_string_literal: true

require "dry-container"

module Milestoner
  module Commits
    module Enrichers
      # Registers all enrichers for injection.
      module Container
        extend Dry::Container::Mixin

        register(:author, memoize: true) { Author.new }
        register(:body, memoize: true) { Body.new }
        register(:collaborators, memoize: true) { Colleague.new key: "Co-authored-by" }
        register(:format, memoize: true) { Format.new }
        register(:issue, memoize: true) { Issue.new }
        register(:milestone) { Milestone.new }
        register(:notes, memoize: true) { Note.new }
        register(:review, memoize: true) { Review.new }
        register(:signers, memoize: true) { Colleague.new key: "Signed-off-by" }
        register(:uri, memoize: true) { URI.new }
      end
    end
  end
end
