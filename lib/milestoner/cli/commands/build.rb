# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Commands
      # Handles the building of milestone output.
      class Build < Sod::Command
        include Import[:settings, :logger, :kernel]
        include Builders::Import[:ascii_doc, :markdown, :stream, :web]

        handle "build"

        description "Build milestone."

        on Actions::Build::Label
        on Actions::Build::Version
        on Actions::Build::Layout
        on Actions::Build::Format
        on Actions::Build::Root

        # :reek:TooManyStatements
        def call
          format = settings.build_format

          log_info "Building #{settings.project_label} milestone (#{format})..."

          case format
            when "ascii_doc" then build_ascii_doc
            when "markdown" then build_markdown
            when "stream" then build_stream
            when "web" then build_web
            else logger.abort "Invalid build format: #{format}."
          end
        end

        private

        attr_reader :view, :enricher

        def build_ascii_doc = log_info("Milestone built: #{ascii_doc.call}.")

        def build_markdown = log_info("Milestone built: #{markdown.call}.")

        def build_stream
          kernel.puts
          stream.call
        end

        def build_web = log_info "Milestone built: #{web.call}."

        def log_info(message) = logger.info { message }
      end
    end
  end
end
