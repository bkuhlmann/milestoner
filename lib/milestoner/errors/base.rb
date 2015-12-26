# frozen_string_literal: true

module Milestoner
  module Errors
    # The base class for all Milestoner related errors.
    class Base < StandardError
      def initialize message = "Invalid Milestoner action."
        super message
      end
    end
  end
end
