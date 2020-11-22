# frozen_string_literal: true

require "forwardable"

module Milestoner
  # Wraps the Git Kit Commit for presentation purposes.
  class Commit
    extend Forwardable

    delegate [*GitPlus::Commit.members, :fixup?, :squash?] => :source

    def initialize source
      @source = source
    end

    def subject_author delimiter: " - "
      "#{subject}#{delimiter}#{author_name}"
    end

    private

    attr_reader :source
  end
end
