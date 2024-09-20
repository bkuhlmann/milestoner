# frozen_string_literal: true

require "core"
require "hanami/view"

module Milestoner
  module Views
    module Scopes
      # Provides logo specific behavior for partials.
      class Logo < Hanami::View::Scope
        def call = project_uri_logo ? render("milestones/logo") : Core::EMPTY_STRING
      end
    end
  end
end
