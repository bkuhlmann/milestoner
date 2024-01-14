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

        Label = lambda do |content, key = :project_label, default: Pathname.pwd.basename.to_s|
          content.fetch_value(key) { default }
                 .then { |value| Dry::Monads::Success content.merge!(key => value.titleize) }
        end
      end
    end
  end
end
