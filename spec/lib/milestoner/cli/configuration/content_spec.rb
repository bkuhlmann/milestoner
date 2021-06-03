# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Configuration::Content do
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
        git_commit_prefixes: nil,
        git_tag_sign: nil,
        git_tag_version: nil
      }
    end

    it "answers default attributes" do
      expect(content).to have_attributes(proof)
    end
  end
end
