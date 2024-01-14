# frozen_string_literal: true

module Milestoner
  module Configuration
    # Defines configuration content as the primary source of truth for use throughout the gem.
    Model = Struct.new :avatar_domain,
                       :avatar_uri,
                       :build_format,
                       :build_layout,
                       :build_root,
                       :build_template_paths,
                       :commit_categories,
                       :commit_domain,
                       :commit_format,
                       :commit_uri,
                       :generator_label,
                       :generator_uri,
                       :profile_domain,
                       :profile_uri,
                       :project_author,
                       :project_description,
                       :project_generator,
                       :project_label,
                       :project_name,
                       :project_owner,
                       :project_uri,
                       :project_version,
                       :review_domain,
                       :review_uri,
                       :tracker_domain,
                       :tracker_uri
  end
end
