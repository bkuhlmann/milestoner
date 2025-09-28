# frozen_string_literal: true

require "gitt"

module Milestoner
  module Models
    COMMIT_COMMON_ATTRIBUTES = %i[
      authored_at
      authored_relative_at
      body
      committed_at
      committed_relative_at
      deletions
      encoding
      files_changed
      fingerprint
      fingerprint_key
      insertions
      notes
      sha
      signature
      subject
    ].freeze

    COMMIT_ENRICHED_ATTRIBUTES = %i[
      author
      body_html
      collaborators
      created_at
      format
      issue
      milestone
      notes_html
      position
      review
      signers
      updated_at
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

      def contributors = [author, *collaborators, *signers].tap(&:uniq!).sort_by! { it.name.to_s }
    end
  end
end
