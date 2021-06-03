# frozen_string_literal: true

require "forwardable"
require "git_plus"

module Milestoner
  module Presenters
    # Wraps the Git Kit Commit for presentation purposes.
    class Commit
      extend Forwardable

      delegate [*GitPlus::Commit.members, :fixup?, :squash?] => :record

      def initialize record, container: Container
        @record = record
        @container = container
      end

      def line_item(delimiter: " - ") = "#{bullet}#{subject}#{delimiter}#{author_name}"

      private

      attr_reader :record, :container

      def bullet
        case container[:configuration].documentation_format
          when "md" then "- "
          when "adoc" then "* "
          else ""
        end
      end
    end
  end
end
