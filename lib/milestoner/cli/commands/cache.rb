# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Commands
      # Handles the building of milestone output.
      class Cache < Sod::Command
        include Import[:settings, :logger]

        handle "cache"

        description "Manage cache."

        on Actions::Cache::Info
        on Actions::Cache::List
        on Actions::Cache::Find
        on Actions::Cache::Create
        on Actions::Cache::Delete
      end
    end
  end
end
