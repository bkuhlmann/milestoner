# frozen_string_literal: true

module Milestoner
  module Builders
    module Site
      # Defines web dependencies.
      module Container
        extend Containable

        register(:indexer) { Indexer.new }
        register(:pager) { Pager.new }
        register(:styler) { Styler.new }
      end
    end
  end
end
