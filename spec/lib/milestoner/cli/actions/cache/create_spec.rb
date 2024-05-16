# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Cache::Create do
  include Dry::Monads[:result]

  subject(:action) { described_class.new }

  include_context "with application dependencies"
  include_context "with user"

  describe "#call" do
    it "creates user" do
      values = "1,test,Test"
      action.call values

      user = cache.read(:users) { find "Test" }

      expect(user).to eq(
        Success(
          Milestoner::Models::User[
            external_id: "1",
            handle: "test",
            name: "Test"
          ]
        )
      )
    end

    it "logs user was upserted" do
      values = "1,test,Test"
      action.call values

      expect(logger.reread).to match(/🟢.+Created: "Test"./)
    end
  end
end
