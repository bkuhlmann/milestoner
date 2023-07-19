# frozen_string_literal: true

module Milestoner
  module Models
    # Represents a hyperlink.
    Link = Data.define :id, :uri do
      def initialize id: nil, uri: nil
        super
      end
    end
  end
end
