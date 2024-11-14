# frozen_string_literal: true

require "rss"

module Milestoner
  module Builders
    module Syndication
      # Smooths out the rough edges of the RSS gem object which are harder to work with.
      module Refine
        refine(RSS::Maker::Atom::Feed::Channel) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Channel::Authors) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Channel::Authors::Author) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Channel::Categories) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Channel::Categories::Category) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Channel::Generator) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Channel::Links::Link) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Items::Item) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Channel::Links) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Items::Item::Authors) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Items::Item::Authors::Author) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Items::Item::Categories) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Items::Item::Categories::Category) { import_methods Shared }
        refine(RSS::Maker::Atom::Feed::Items::Item::Content) { import_methods Shared }
      end
    end
  end
end
