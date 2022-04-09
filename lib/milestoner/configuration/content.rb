# frozen_string_literal: true

module Milestoner
  module Configuration
    # Defines configuration content as the primary source of truth for use throughout the gem.
    Content = Struct.new(
      :action_config,
      :action_publish,
      :action_push,
      :action_status,
      :action_tag,
      :action_version,
      :action_help,
      :documentation_format,
      :prefixes,
      :version,
      keyword_init: true
    ) do
      def initialize *arguments
        super
        freeze
      end
    end
  end
end
