# frozen_string_literal: true

require "redcarpet"
require "refinements/module"
require "rouge"
require "rouge/plugins/redcarpet"

module Milestoner
  module Renderers
    # Renders Markdown as HTML.
    class Markdown
      using Refinements::Module

      CLIENT = Redcarpet::Markdown.new Class.new(Redcarpet::Render::HTML)
                                            .include(Rouge::Plugins::Redcarpet)
                                            .pseudonym("redcarpet_html_rouge")
                                            .new,
                                       disable_indented_code_blocks: true,
                                       fenced_code_blocks: true,
                                       footnotes: true,
                                       highlight: true,
                                       superscript: true,
                                       tables: true

      def initialize client: CLIENT
        @client = client
      end

      def call(content) = client.render content

      private

      attr_reader :client
    end
  end
end
