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
      cache.write(:users) { upsert record }
      action.call "Test"

      expect(cache.read(:users, &:all)).to eq(Success([]))
    end

    it "logs user deletion" do
      record = user
      cache.write(:users) { upsert record }
      action.call "Test"

      expect(logger.reread).to match(/🟢.+Deleted: "Test"\./)
    end

    it "aborts on failure" do
      logger = instance_spy Cogger::Hub
      described_class.new(logger:).call "Test"

      expect(logger).to have_received(:abort).with(%(Unable to find name: "Test".))
    end
  end
end
