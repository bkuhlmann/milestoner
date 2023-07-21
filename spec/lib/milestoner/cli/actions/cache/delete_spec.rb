# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Cache::Delete do
  include Dry::Monads[:result]

  subject(:action) { described_class.new }

  include_context "with application dependencies"
  include_context "with user"

  describe "#call" do
    it "deletes user" do
      record = user
      cache.commit(:users) { upsert record }
      action.call "Test"

      expect(cache.commit(:users, &:all)).to eq(Success([]))
    end

    it "logs user deletion" do
      record = user
      cache.commit(:users) { upsert record }
      action.call "Test"

      expect(logger.reread).to match(/🟢.+Deleted: "Test"\./)
    end

    it "logs error when user isn't found" do
      action.call "Test"

      expect(logger.reread).to match(/🛑.+Unable to find name: "Test"\./)
    end

    it "aborts on failure" do
      action.call "Test"
      expect(kernel).to have_received(:abort)
    end
  end
end
