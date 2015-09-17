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
      "0.5.0"
    end

    def self.version_label
      [label, version].join " "
    end

    def self.file_name
      ".#{name}rc"
    end
  end
end
