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

        Root = lambda do |content, key = :build_root|
          content.transform_with! key => -> value { Pathname(value).expand_path }
          Dry::Monads::Success content
        end
      end
    end
  end
end
