# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module URI
        Profile = lambda do |attributes, key = :profile_uri|
          uri, domain = attributes.values_at key, :profile_domain

          return Dry::Monads::Success attributes unless uri

          attributes[key] = format uri, domain:, id: "%<id>s"
          Dry::Monads::Success attributes
        end
      end
    end
  end
end
