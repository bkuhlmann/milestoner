# frozen_string_literal: true

module Milestoner
  module Models
    # Represents a Git tag comprised of multiple commits.
    Tag = Struct.new :author, :commits, :committed_at, :contributors, :sha, :signature, :version
  end
end
