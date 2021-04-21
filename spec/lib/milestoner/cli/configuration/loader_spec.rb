# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Configuration::Loader do
  subject(:loader) { described_class.with_defaults }

  let :content do
    Milestoner::CLI::Configuration::Content[
      git_commit_prefixes: %w[Fixed Added Updated Removed Refactored],
      git_tag_sign: false
    ]
  end

  describe ".call" do
    it "answers default configuration" do
      expect(described_class.call).to be_a(Milestoner::CLI::Configuration::Content)
    end
  end

  describe ".with_defaults" do
    it "answers default configuration" do
      expect(described_class.with_defaults.call).to eq(content)
    end
  end

  describe "#call" do
    it "answers default configuration" do
      expect(loader.call).to eq(content)
    end
  end
end
