# frozen_string_literal: true

require "refinements/structs"
require "versionaire/extensions/option_parser"

module Milestoner
  module CLI
    # Handles parsing of Command Line Interface (CLI) primary options.
    module Parsers
      using Refinements::Structs

      # Handles parsing of Command Line Interface (CLI) core options.
      class Core
        include Import[:specification]

        def self.call(...) = new(...).call

        def initialize configuration = Container[:configuration],
                       client: Parser::CLIENT,
                       **dependencies
          super(**dependencies)
          @configuration = configuration
          @client = client
        end

        def call arguments = []
          client.banner = specification.labeled_summary
          client.separator "\nUSAGE:\n"
          collate
          client.parse arguments
          configuration
        end

        private

        attr_reader :configuration, :client

        def collate = private_methods.sort.grep(/add_/).each { |method| __send__ method }

        def add_config
          client.on(
            "-c",
            "--config ACTION",
            %i[edit view],
            "Manage gem configuration. Actions: edit || view."
          ) do |action|
            configuration.merge! action_config: action
          end
        end

        def add_publish
          client.on(
            "-P",
            "--publish VERSION",
            Versionaire::Version,
            "Tag and push milestone to remote repository."
          ) do |version|
            configuration.merge! action_publish: true, version:
          end
        end

        def add_status
          client.on "-s", "--status", "Show project status." do
            configuration.merge! action_status: true
          end
        end

        def add_version
          client.on "-v", "--version", "Show gem version." do
            configuration.merge! action_version: true
          end
        end

        def add_help
          client.on "-h", "--help", "Show this message." do
            configuration.merge! action_help: true
          end
        end
      end
    end
  end
end
