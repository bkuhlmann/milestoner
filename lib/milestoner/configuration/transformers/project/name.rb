# frozen_string_literal: true

require "dry/monads"
require "pathname"

module Milestoner
  module Configuration
    module Transformers
      module Project
        Name = lambda do |content, key = :project_name, default: Pathname.pwd.basename.to_s|
          content.fetch(key) { default }
                 .tap { |value| content[key] = value }

          Dry::Monads::Success content
        end
      end
    end
  end
end
