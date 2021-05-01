# frozen_string_literal: true

module Milestoner
  module CLI
    module Actions
      # Handles listing project status of untagged commit history.
      class Status
        def initialize presenter: Presenters::Commit,
                       categorizer: Commits::Categorizer.new,
                       container: Container
          @presenter = presenter
          @categorizer = categorizer
          @container = container
        end

        def call
          categorizer.call
                     .tap { |records| info "All is quiet." if records.empty? }
                     .map { |record| "- #{presenter.new(record).subject_author}" }
                     .each { |line| info line }
        end

        private

        attr_reader :presenter, :categorizer, :container

        def info(message) = logger.info { message }

        def logger = container[__method__]
      end
    end
  end
end
