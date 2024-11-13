# frozen_string_literal: true

module Milestoner
  module Builders
    module MD
      # Builds Markdown index.
      class Indexer
        include Milestoner::Dependencies[:settings, :logger]

        def initialize(path_resolver: PathResolver, view: Views::Milestones::Index.new, **)
          super(**)
          @path_resolver = path_resolver
          @view = view
        end

        def call tags
          path_resolver.call settings.build_output.join("index.md"), logger: do |path|
            path.write view.call(tags:, layout: settings.build_layout, format: :md)
          end
        end

        private

        attr_reader :path_resolver, :view
      end
    end
  end
end
