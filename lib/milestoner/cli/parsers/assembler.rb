# frozen_string_literal: true

require "runcom"

module Milestoner
  module CLI
    module Parsers
      SECTIONS = [Core, Security].freeze # Order is important.

      # Assembles and parses all Command Line Interface (CLI) options.
      class Assembler
        def initialize configuration = CLI::Configuration::Loader.call,
                       sections: SECTIONS,
                       client: CLIENT
          @configuration = configuration
          @sections = sections
          @client = client
        end

        def call arguments = []
          sections.each { |parser| parser.call configuration, client: client }
          client.parse! arguments
          configuration
        end

        def to_s = client.to_s

        private

        attr_reader :configuration, :client, :sections
      end
    end
  end
end
