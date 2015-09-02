module Milestoner
  # The canonical source of gem information.
  module Identity
    def self.name
      "milestoner"
    end

    def self.label
      "Milestoner"
    end

    def self.version
      "0.1.0"
    end

    def self.label_version
      [label, version].join " "
    end
  end
end
