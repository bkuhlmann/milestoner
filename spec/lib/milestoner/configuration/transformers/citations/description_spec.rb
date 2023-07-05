# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Citations::Description do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers description when key exists" do
      expect(transformer.call({project_description: "Test"})).to eq(
        Success(project_description: "Test")
      )
    end

    it "answers citation abstract when key is missing and citation exists" do
      transformer = described_class.new path: SPEC_ROOT.join("support/fixtures/CITATION.cff")
      expect(transformer.call({}).success[:project_description]).to eq("A demo citation.")
    end

    it "answers original content when key and citation are missing" do
      transformer = described_class.new path: Pathname("bogus.cff")
      expect(transformer.call({})).to eq(Success({}))
    end
  end
end
