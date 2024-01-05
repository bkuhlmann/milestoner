# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::URI::Avatar do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    it "answers formatted URI when URI exists" do
      content = {avatar_domain: "https://avatars.test.com", avatar_uri: "%<domain>s/users/%<id>s"}

      expect(transformer.call(content)).to eq(
        Success(
          avatar_domain: "https://avatars.test.com",
          avatar_uri: "https://avatars.test.com/users/%<id>s"
        )
      )
    end

    it "answers original content when URI doesn't exist" do
      expect(transformer.call({})).to eq(Success({}))
    end
  end
end
