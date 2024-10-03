# frozen_string_literal: true

require "core"
require "hanami/view"

module Milestoner
  module Views
    module Scopes
      # The content specific behavior for partials.
      class Content < Hanami::View::Scope
        def content = String locals.fetch(:content, Core::EMPTY_STRING)

        def call = content.empty? ? render("milestones/none") : render("milestones/content")
      end
    end
  end
end
