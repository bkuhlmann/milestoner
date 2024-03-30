# frozen_string_literal: true

require "containable"

module Milestoner
  module Builders
    # Registers all builders for injection.
    module Container
      extend Containable

      register(:ascii_doc) { ASCIIDoc.new }
      register(:markdown) { Markdown.new }
      register(:stream) { Stream.new }
      register(:web) { Web.new }
    end
  end
end
