# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Model do
  subject(:content) { described_class.new }

  describe "#initialize" do
    let :proof do
      {
        documentation_format: nil,
        prefixes: nil,
        version: nil
      }
    end

    it "answers default attributes" do
      expect(content).to have_attributes(proof)
    end

    it "answers as frozen" do
      expect(content).to be_frozen
    end
  end
end
