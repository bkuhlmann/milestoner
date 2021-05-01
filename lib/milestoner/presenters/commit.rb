# frozen_string_literal: true

require "forwardable"
require "git_plus"

module Milestoner
  module Presenters
    # Wraps the Git Kit Commit for presentation purposes.
    class Commit
      extend Forwardable

      delegate [*GitPlus::Commit.members, :fixup?, :squash?] => :record

      def initialize record
        @record = record
      end

      def subject_author(delimiter: " - ") = "#{subject}#{delimiter}#{author_name}"

      private

      attr_reader :record
    end
  end
end
