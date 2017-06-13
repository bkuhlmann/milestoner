# frozen_string_literal: true

module Milestoner
  # Gem identity information.
  module Identity
    def self.name
      "milestoner"
    end

    def self.label
      "Milestoner"
    end

    def self.version
      "5.1.0"
    end

    def self.version_label
      "#{label} #{version}"
    end
  end
end
