# frozen_string_literal: true

require "dry/monads"
require "pathname"
require "refinements/hash"
require "refinements/string"

module Milestoner
  module Configuration
    module Transformers
      # Conditionally updates label based on current directory.
      module Project
        using Refinements::String
        using Refinements::Hash

        Label = lambda do |attributes, key = :project_label, default: Pathname.pwd.basename.to_s|
          attributes.fetch_value(key) { default.titleize }
                    .then { |value| Dry::Monads::Success attributes.merge!(key => value) }
        end
      end
    end
  end
end
