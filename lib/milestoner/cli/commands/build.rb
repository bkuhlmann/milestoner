# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Commands
      # Handles the building of different milestone formats.
      class Build < Sod::Command
        include Dependencies[:settings, :logger, :io]
        include Builders::Dependencies[:ascii_doc, :feed, :manifest, :markdown, :stream, :web]

        handle "build"

        description "Build milestone."

        on Actions::Build::Basename
        on Actions::Build::Format
        on Actions::Build::Index
        on Actions::Build::Label
        on Actions::Build::Layout
        on Actions::Build::Manifest
        on Actions::Build::Max
        on Actions::Build::Output
        on Actions::Build::Stylesheet
        on Actions::Build::Tail
        on Actions::Build::Version

        def call
          format = settings.build_format

          log_info "Building #{settings.project_label} (#{format})..."

          if infused_keys.include? format.to_sym
            __send__(format).call
          else
            logger.abort "Invalid build format: #{format}."
          end

          manifest.call
        end

        private

        def log_info(message) = logger.info { message }
      end
    end
  end
end
