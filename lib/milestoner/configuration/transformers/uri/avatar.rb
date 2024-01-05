# frozen_string_literal: true

require "dry/monads"
require "pathname"

module Milestoner
  module Configuration
    module Transformers
      module URI
        Avatar = lambda do |content, key = :avatar_uri|
          domain, uri = content.values_at :avatar_domain, key

          return Dry::Monads::Success content unless uri

          content[key] = format uri, domain:, id: "%<id>s"
          Dry::Monads::Success content
        end
      end
    end
  end
end
