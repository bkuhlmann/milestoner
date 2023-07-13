# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Project::Name do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    it "answers name when key exists" do
      expect(transformer.call({project_name: "test"})).to eq(Success(project_name: "test"))
    end

    it "answers default when key is missing" do
      expect(transformer.call({}, default: "demo")).to eq(Success({project_name: "demo"}))
    end
  end
end
