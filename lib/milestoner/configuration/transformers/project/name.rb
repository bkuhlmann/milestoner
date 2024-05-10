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

        Name = lambda do |attributes, key = :project_name, default: Pathname.pwd.basename.to_s|
          attributes.fetch_value(key) { default }
                    .then { |value| Dry::Monads::Success attributes.merge!(key => value) }
        end
      end
    end
  end
end
