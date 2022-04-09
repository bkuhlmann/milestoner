# frozen_string_literal: true

require "git_plus"
require "versionaire"

module Milestoner
  module Tags
    # Handles the creation of project repository tags.
    class Creator
      include Import[:repository, :logger]

      using Versionaire::Cast

      def initialize categorizer: Commits::Categorizer.new,
                     presenter: Presenters::Commit,
                     **dependencies
        super(**dependencies)
        @categorizer = categorizer
        @presenter = presenter
      end

      def call configuration = Container[:configuration]
        return false if local? configuration
        fail Error, "Unable to tag without commits." if categorizer.call.empty?

        create configuration
      rescue Versionaire::Error, GitPlus::Error => error
        raise Error, error.message
      end

      private

      attr_reader :categorizer, :presenter

      def local? configuration
        version = Version configuration.version

        if repository.tag_local? version
          logger.warn { "Local tag exists: #{version}. Skipped." }
          true
        else
          false
        end
      end

      def create configuration
        version = configuration.version
        repository.tag_unsign version, message(configuration)
        logger.debug { "Local tag created: #{version}." }
      end

      def message configuration
        categorizer.call(configuration)
                   .map { |record| presenter.new(record).line_item }
                   .then do |line_items|
                     %(Version #{configuration.version}\n\n#{line_items.join "\n"}\n\n)
                   end
      end
    end
  end
end
