# frozen_string_literal: true

require "hanami/view"

module Milestoner
  module Views
    # A scope builder which is meant to replace and fix the default scope builder.
    module ScopeBuilder
      def self.call name = nil, locals:, rendering:
        scope_for(name, rendering).new name:, locals:, rendering:
      end

      def self.scope_for name, rendering
        case name
          in nil then rendering.config.scope_class
          in Class then name
          else fetch_or_store name, rendering
        end
      end

      def self.fetch_or_store name, rendering
        config = rendering.config

        Hanami::View.cache.fetch_or_store name, config do
          constant = constant_for name, rendering
          constant && constant < Hanami::View::Scope ? constant : config.scope_class
        end
      end

      def self.constant_for name, rendering
        name = rendering.inflector.camelize name.to_s
        namespace = rendering.config.scope_namespace || Object

        namespace.const_get name if namespace.const_defined? name, false
      end

      private_class_method :scope_for, :fetch_or_store, :constant_for
    end
  end
end
