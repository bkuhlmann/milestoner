# frozen_string_literal: true

require "asciidoctor"

module Milestoner
  module Renderers
    # Renders ASCII Doc as HTML.
    class Asciidoc
      SETTINGS = {
        safe: :safe,
        attributes: {
          "source-highlighter" => "rouge",
          "rouge-linenums-mode" => "inline"
        }
      }.freeze

      def initialize settings: SETTINGS, client: Asciidoctor
        @settings = settings
        @client = client
      end

      def call(content) = client.convert content, settings

      private

      attr_reader :settings, :client
    end
  end
end
