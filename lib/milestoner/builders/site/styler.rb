# frozen_string_literal: true

require "dry/monads"
require "refinements/pathname"

module Milestoner
  module Builders
    module Site
      # Builds web stylesheet.
      class Styler
        include Milestoner::Dependencies[:settings, :logger]
        include Dry::Monads[:result]

        using Refinements::Pathname

        def initialize(path_resolver: PathResolver, **)
          super(**)
          @path_resolver = path_resolver
        end

        def call
          return Success() unless settings.build_stylesheet

          path = build_path

          path_resolver.call(path, logger:) { copy path }
        end

        private

        attr_reader :path_resolver

        def build_path
          path = Pathname settings.stylesheet_path
          path.absolute? ? path : settings.build_output.join(path)
        end

        def copy build_path
          settings.build_template_paths
                  .map { |template| template.join "public/page.css.erb" }
                  .find(&:exist?)
                  .copy build_path.make_ancestors
        end
      end
    end
  end
end
