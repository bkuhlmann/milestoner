# frozen_string_literal: true

require "pathname"
require "refinements/hashes"
require "refinements/structs"
require "runcom"
require "yaml"

module Milestoner
  module Configuration
    # Represents the fully assembled Command Line Interface (CLI) configuration.
    class Loader
      using Refinements::Hashes
      using Refinements::Structs

      DEFAULTS = YAML.load_file(Pathname(__dir__).join("defaults.yml")).freeze
      HANDLER = Runcom::Config.new "#{Identity::NAME}/configuration.yml", defaults: DEFAULTS

      def self.call = new.call

      def self.with_defaults = new(handler: DEFAULTS)

      def initialize content: Content.new, handler: HANDLER
        @content = content
        @handler = handler
      end

      def call = content.merge(**handler.to_h.flatten_keys)

      private

      attr_reader :content, :handler
    end
  end
end
