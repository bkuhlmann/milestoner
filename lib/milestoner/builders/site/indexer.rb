# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Builders
    module Site
      # Builds web index.
      class Indexer
        include Dry::Monads[:result]
        include Milestoner::Dependencies[:settings, :logger]

        def initialize(path_resolver: PathResolver, view: Views::Milestones::Index.new, **)
          super(**)
          @path_resolver = path_resolver
          @view = view
        end

        def call tags
          return Success() unless settings.build_index

          path_resolver.call settings.build_output.join("index.html"), logger: do |path|
            settings.project_version = nil
            path.write view.call(tags:, layout: settings.build_layout)
          end
        end

        private

        attr_reader :path_resolver, :view
      end
    end
  end
end
