# frozen_string_literal: true

require "dry/monads"
require "pathname"
require "refinements/hash"

module Milestoner
  module Configuration
    module Transformers
      # Ensures build root is expanded.
      module Build
        using Refinements::Hash

        Root = lambda do |attributes, key = :build_root|
          attributes.transform_with! key => -> value { Pathname(value).expand_path }
          Dry::Monads::Success attributes
        end
      end
    end
  end
end
