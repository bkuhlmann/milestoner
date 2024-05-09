# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module URI
        Profile = lambda do |content, key = :profile_uri|
          domain, uri = content.values_at :profile_domain, key

          return Dry::Monads::Success content unless uri

          content[key] = format uri, domain:, id: "%<id>s"
          Dry::Monads::Success content
        end
      end
    end
  end
end
