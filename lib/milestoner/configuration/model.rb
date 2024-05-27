# frozen_string_literal: true

module Milestoner
  module Configuration
    # Defines configuration content as the primary source of truth for use throughout the gem.
    Model = Struct.new :avatar_uri,
                       :build_basename,
                       :build_format,
                       :build_layout,
                       :build_max,
                       :build_root,
                       :build_stylesheet,
                       :build_template_paths,
                       :commit_categories,
                       :commit_format,
                       :commit_uri,
                       :generator_label,
                       :generator_uri,
                       :generator_version,
                       :loaded_at,
                       :profile_uri,
                       :project_author,
                       :project_description,
                       :project_generator,
                       :project_label,
                       :project_name,
                       :project_owner,
                       :project_uri,
                       :project_version,
                       :review_uri,
                       :tracker_uri
  end
end
