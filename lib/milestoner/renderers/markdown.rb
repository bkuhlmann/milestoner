# frozen_string_literal: true

require "redcarpet"

module Milestoner
  module Renderers
    # Renders Markdown as HTML.
    class Markdown
      def initialize client: Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
        @client = client
      end

      def call(content) = client.render content

      private

      attr_reader :client
    end
  end
end
