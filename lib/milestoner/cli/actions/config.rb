# frozen_string_literal: true

module Milestoner
  module CLI
    module Actions
      # Handles the gem configuration action.
      class Config
        include Milestoner::Import[:kernel, :logger]

        def initialize(configuration: Configuration::Loader::CLIENT, **)
          super(**)
          @configuration = configuration
        end

        def call action
          case action
            when :edit then edit
            when :view then view
            else logger.error { "Invalid configuration action: #{action}." }
          end
        end

        private

        attr_reader :configuration

        def edit = kernel.system("$EDITOR #{configuration.current}")

        def view = kernel.system("cat #{configuration.current}")
      end
    end
  end
end
