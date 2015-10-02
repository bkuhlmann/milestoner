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
      "1.1.0"
    end

    def self.version_label
      [label, version].join " "
    end

    def self.file_name
      ".#{name}rc"
    end
  end
end
