# frozen_string_literal: true

require "hanami/view"

module Milestoner
  module Views
    module Parts
      # The user presentation logic.
      class User < Hanami::View::Part
        include Import[:settings]

        def name = value.name.then { |text| text || "Unknown" }

        def image_alt = value.name.then { |name| name || "missing" }

        def avatar_url
          value.name.then do |name|
            return format settings.avatar_uri, id: value.external_id if name

            "https://alchemists.io/images/projects/milestoner/icons/missing.png"
          end
        end

        def profile_url
          value.name.then do |name|
            name ? format(settings.profile_uri, id: value.handle) : "/#unknown"
          end
        end
      end
    end
  end
end
