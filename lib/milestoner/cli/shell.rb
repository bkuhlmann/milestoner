# frozen_string_literal: true

module Milestoner
  module CLI
    # The main Command Line Interface (CLI) object.
    class Shell
      ACTIONS = {
        config: Actions::Config.new,
        publish: Actions::Publish.new,
        status: Actions::Status.new
      }.freeze

      def initialize parser: Parser.new, actions: ACTIONS, container: Container
        @parser = parser
        @actions = actions
        @container = container
      end

      def call arguments = []
        perform parser.call(arguments)
      rescue OptionParser::ParseError, Error => error
        logger.error { error.message }
      end

      private

      attr_reader :parser, :actions, :container

      def perform configuration
        case configuration
          in action_config: Symbol => action then config action
          in action_publish: true then publish configuration
          in action_status: true then status
          in action_version: true then logger.info Identity::VERSION_LABEL
          else usage
        end
      end

      def config(action) = actions.fetch(__method__).call(action)

      def publish(configuration) = actions.fetch(__method__).call(configuration)

      def status = actions.fetch(__method__).call

      def usage = logger.unknown { parser.to_s }

      def logger = container[__method__]
    end
  end
end
