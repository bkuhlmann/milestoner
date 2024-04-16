# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Generator::Version do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers generator version when key exists" do
      expect(transformer.call({generator_version: "0.0.0"})).to eq(
        Success(generator_version: "0.0.0")
      )
    end

    it "answers original content when key is missing" do
      expect(transformer.call({}).success[:generator_version]).to match(/\d+\.\d+\.\d+/)
    end
  end
end
