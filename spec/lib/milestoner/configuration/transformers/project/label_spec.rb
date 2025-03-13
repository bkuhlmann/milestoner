# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Project::Label do
  subject(:transformer) { described_class }

  describe "#call" do
    it "answers label when key exists" do
      expect(transformer.call({project_label: "Test"})).to be_success(project_label: "Test")
    end

    it "answers default when key is missing" do
      expect(transformer.call({}, default: "Demo")).to be_success({project_label: "Demo"})
    end

    it "answers titleized default when key is missing" do
      expect(transformer.call({}, default: "demo")).to be_success({project_label: "Demo"})
    end
  end
end
