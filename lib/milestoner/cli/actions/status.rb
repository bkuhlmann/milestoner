# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      # Handles listing project status of untagged commit history.
      class Status < Sod::Action
        include Milestoner::Import[:kernel, :logger]

        description "Show project status."

        on %w[-s --status]

        def initialize(presenter: Presenters::Commit, categorizer: Commits::Categorizer.new, **)
          super(**)
          @presenter = presenter
          @categorizer = categorizer
        end

        def call(*)
          categorizer.call
                     .tap { |records| info "All is quiet." if records.empty? }
                     .map { |record| presenter.new(record).line_item }
                     .each { |line_item| kernel.puts line_item }
        end

        private

        attr_reader :presenter, :categorizer

        def info(message) = logger.info { message }
      end
    end
  end
end
