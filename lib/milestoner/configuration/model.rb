# frozen_string_literal: true

module Milestoner
  module Configuration
    # Defines configuration content as the primary source of truth for use throughout the gem.
    Model = Struct.new :avatar_uri,
                       :build_basename,
                       :build_format,
                       :build_layout,
                       :build_max,
                       :build_output,
                       :build_stylesheet,
                       :build_tail,
                       :build_template_paths,
                       :commit_categories,
                       :commit_format,
                       :commit_uri,
                       :generator_label,
                       :generator_uri,
                       :generator_version,
                       :loaded_at,
                       :organization_label,
                       :organization_uri,
                       :profile_uri,
                       :project_author,
                       :project_description,
                       :project_label,
                       :project_name,
                       :project_owner,
                       :project_uri_home,
                       :project_uri_icon,
                       :project_uri_logo,
                       :project_uri_version,
                       :project_version,
                       :review_uri,
                       :syndication_categories,
                       :syndication_entry_label,
                       :syndication_entry_uri,
                       :syndication_id,
                       :syndication_label,
                       :syndication_links,
                       :tracker_uri
  end
end
