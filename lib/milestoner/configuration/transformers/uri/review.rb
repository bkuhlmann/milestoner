# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module URI
        Review = lambda do |attributes, key = :review_uri|
          uri, owner, name, domain = attributes.values_at key,
                                                          :project_owner,
                                                          :project_name,
                                                          :review_domain

          return Dry::Monads::Success attributes unless uri

          attributes[key] = format uri, domain:, owner:, name:, id: "%<id>s"
          Dry::Monads::Success attributes
        end
      end
    end
  end
end
