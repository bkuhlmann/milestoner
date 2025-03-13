# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Cache::Find do
  using Refinements::StringIO

  subject(:action) { described_class.new }

  include_context "with application dependencies"
  include_context "with user"

  describe "#call" do
    it "finds existing user" do
      record = user
      cache.write(:users) { upsert record }
      action.call "Test"

      expect(io.reread).to eq("1, test, Test\n")
    end

    it "aborts on failure" do
      logger = instance_spy Cogger::Hub
      described_class.new(logger:).call "Test"

      expect(logger).to have_received(:abort).with(%(Unable to find name: "Test".))
    end
  end
end
