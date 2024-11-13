# frozen_string_literal: true

require "dry/schema"
require "etcher"

Dry::Schema.load_extensions :monads

module Milestoner
  module Configuration
    Contract = Dry::Schema.Params do
      required(:avatar_uri).filled :string
      required(:build_basename).filled :string
      required(:build_format).filled :string
      required(:build_index).filled :bool
      required(:build_layout) { str? | bool? }
      required(:build_max).filled :integer
      required(:build_output).filled Etcher::Types::Pathname
      required(:build_stylesheet).filled :bool
      required(:build_tail).filled :string
      required(:build_template_paths).array Etcher::Types::Pathname

      required(:commit_categories).array(:hash) do
        required(:emoji).filled :string
        required(:label).filled :string
      end

      required(:commit_format).filled :string
      required(:commit_uri).filled :string
      required(:generator_label).filled :string
      required(:generator_uri).filled :string
      required(:generator_version).filled Etcher::Types::Version
      required(:loaded_at).filled :time
      required(:organization_label).filled :string
      required(:organization_uri).filled :string
      required(:profile_uri).filled :string
      required(:project_author).filled :string
      optional(:project_description).filled :string
      optional(:project_label).filled :string
      required(:project_name).filled :string
      required(:project_owner).filled :string
      required(:project_uri_home).filled :string
      optional(:project_uri_icon).filled :string
      optional(:project_uri_logo).filled :string
      required(:project_uri_version).filled :string
      required(:project_version).filled Etcher::Types::Version
      required(:review_uri).filled :string
      required(:stylesheet_path).filled :string
      required(:stylesheet_uri).filled :string

      required(:syndication_categories).array(:hash) do
        required(:label).filled :string
        required(:name).filled :string
      end

      required(:syndication_entry_label).filled :string
      required(:syndication_entry_uri).filled :string
      required(:syndication_id).filled :string
      required(:syndication_label).filled :string

      required(:syndication_links).array(:hash) do
        required(:label).filled :string
        required(:mime).filled :string
        required(:relation).filled :string
        required(:uri).filled :string
      end

      required(:tag_subject).filled :string
      required(:tracker_uri).filled :string
    end
  end
end
