# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      include Import[:defaults_path, :specification, xdg_config: "xdg.config"]

      def initialize(context: Sod::Context, dsl: Sod, **)
        super(**)
        @context = context
        @dsl = dsl
      end

      def call(...) = cli.call(...)

      private

      attr_reader :context, :dsl

      def cli
        context = build_context

        dsl.new :milestoner, banner: specification.banner do
          on(Sod::Prefabs::Commands::Config, context:)
          on Commands::Cache
          on Commands::Build
          on Actions::Publish
          on Actions::Status
          on(Sod::Prefabs::Actions::Version, context:)
          on Sod::Prefabs::Actions::Help, self
        end
      end

      def build_context
        context[defaults_path:, xdg_config:, version_label: specification.labeled_version]
      end
    end
  end
end
