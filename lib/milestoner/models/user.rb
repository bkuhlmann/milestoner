# frozen_string_literal: true

module Milestoner
  module Models
    # Represents an external user.
    User = Data.define :external_id, :handle, :name do
      def initialize external_id: nil, handle: nil, name: nil
        super
      end
    end
  end
end
