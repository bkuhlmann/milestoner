# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Content do
  subject(:content) { described_class.new }

  describe "#initialize" do
    let :proof do
      {
        action_config: nil,
        action_publish: nil,
        action_push: nil,
        action_status: nil,
        action_tag: nil,
        action_version: nil,
        action_help: nil,
        documentation_format: nil,
        prefixes: nil,
        sign: nil,
        version: nil
      }
    end

    it "answers default attributes" do
      expect(content).to have_attributes(proof)
    end
  end
end
