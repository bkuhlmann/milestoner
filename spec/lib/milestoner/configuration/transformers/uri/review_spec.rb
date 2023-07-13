# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::URI::Review do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    it "answers formatted URI when URI exists" do
      content = {
        project_owner: "acme",
        project_name: "test",
        review_domain: "https://example.com",
        review_uri: "%<domain>s/%<owner>s/%<name>s/pulls/%<id>s"
      }

      expect(transformer.call(content)).to eq(
        Success(
          project_owner: "acme",
          project_name: "test",
          review_domain: "https://example.com",
          review_uri: "https://example.com/acme/test/pulls/%<id>s"
        )
      )
    end

    it "answers original content when URI doesn't exist" do
      expect(transformer.call({})).to eq(Success({}))
    end
  end
end
