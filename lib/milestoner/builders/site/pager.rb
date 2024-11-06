# frozen_string_literal: true

module Milestoner
  module Builders
    module Site
      # Builds web version.
      class Pager
        include Milestoner::Dependencies[:settings, :logger]

        def initialize(path_resolver: PathResolver, view: Views::Milestones::Show.new, **)
          super(**)
          @path_resolver = path_resolver
          @view = view
        end

        def call past, tag, future
          settings.project_version = tag.version
          write past, tag, future
        end

        private

        attr_reader :path_resolver, :view

        def write past, tag, future
          path = settings.build_output.join(tag.version, settings.build_basename).sub_ext ".html"

          path_resolver.call path, logger: do
            path.write view.call(past:, tag:, future:, layout: settings.build_layout)
          end
        end
      end
    end
  end
end
