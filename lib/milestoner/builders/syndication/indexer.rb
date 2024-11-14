# frozen_string_literal: true

module Milestoner
  module Builders
    module Syndication
      # Builds syndicated feed output.
      class Indexer
        include Milestoner::Dependencies[:settings, :logger]

        def initialize(path_resolver: PathResolver, syndicator: Syndication::Builder.new, **)
          super(**)
          @path_resolver = path_resolver
          @syndicator = syndicator
        end

        def call(tags) = syndicator.call(tags).bind { |body| write body }

        private

        attr_reader :path_resolver, :syndicator

        def write body
          path = settings.build_output.join(settings.build_basename).sub_ext(".xml")
          path_resolver.call(path, logger:) { path.write body }
        end
      end
    end
  end
end
