# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::URI::Commit do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    it "answers formatted URI when URI exists" do
      content = {
        project_owner: "acme",
        project_name: "test",
        commit_domain: "https://example.com",
        commit_uri: "%<domain>s/%<owner>s/%<name>s/commit/%<id>s"
      }

      expect(transformer.call(content)).to eq(
        Success(
          project_owner: "acme",
          project_name: "test",
          commit_domain: "https://example.com",
          commit_uri: "https://example.com/acme/test/commit/%<id>s"
        )
      )
    end

    it "answers original content when URI doesn't exist" do
      expect(transformer.call({})).to eq(Success({}))
    end
  end
end
