# frozen_string_literal: true

require "dry/monads"
require "pathname"
require "refinements/string"

module Milestoner
  module Configuration
    module Transformers
      # Conditionally updates label based on current directory.
      module Project
        using Refinements::String

        Label = lambda do |content, key = :project_label, default: Pathname.pwd.basename.to_s|
          content.fetch(key) { default }
                 .tap { |value| content[key] = value.titleize }

          Dry::Monads::Success content
        end
      end
    end
  end
end
