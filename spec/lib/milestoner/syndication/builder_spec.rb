# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Syndication::Builder do
  include Dry::Monads[:result]

  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"
  include_context "with enriched tag"

  describe ".authors_for" do
    it "answers unique commit authors" do
      expect(described_class.authors_for(tags)).to eq(
        [Milestoner::Models::User[external_id: "1", handle: "zoe", name: "Zoe Washburne"]]
      )
    end

    it "answers unique tag authors" do
      tags.each { |tag| tag.commits.clear }

      expect(described_class.authors_for(tags)).to eq(
        [Milestoner::Models::User[external_id: "1", handle: "mal", name: "Malcolm Reynolds"]]
      )
    end

    it "answers empty authors for empty tags" do
      expect(described_class.authors_for([])).to eq([])
    end
  end

  describe "#call" do
    let(:feed) { builder.call(tags).bind { |body| RSS::Parser.parse body } }
    let(:at) { Time.new 2024, 7, 5, 1, 1, 1 }

    it "answers feed author name" do
      expect(feed.author.name.content).to eq("Zoe Washburne")
    end

    it "answers feed author uri" do
      expect(feed.author.uri.content).to eq("https://github.com/zoe")
    end

    it "answers feed category term" do
      expect(feed.category.term).to eq("test")
    end

    it "answers feed category label" do
      expect(feed.category.label).to eq("Test")
    end

    it "answers feed generator URI" do
      expect(feed.generator.uri).to eq("https://alchemists.io/projects/milestoner")
    end

    it "answers feed generator label" do
      expect(feed.generator.version).to eq("3.2.1")
    end

    it "answers feed icon (default)" do
      expect(feed.icon).to be(nil)
    end

    it "answers feed icon (custom)" do
      settings.project_uri_icon = "https://acme.io/icon.png"
      expect(feed.icon.content).to eq("https://acme.io/icon.png")
    end

    it "answers feed logo (default)" do
      expect(feed.logo).to be(nil)
    end

    it "answers feed logo (custom)" do
      settings.project_uri_logo = "https://acme.io/logo.png"
      expect(feed.logo.content).to eq("https://acme.io/logo.png")
    end

    it "answers feed ID" do
      expect(feed.id.content).to eq("https://undefined.io/projects/test")
    end

    it "answers feed links" do
      links = feed.links.reduce [] do |all, link|
        all << {href: link.href, rel: link.rel, type: link.type, title: link.title}
      end

      expect(links).to eq(
        [
          {
            href: "https://undefined.io/projects/test/versions",
            rel: "alternate",
            type: "text/html",
            title: "Undefined: Milestoner (web)"
          },
          {
            href: "https://undefined.io/projects/test/versions.xml",
            rel: "self",
            type: "application/atom+xml",
            title: "Undefined: Milestoner (feed)"
          }
        ]
      )
    end

    it "answers feed rights" do
      expect(feed.rights.content).to eq("2024")
    end

    it "answers feed subtitle" do
      expect(feed.subtitle.content).to eq("A test.")
    end

    it "answers feed title" do
      expect(feed.title.content).to eq("Undefined: Milestoner")
    end

    it "answers feed updated" do
      expect(feed.updated.content).to eq(at)
    end

    it "answers feed DC date" do
      expect(feed.dc_date).to eq(at)
    end

    it "answers entry id" do
      expect(feed.entries.first.id.content).to eq(
        "https://undefined.io/projects/test/versions/0.1.0"
      )
    end

    it "answers entry title" do
      expect(feed.entries.first.title.content).to eq("0.1.0")
    end

    it "answers entry link" do
      expect(feed.entries.first.link.href).to eq(
        "https://undefined.io/projects/test/versions/0.1.0"
      )
    end

    it "answers entry rights" do
      expect(feed.entries.first.rights.content).to eq("2024")
    end

    it "answers entry published" do
      expect(feed.entries.first.published.content).to eq(at)
    end

    it "answers entry updated" do
      expect(feed.entries.first.updated.content).to eq(at)
    end

    it "answers entry dc date" do
      expect(feed.entries.first.dc_date).to eq(at)
    end

    it "answers entry content" do
      expect(feed.entries.first.content.content).to include("Added documentation")
    end

    it "answers entry content type" do
      expect(feed.entries.first.content.type).to include("html")
    end

    it "answers entry authors" do
      content = feed.entries.first.authors.reduce(+"") { |body, item| body.concat item.to_s }

      expect(content).to eq(<<~CONTENT.strip)
        <author>
          <name>Zoe Washburne</name>
          <uri>https://github.com/zoe</uri>
        </author>
      CONTENT
    end

    it "answers entry categories" do
      content = feed.entries.first.categories.reduce(+"") { |body, item| body.concat item.to_s }

      expect(content).to eq(<<~CONTENT.strip)
        <category term="milestones"
          label="Milestones"/>
      CONTENT
    end

    it "answers failure when authors are missing" do
      tag.author = Milestoner::Models::User.new
      tag.commits.clear

      expect(builder.call([tag])).to match(
        Failure("#{described_class}: Required variables of maker.channel.author are not set: name.")
      )
    end

    it "answers failure without milestones" do
      expect(builder.call([])).to eq(Failure("No tags or commits."))
    end

    it "answers failure when attribute is missing" do
      tag.committed_at = nil

      expect(builder.call([tag])).to match(
        Failure("#{described_class}: Undefined method `strftime' for nil.")
      )
    end
  end
end
