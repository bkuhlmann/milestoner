# frozen_string_literal: true

require "gitt"

module Milestoner
  module Models
    COMMIT_COMMON_ATTRIBUTES = %i[
      authored_at
      body
      deletions
      files_changed
      insertions
      notes
      sha
      signature
      subject
    ].freeze

    COMMIT_ENRICHED_ATTRIBUTES = %i[
      author
      collaborators
      format
      issue
      milestone
      review
      signers
      uri
    ].freeze

    # Represents an enriched commit.
    Commit = Struct.new(*COMMIT_COMMON_ATTRIBUTES, *COMMIT_ENRICHED_ATTRIBUTES) do
      include Gitt::Directable

      def self.for(commit, **) = new(**commit.to_h.slice(*COMMIT_COMMON_ATTRIBUTES), **)

      def initialize(**)
        super
        freeze
      end
    end
  end
end
