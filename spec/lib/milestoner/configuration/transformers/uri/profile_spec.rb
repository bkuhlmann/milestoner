# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::URI::Profile do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    describe "#call" do
      it "answers formatted URI when URI exists" do
        attributes = {profile_domain: "https://example.com", profile_uri: "%<domain>s/%<id>s"}

        expect(transformer.call(attributes)).to eq(
          Success(
            profile_domain: "https://example.com",
            profile_uri: "https://example.com/%<id>s"
          )
        )
      end

      it "answers original attributes when URI doesn't exist" do
        expect(transformer.call({})).to eq(Success({}))
      end
    end
  end
end
