# frozen_string_literal: true

require "dry/monads"
require "pathname"
require "refinements/hash"

module Milestoner
  module Configuration
    module Transformers
      # Conditionally updates name based on current directory.
      module Project
        using Refinements::Hash

        Name = lambda do |content, key = :project_name, default: Pathname.pwd.basename.to_s|
          content.fetch_value(key) { default }
                 .then { |value| Dry::Monads::Success content.merge!(key => value) }
        end
      end
    end
  end
end
