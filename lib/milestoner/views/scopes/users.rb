# frozen_string_literal: true

require "hanami/view"

module Milestoner
  module Views
    module Scopes
      # Provides users specific behavior for partials.
      class Users < Hanami::View::Scope
        def call = users.any? ? render("milestones/users", users:) : render("milestones/none")
      end
    end
  end
end
