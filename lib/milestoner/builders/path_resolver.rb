# frozen_string_literal: true

require "dry/monads"
require "refinements/pathname"

module Milestoner
  # Safely handles file paths which may or may not exist.
  module Builders
    using Refinements::Pathname

    PathResolver = lambda do |path, logger:, &block|
      if path.exist?
        logger.warn { "Skipped (exists): #{path}." }
      else
        path.make_ancestors
        block.call path if block
        logger.info { "Created: #{path}." }
      end

      Dry::Monads::Success path
    end
  end
end
