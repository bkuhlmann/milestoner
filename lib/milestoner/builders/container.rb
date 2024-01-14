# frozen_string_literal: true

require "dry-container"

module Milestoner
  module Builders
    # Registers all builders for injection.
    module Container
      extend Dry::Container::Mixin

      register(:ascii_doc, memoize: true) { ASCIIDoc.new }
      register(:markdown, memoize: true) { Markdown.new }
      register(:stream, memoize: true) { Stream.new }
      register(:web, memoize: true) { Web.new }
    end
  end
end
