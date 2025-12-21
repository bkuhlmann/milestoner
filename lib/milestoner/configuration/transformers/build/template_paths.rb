# frozen_string_literal: true

require "dry/monads"
require "runcom"

module Milestoner
  module Configuration
    module Transformers
      module Build
        # Ensures XDG configuration and gem template paths are configured.
        class TemplatePaths
          include Dry::Monads[:result]

          def initialize key = :build_template_paths,
                         default: Pathname(__dir__).join("../../../templates"),
                         xdg: Runcom::Config.new("milestoner/templates")
            @key = key
            @default = default
            @xdg = xdg
          end

          def call(attributes) = Success attributes.merge!(key => xdg.all.append(default))

          private

          attr_reader :key, :default, :xdg
        end
      end
    end
  end
end
