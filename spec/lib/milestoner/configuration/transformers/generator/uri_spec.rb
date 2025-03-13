# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Generator::URI do
  using Refinements::Pathname

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers generator URI when key exists" do
      expect(transformer.call({generator_uri: "https://test.com"})).to be_success(
        generator_uri: "https://test.com"
      )
    end

    it "answers original attributes when key is missing" do
      expect(transformer.call({}).success[:generator_uri]).to eq(
        "https://alchemists.io/projects/milestoner"
      )
    end
  end
end
