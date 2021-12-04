# frozen_string_literal: true

require "runcom"

module Milestoner
  module CLI
    module Parsers
      SECTIONS = [Core, Security].freeze # Order is important.

      # Assembles and parses all Command Line Interface (CLI) options.
      class Assembler
        def initialize sections: SECTIONS, client: CLIENT, container: Container
          @sections = sections
          @client = client
          @configuration = container[:configuration].dup
        end

        def call arguments = []
          sections.each { |parser| parser.call configuration, client: client }
          client.parse! arguments
          configuration.freeze
        end

        def to_s = client.to_s

        private

        attr_reader :sections, :client, :configuration
      end
    end
  end
end
