# frozen_string_literal: true

module Milestoner
  module Configuration
    # Defines configuration content as the primary source of truth for use throughout the gem.
    Model = Struct.new :documentation_format, :prefixes, :version do
      def initialize(**)
        super
        freeze
      end
    end
  end
end
