# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches a commit URI based on trailer information.
      class URI
        include Milestoner::Import[:settings]

        def call(commit) = format settings.commit_uri, id: commit.sha
      end
    end
  end
end
