# frozen_string_literal: true

require "refinements/pathname"
require "sod"

module Milestoner
  module CLI
    module Commands
      # Handles the building of milestone output.
      class Cache < Sod::Command
        include Import[:input, :logger]

        using Refinements::Pathname

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
