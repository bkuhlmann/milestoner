# frozen_string_literal: true

require "gitt"
require "spec_helper"

RSpec.describe Milestoner::Views::Parts::User do
  subject(:part) { described_class.new value: user, rendering: view.new.rendering }

  include_context "with application dependencies"
  include_context "with enriched commit"
  include_context "with user"

  let :view do
    Class.new Hanami::View do
      config.paths = [Bundler.root.join("lib/milestoner/templates")]
      config.template = "n/a"
    end
  end

  describe "#name" do
    it "answers name when user name exists" do
      expect(part.name).to eq("Test")
    end

    it "answers unknown when user name doesn't nil" do
      part = described_class.new value: user.with(name: nil)
      expect(part.name).to eq("Unknown")
    end
  end

  describe "#image_alt" do
    it "answers alt when user name exists" do
      expect(part.image_alt).to eq("Test")
    end

    it "answers missing when user name doesn't nil" do
      part = described_class.new value: user.with(name: nil)
      expect(part.image_alt).to eq("missing")
    end
  end

  describe "#avatar_url" do
    it "answers URL when user name exists" do
      expect(part.avatar_url).to eq("https://avatars.githubusercontent.com/u/1")
    end

    it "answers missing URL when user name is nil" do
      part = described_class.new value: user.with(name: nil)
      expect(part.avatar_url).to eq("https://alchemists.io/images/projects/milestoner/icons/missing.png")
    end
  end

  describe "#profile_url" do
    it "answers URL when user name exists" do
      expect(part.profile_url).to eq("https://github.com/test")
    end

    it "answers missing URL when user name is nil" do
      part = described_class.new value: user.with(name: nil)
      expect(part.profile_url).to eq("/#unknown")
    end
  end
end
