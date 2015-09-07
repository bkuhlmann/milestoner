module Milestoner
  # Raised for invalid version formats.
  class VersionError < StandardError
  end

  # Raised for duplicate tags.
  class DuplicateTagError < StandardError
  end
end
