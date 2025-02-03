# frozen_string_literal: true

require "core"
require "json"
require "refinements/hash"
require "refinements/pathname"

module Milestoner
  module Tags
    # Manages build manifest.
    class Manifest
      include Dependencies[:settings, :git]

      using Refinements::Hash
      using Refinements::Pathname

      def initialize(name: "manifest.json", **)
        super(**)
        @name = name
      end

      def build_path = settings.build_output.join name

      def diff path = build_path
        git.tags.value_or(Core::EMPTY_ARRAY).then do |tags|
          return Core::EMPTY_HASH if tags.empty?

          content_for(tags).diff read(path)
        end
      end

      def read(path = build_path) = JSON(path.read, {symbolize_names: true})

      def write(path = build_path, **)
        path.make_ancestors.write JSON.pretty_generate(generator.deep_merge(**))
      end

      private

      attr_reader :name

      # :reek:FeatureEnvy
      def content_for tags
        generator.merge latest: tags.last.version, versions: tags.map(&:version)
      end

      def generator
        {generator: {label: settings.generator_label, version: settings.generator_version.to_s}}
      end
    end
  end
end
