# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Generator::Label do
  using Refinements::Pathname

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers generator label when key exists" do
      expect(transformer.call({generator_label: "Test"})).to be_success(generator_label: "Test")
    end

    it "answers original attributes when key is missing" do
      expect(transformer.call({}).success[:generator_label]).to eq("Milestoner")
    end
  end
end
