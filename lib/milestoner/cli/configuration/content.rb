# frozen_string_literal: true

module Milestoner
  module CLI
    module Configuration
      # Defines configuration content as the primary source of truth for use throughout the gem.
      Content = Struct.new :action_config,
                           :action_publish,
                           :action_push,
                           :action_status,
                           :action_tag,
                           :action_version,
                           :action_help,
                           :git_commit_prefixes,
                           :git_tag_sign,
                           :git_tag_version,
                           keyword_init: true
    end
  end
end
