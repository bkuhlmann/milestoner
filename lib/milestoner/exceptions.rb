module Milestoner
  # Raised for projects not initialized as Git repositories.
  class GitError < StandardError
    def initialize message = "Invalid Git repository."
      super message
    end
  end

  # Raised for invalid version formats.
  class VersionError < StandardError
  end

  # Raised for duplicate tags.
  class DuplicateTagError < StandardError
  end
end
