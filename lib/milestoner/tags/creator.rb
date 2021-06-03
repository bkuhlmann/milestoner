# frozen_string_literal: true

require "versionaire"

module Milestoner
  module Tags
    # Handles the creation of project repository tags.
    class Creator
      using Versionaire::Cast

      def initialize categorizer: Commits::Categorizer.new,
                     presenter: Presenters::Commit,
                     container: Container

        @categorizer = categorizer
        @presenter = presenter
        @container = container
      end

      def call configuration = CLI::Configuration::Loader.call
        return false if local? configuration
        fail Error, "Unable to tag without commits." if categorizer.call.empty?

        sign configuration
      rescue Versionaire::Errors::Cast, GitPlus::Errors::Base => error
        raise Error, error.message
      end

      private

      attr_reader :categorizer, :presenter, :container

      def local? configuration
        version = Version configuration.git_tag_version

        if repository.tag_local? version
          logger.warn "Local tag exists: #{version}. Skipped."
          true
        else
          false
        end
      end

      def sign configuration
        version = configuration.git_tag_version
        content = message configuration

        if configuration.git_tag_sign
          repository.tag_sign version, content
        else
          repository.tag_unsign version, content
        end

        logger.debug "Local tag created: #{version}."
      end

      def message configuration
        categorizer.call(configuration)
                   .map { |record| presenter.new record }
                   .map { |commit| "- #{commit.subject_author}" }
                   .then do |commits|
                     %(Version #{configuration.git_tag_version}\n\n#{commits.join "\n"}\n\n)
                   end
      end

      def repository = container[__method__]

      def logger = container[__method__]
    end
  end
end
