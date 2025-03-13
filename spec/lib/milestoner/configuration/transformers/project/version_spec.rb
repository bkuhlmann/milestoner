# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Project::Version do
  using Refinements::Pathname

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers version when key exists" do
      expect(transformer.call({project_version: "1.2.3"})).to be_success(project_version: "1.2.3")
    end

    it "answers Git version when key is missing" do
      expect(transformer.call({}).success[:project_version]).to match(/\d+\.\d+\.\d+/)
    end
  end
end
