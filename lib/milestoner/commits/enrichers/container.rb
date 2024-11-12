# frozen_string_literal: true

require "containable"

module Milestoner
  module Commits
    module Enrichers
      # Registers all enrichers for injection.
      module Container
        extend Containable

        register(:author) { Author.new }
        register(:body_html) { Body.new }
        register(:collaborators) { Colleague.new key: "Co-authored-by" }
        register(:created_at) { Time.new key: :authored_at }
        register(:format) { Format.new }
        register(:issue) { Issue.new }
        register(:milestone) { Milestone.new }
        register(:notes_html) { Note.new }
        register(:review) { Review.new }
        register(:signers) { Colleague.new key: "Signed-off-by" }
        register(:updated_at) { Time.new key: :committed_at }
        register(:uri) { URI.new }
      end
    end
  end
end
