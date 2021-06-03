# frozen_string_literal: true

require "versionaire/extensions/option_parser"
require "refinements/structs"

module Milestoner
  module CLI
    # Handles parsing of Command Line Interface (CLI) primary options.
    module Parsers
      using Refinements::Structs

      # Handles parsing of Command Line Interface (CLI) core options.
      class Core
        def self.call configuration = Configuration::Loader.call, client: CLIENT
          new(configuration, client: client).call
        end

        def initialize configuration = Configuration::Loader.call, client: CLIENT
          @configuration = configuration
          @client = client
        end

        def call arguments = []
          client.banner = "#{Identity::LABEL} - #{Identity::SUMMARY}"
          client.separator "\nUSAGE:\n"
          collate
          arguments.empty? ? arguments : client.parse!(arguments)
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
            configuration.action_config = action
          end
        end

        def add_publish
          client.on(
            "-P",
            "--publish VERSION",
            Versionaire::Version,
            "Tag and push milestone to remote repository."
          ) do |version|
            configuration.merge! action_publish: true, git_tag_version: version
          end
        end

        def add_status
          client.on "-s", "--status", "Show project status." do
            configuration.action_status = true
          end
        end

        def add_version
          client.on "-v", "--version", "Show gem version." do
            configuration.action_version = Identity::VERSION_LABEL
          end
        end

        def add_help
          client.on "-h", "--help", "Show this message." do
            configuration.action_help = true
          end
        end
      end
    end
  end
end
