# frozen_string_literal: true

require "refinements/pathname"
require "sod"

module Milestoner
  module CLI
    module Commands
      # Handles the building of milestone output.
      class Build < Sod::Command
        include Import[:input, :logger, :kernel]
        include Builders::Import[:stream, :web]

        using Refinements::Pathname

        handle "build"

        description "Build milestone."

        on Actions::Build::Label
        on Actions::Build::Version
        on Actions::Build::Layout
        on Actions::Build::Format
        on Actions::Build::Root

        def call
          log_info "Building milestone..."

          format = input.build_format

          case format
            when "stream" then build_stream
            when "web" then build_web
            else log_error "Invalid build format: #{format}."
          end
        end

        private

        attr_reader :view, :enricher

        def build_stream
          kernel.puts
          stream.call
        end

        def build_web = log_info "Milestone built: #{web.call}."

        def log_info(message) = logger.info { message }

        def log_error(message) = logger.error { message }
      end
    end
  end
end
