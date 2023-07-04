# frozen_string_literal: true

require "asciidoctor"

module Milestoner
  module Renderers
    # Renders ASCII Doc as HTML.
    class Asciidoc
      def initialize client: Asciidoctor
        @client = client
      end

      def call(content) = client.convert content

      private

      attr_reader :client
    end
  end
end
