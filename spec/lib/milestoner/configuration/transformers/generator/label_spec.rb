# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Generator::Label do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers generator label when key exists" do
      expect(transformer.call({generator_label: "Test 0.0.0"})).to eq(
        Success(generator_label: "Test 0.0.0")
      )
    end

    it "answers original content when key is missing" do
      expect(transformer.call({}).success[:generator_label]).to match(/Milestoner \d+\.\d+\.\d+/)
    end
  end
end
