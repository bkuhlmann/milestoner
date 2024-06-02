# frozen_string_literal: true

module Milestoner
  module Renderers
    # The primary renderer for multiple input formats as HTML.
    class Universal
      include Import[:settings]

      DELEGATES = {asciidoc: Asciidoc.new, markdown: Markdown.new}.freeze

      def initialize(delegates: DELEGATES, **)
        super(**)
        @delegates = delegates
        @default_format = settings.commit_format.to_sym
      end

      def call content, for: default_format
        delegates.fetch(binding.local_variable_get(:for)).call content
      end

      private

      attr_reader :delegates, :default_format
    end
  end
end
