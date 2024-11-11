# frozen_string_literal: true

require "core"
require "dry/monads"
require "rss"

module Milestoner
  module Syndication
    # Builds feed in Atom format.
    # :reek:DataClump
    class Builder
      include Dependencies[:settings]
      include Dry::Monads[:result]

      using Refine

      def self.authors_for tags
        tags.flat_map { |tag| tag.commits.map(&:author) }
            .then { |users| users.any? ? users : tags.map(&:author) }
            .uniq
      end

      def initialize(client: RSS::Maker, view: Views::Milestones::Show.new, **)
        super(**)
        @client = client
        @view = view
      end

      def call tags
        return Failure "No tags or commits." if tags.empty?

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
        build_authors node, self.class.authors_for(tags)

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

      def build_tags node, tags = Core::EMPTY_ARRAY
        tags.each { |tag| build_item node.items, tag }
      end

      def build_item node, tag
        node.new_item do |item|
          build_item_metadata item, tag
          build_item_content item.content, tag
          build_authors item, tag.commits.map(&:author).uniq.select(&:name)
          item.categories.build_for settings.syndication_categories, label: :label, name: :term
        end
      end

      def build_item_metadata node, tag
        committed_at = tag.committed_at
        version = tag.version

        node.merge id: format(settings.syndication_id, id: version),
                   title: format(settings.syndication_entry_label, id: version),
                   link: format(settings.syndication_entry_uri, id: version),
                   rights: committed_at.strftime("%Y"),
                   published: committed_at,
                   updated: committed_at
      end

      def build_item_content node, tag
        content = view.call tag:, layout: settings.build_layout, format: :xml
        node.merge content:, type: :html
      end

      def build_authors node, users = Core::EMPTY_ARRAY
        users.each do |user|
          node.authors.build name: user.name, uri: format(settings.profile_uri, id: user.handle)
        end
      end
    end
  end
end
