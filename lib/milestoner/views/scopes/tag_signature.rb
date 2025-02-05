# frozen_string_literal: true

require "hanami/view"

module Milestoner
  module Views
    module Scopes
      # The tag signature specific behavior for partials.
      class TagSignature < Hanami::View::Scope
        def initialize(part: Parts::Tag.new(value: Models::Tag.new), **)
          super(**)
          @part = part
        end

        def tag = locals.fetch :tag, part

        def call
          tag.signature ? render("milestones/tag-secure") : render("milestones/tag-insecure")
        end

        private

        attr_reader :part
      end
    end
  end
end
