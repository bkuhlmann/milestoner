# frozen_string_literal: true

require "dry/schema"
require "etcher"

Dry::Schema.load_extensions :monads

module Milestoner
  module Configuration
    Contract = Dry::Schema.Params do
      required(:avatar_domain).filled :string
      required(:avatar_uri).filled :string
      required(:build_format).filled :string
      required(:build_layout) { str? | bool? }
      required(:build_root).filled Etcher::Types::Pathname
      required(:build_template_paths).array Etcher::Types::Pathname

      required(:commit_categories).array(:hash) do
        required(:emoji).filled :string
        required(:label).filled :string
      end

      required(:commit_domain).filled :string
      required(:commit_format).filled :string
      required(:commit_uri).filled :string
      required(:generator_label).filled :string
      required(:generator_uri).filled :string
      required(:generator_version).filled Etcher::Types::Version
      required(:loaded_at).filled :time
      required(:profile_domain).filled :string
      required(:profile_uri).filled :string
      required(:project_author).filled :string
      optional(:project_description).maybe :string
      optional(:project_label).filled :string
      required(:project_name).filled :string
      optional(:project_owner).filled :string
      optional(:project_uri).maybe :string
      required(:project_version).filled Etcher::Types::Version
      required(:review_domain).filled :string
      required(:review_uri).filled :string
      required(:tracker_domain).filled :string
      required(:tracker_uri).filled :string
    end
  end
end
