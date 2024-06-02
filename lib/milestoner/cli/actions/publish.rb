# frozen_string_literal: true

require "sod"
require "versionaire"

module Milestoner
  module CLI
    module Actions
      # Handles tag creation and pushing of tag to local repository.
      class Publish < Sod::Action
        include Import[:settings]

        using Versionaire::Cast

        description "Publish milestone."

        ancillary "Build, commit, tag, and push to remote repository."

        on %w[-p --publish], argument: "[VERSION]"

        default { Container[:settings].project_version }

        def initialize(publisher: Tags::Publisher.new, **)
          super(**)
          @publisher = publisher
        end

        def call(version = nil) = publisher.call Version(version || default)

        private

        attr_reader :publisher
      end
    end
  end
end
