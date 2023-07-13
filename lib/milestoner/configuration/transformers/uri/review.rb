# frozen_string_literal: true

require "dry/monads"
require "pathname"

module Milestoner
  module Configuration
    module Transformers
      module URI
        Review = lambda do |content, key = :review_uri|
          owner, name, domain, uri = content.values_at :project_owner,
                                                       :project_name,
                                                       :review_domain,
                                                       key

          return Dry::Monads::Success content unless uri

          content[key] = format uri, domain:, owner:, name:, id: "%<id>s"
          Dry::Monads::Success content
        end
      end
    end
  end
end
