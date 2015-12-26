# frozen_string_literal: true

module Milestoner
  module Errors
    # Raised for projects not initialized as Git repositories.
    class Git < Base
      def initialize message = "Invalid Git repository."
        super message
      end
    end
  end
end
