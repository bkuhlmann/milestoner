# frozen_string_literal: true

require "gitt"
require "versionaire"

module Milestoner
  module Tags
    # Handles the creation of project repository tags.
    class Creator
      include Import[:git, :logger]

      using Versionaire::Cast

      def initialize(categorizer: Commits::Categorizer.new, presenter: Presenters::Commit, **)
        super(**)
        @categorizer = categorizer
        @presenter = presenter
      end

      def call configuration = Container[:configuration]
        return false if local? configuration
        fail Error, "Unable to tag without commits." if categorizer.call.empty?

        create configuration
      rescue Versionaire::Error => error
        raise Error, error.message
      end

      private

      attr_reader :categorizer, :presenter

      def local? configuration
        version = Version configuration.version

        if git.tag_local? version
          logger.warn { "Local tag exists: #{version}. Skipped." }
          true
        else
          false
        end
      end

      def create configuration
        git.tag_create(configuration.version, message(configuration))
           .or { |error| fail Error, error }
           .bind { true }
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
