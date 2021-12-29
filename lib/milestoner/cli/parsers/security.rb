# frozen_string_literal: true

require "refinements/structs"

module Milestoner
  module CLI
    module Parsers
      # Handles parsing of Command Line Interface (CLI) security options.
      class Security
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration = Container[:configuration],
                       client: Parser::CLIENT,
                       container: Container
          @configuration = configuration
          @client = client
          @container = container
        end

        def call arguments = []
          client.separator "\nSECURITY OPTIONS:\n"
          add_sign
          client.parse arguments
          configuration
        end

        private

        attr_reader :configuration, :client, :container

        def add_sign
          client.on(
            "--[no-]sign",
            %(Sign with GPG key. Default: #{configuration.sign}.)
          ) do |value|
            compute_sign value
          end
        end

        def compute_sign value
          truth_table = [true, false].repeated_permutation(2).to_a

          case truth_table.index [value, configuration.sign]
            when 0..1 then configuration.merge! sign: true
            when 2..3 then configuration.merge! sign: false
            else logger.error { "--sign must be a boolean. Check gem configuration." }
          end
        end

        def logger = container[__method__]
      end
    end
  end
end
