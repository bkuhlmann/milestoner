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
          attributes.fetch(key) { attributes.merge!(key => default.titleize).compress! }
          Dry::Monads::Success attributes
        end
      end
    end
  end
end
