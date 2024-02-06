# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Project::Label do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    it "answers label when key exists" do
      expect(transformer.call({project_label: "Test"})).to eq(Success(project_label: "Test"))
    end

    it "answers default when key is missing" do
      expect(transformer.call({}, default: "Demo")).to eq(Success({project_label: "Demo"}))
    end

    it "answers titleizes default when key is missing" do
      expect(transformer.call({}, default: "demo")).to eq(Success({project_label: "Demo"}))
    end
  end
end
