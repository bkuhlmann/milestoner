# frozen_string_literal: true

require "core"
require "dry/monads"
require "rss"

module Milestoner
  module Syndication
    # Builds feed in Atom format.
    # :reek:DataClump
    class Builder
      include Import[:settings]
      include Dry::Monads[:result]

      using Refine

      def initialize(client: RSS::Maker, view: Views::Milestones::Show.new, **)
        super(**)
        @client = client
        @view = view
      end

      def call tags
        return Failure "No content to build." if tags.empty?

        Success build_feed(tags).to_s
      rescue NoMethodError, RSS::Error => error
        Failure "#{self.class}: #{error.message.capitalize}."
      end

      private

      attr_reader :client, :view

      def build_feed tags
        client.make "atom" do |node|
          build_channel node.channel, tags
          build_tags node, tags
        end
      end

      def build_channel node, tags
        at = tags.first.committed_at

        node.merge id: settings.project_uri_home,
                   title: settings.syndication_label,
                   subtitle: settings.project_description,
                   icon: settings.project_uri_icon,
                   logo: settings.project_uri_logo,
                   rights: at.strftime("%Y"),
                   updated: at

        build_channel_elements node, tags
      end

      def build_channel_elements node, tags
        build_links node
        build_generator node

        build_authors node,
                      tags.flat_map { |milestone| milestone.commits.map(&:author) }
                          .uniq

        node.categories.build label: settings.project_label, term: settings.project_name
      end

      def build_links node
        node.links.build_for settings.syndication_links,
                             label: :title,
                             uri: :href,
                             relation: :rel,
                             mime: :type
      end

      def build_generator node
        node.generator do |generator|
          generator.merge content: settings.generator_label,
                          version: settings.generator_version,
                          uri: settings.generator_uri
        end
      end

      def build_tags node, list = Core::EMPTY_ARRAY
        list.each { |milestone| build_item node.items, milestone }
      end

      def build_item node, milestone
        node.new_item do |item|
          build_item_metadata item, milestone
          build_item_content item.content, milestone
          build_authors item, milestone.commits.map(&:author).uniq.select(&:name)
          item.categories.build_for settings.syndication_categories, label: :label, name: :term
        end
      end

      def build_item_metadata node, milestone
        committed_at = milestone.committed_at
        version = milestone.version

        node.merge id: format(settings.syndication_id, id: version),
                   title: format(settings.syndication_entry_label, id: version),
                   link: format(settings.syndication_entry_uri, id: version),
                   rights: committed_at.strftime("%Y"),
                   published: committed_at,
                   updated: committed_at
      end

      def build_item_content node, milestone
        content = view.call commits: milestone.commits, layout: settings.build_layout, format: :xml
        node.merge content:, type: :html
      end

      def build_authors node, list = Core::EMPTY_ARRAY
        list.each do |user|
          node.authors.build name: user.name, uri: format(settings.profile_uri, id: user.handle)
        end
      end
    end
  end
end
