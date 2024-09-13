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

    it "logs error with too many values" do
      action.call "1,test,Test,bogus"
      expect(logger.reread).to match(/🛑.+Too many values given./)
    end

    it "logs error when name is missing" do
      action.call "1,test"
      expect(logger.reread).to match(/🛑.+Name must be supplied./)
    end

    it "logs error when handle and name are missing" do
      action.call "1"
      expect(logger.reread).to match(/🛑.+Handle and Name must be supplied./)
    end

    it "logs error with no elements" do
      action.call ""
      expect(logger.reread).to match(/🛑.+No values given./)
    end
  end
end
