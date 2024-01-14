# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Gems::Label do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers label when key exists" do
      expect(transformer.call({project_label: "Test"})).to eq(Success(project_label: "Test"))
    end

    it "answers specification label when key is missing and specification exists" do
      transformer = described_class.new path: SPEC_ROOT.join("support/fixtures/demo.gemspec")
      expect(transformer.call({})).to eq(Success(project_label: "Demo"))
    end

    it "answers undefined label when key and specification are missing" do
      transformer = described_class.new path: Pathname("bogus.gemspec")
      expect(transformer.call({})).to eq(Success({project_label: nil}))
    end
  end
end
