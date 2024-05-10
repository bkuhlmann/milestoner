# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module URI
        Commit = lambda do |attributes, key = :commit_uri|
          uri, owner, name, domain = attributes.values_at key,
                                                          :project_owner,
                                                          :project_name,
                                                          :commit_domain

          return Dry::Monads::Success attributes unless uri

          attributes[key] = format uri, domain:, owner:, name:, id: "%<id>s"
          Dry::Monads::Success attributes
        end
      end
    end
  end
end
