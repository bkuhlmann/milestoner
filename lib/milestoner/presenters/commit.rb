# frozen_string_literal: true

require "forwardable"
require "gitt"

module Milestoner
  module Presenters
    # Wraps the Git Kit Commit for presentation purposes.
    class Commit
      include Import[:configuration]

      extend Forwardable

      delegate [*Gitt::Models::Commit.members, :amend?, :fixup?, :squash?, :prefix?] => :record

      def initialize(record, **)
        super(**)
        @record = record
      end

      def line_item(delimiter: " - ") = "#{bullet}#{subject}#{delimiter}#{author_name}"

      private

      attr_reader :record

      def bullet
        case configuration.commit_format
          when "markdown" then "- "
          when "asciidoc" then "* "
          else ""
        end
      end
    end
  end
end
