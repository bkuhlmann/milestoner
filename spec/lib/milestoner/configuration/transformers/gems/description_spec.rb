# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Gems::Description do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers description when key exists" do
      expect(transformer.call({project_description: "Test"})).to eq(
        Success(project_description: "Test")
      )
    end

    it "answers specification summary when key is missing and specification exists" do
      transformer = described_class.new path: SPEC_ROOT.join("support/fixtures/demo.gemspec")
      expect(transformer.call({}).success[:project_description]).to eq("A demo specification.")
    end

    it "answers empty hash when key is missing" do
      transformer = described_class.new path: Pathname("bogus.gemspec")
      expect(transformer.call({})).to eq(Success({}))
    end
  end
end
