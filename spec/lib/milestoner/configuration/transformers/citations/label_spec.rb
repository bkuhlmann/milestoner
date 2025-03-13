# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Citations::Label do
  using Refinements::Pathname

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers default label when key exists" do
      expect(transformer.call({project_label: "Test"})).to be_success(project_label: "Test")
    end

    it "answers citation title when key is missing and citation exists" do
      transformer = described_class.new path: SPEC_ROOT.join("support/fixtures/CITATION.cff")
      expect(transformer.call({})).to be_success(project_label: "Demo")
    end

    it "answers empty hash when key is missing" do
      transformer = described_class.new path: Pathname("bogus.cff")
      expect(transformer.call({})).to be_success({})
    end
  end
end
