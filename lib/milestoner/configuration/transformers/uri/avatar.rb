# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module URI
        Avatar = lambda do |attributes, key = :avatar_uri|
          uri, domain = attributes.values_at key, :avatar_domain

          return Dry::Monads::Success attributes unless uri

          attributes[key] = format uri, domain:, id: "%<id>s"
          Dry::Monads::Success attributes
        end
      end
    end
  end
end
