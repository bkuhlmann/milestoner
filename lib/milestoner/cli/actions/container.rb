# frozen_string_literal: true

require "dry/container"

module Milestoner
  module CLI
    module Actions
      # Provides a single container with application and action specific dependencies.
      module Container
        extend Dry::Container::Mixin

        merge Milestoner::Container

        register(:config) { Config.new }
        register(:publish) { Publish.new }
        register(:status) { Status.new }
      end
    end
  end
end
