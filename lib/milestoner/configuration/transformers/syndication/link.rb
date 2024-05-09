# frozen_string_literal: true

require "core"
require "dry/monads"
require "refinements/hash"

module Milestoner
  module Configuration
    module Transformers
      # Conditionally updates links based on project details.
      module Syndication
        using Refinements::Hash

        Link = lambda do |attributes, key = :syndication_links|
          links = attributes.fetch key, Core::EMPTY_ARRAY

          links.each do |link|
            link.symbolize_keys!

            link[:label] = format link[:label], attributes
            link[:uri] = format link[:uri], attributes
          end

          Dry::Monads::Success attributes.merge!(key => links)
        rescue KeyError => error
          Dry::Monads::Failure step: :transform,
                               payload: "Unable to transform #{key.inspect}, missing specifier: " \
                                        "\"#{error.message[/<.+>/]}\"."
        end
      end
    end
  end
end
