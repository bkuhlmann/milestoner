# frozen_string_literal: true

require "hanami/view"
require "refinements/array"

module Milestoner
  module Views
    module Scopes
      # The contributor specific behavior for partials.
      class Contributors < Hanami::View::Scope
        using Refinements::Array

        def sentence = all.map(&:name).to_sentence

        def call = (render("milestones/contributors", all:) if all.any?)
      end
    end
  end
end
