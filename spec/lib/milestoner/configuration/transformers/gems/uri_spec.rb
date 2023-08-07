# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Gems::URI do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers URI when key exists" do
      expect(transformer.call({project_uri: "https://demo.com"})).to eq(
        Success(project_uri: "https://demo.com")
      )
    end

    it "answers specification home page URL when key is missing and specification exists" do
      transformer = described_class.new path: SPEC_ROOT.join("support/fixtures/demo.gemspec")
      expect(transformer.call({}).success[:project_uri]).to eq("https://test.com/projects/demo")
    end

    it "answers original content when key and specification are missing" do
      transformer = described_class.new path: Pathname("bogus.gemspec")
      expect(transformer.call({})).to eq(Success({}))
    end
  end
end
