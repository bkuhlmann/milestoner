# frozen_string_literal: true

require "dry/schema"
require "etcher"

Dry::Schema.load_extensions :monads

module Milestoner
  module Configuration
    Contract = Dry::Schema.Params do
      required(:documentation_format).filled :string
      required(:prefixes).array :string
      optional(:version).filled :string
    end
  end
end
