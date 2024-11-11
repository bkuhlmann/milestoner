# frozen_string_literal: true

require "refinements/binding"

module Milestoner
  module Renderers
    # The primary renderer for multiple input formats as HTML.
    class Universal
      include Dependencies[:settings]

      using Refinements::Binding

      DELEGATES = {asciidoc: Asciidoc.new, markdown: Markdown.new}.freeze

      def initialize(delegates: DELEGATES, **)
        super(**)
        @delegates = delegates
        @default_format = settings.commit_format.to_sym
      end

      def call(content, for: default_format) = delegates.fetch(binding[:for]).call content

      private

      attr_reader :delegates, :default_format
    end
  end
end
