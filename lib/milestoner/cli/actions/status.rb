# frozen_string_literal: true

module Milestoner
  module CLI
    module Actions
      # Handles listing project status of untagged commit history.
      class Status
        include Milestoner::Import[:logger]

        def initialize presenter: Presenters::Commit,
                       categorizer: Commits::Categorizer.new,
                       **dependencies
          super(**dependencies)
          @presenter = presenter
          @categorizer = categorizer
        end

        def call
          categorizer.call
                     .tap { |records| info "All is quiet." if records.empty? }
                     .map { |record| presenter.new(record).line_item }
                     .each { |line_item| info line_item }
        end

        private

        attr_reader :presenter, :categorizer

        def info(message) = logger.info { message }
      end
    end
  end
end
