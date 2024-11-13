# frozen_string_literal: true

module Milestoner
  module Builders
    module ADoc
      # Defines ASCII Doc dependencies.
      module Container
        extend Containable

        register(:indexer) { Indexer.new }
        register(:pager) { Pager.new }
      end
    end
  end
end
