# frozen_string_literal: true

require "refinements/structs"
require "sod"

module Milestoner
  module CLI
    module Actions
      # Handles tag creation and pushing of tag to local repository.
      class Publish < Sod::Action
        include Import[:configuration]

        using Refinements::Structs

        description "Publish milestone."

        ancillary "(tags and pushes to remote repository)"

        on %w[-p --publish], argument: "VERSION"

        def initialize(publisher: Tags::Publisher.new, **)
          super(**)
          @publisher = publisher
        end

        def call(version) = publisher.call configuration.merge(version:)

        private

        attr_reader :publisher
      end
    end
  end
end
