# frozen_string_literal: true

require "gitt"
require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::Time do
  subject(:enricher) { described_class.new key: :authored_at }

  describe "#call" do
    it "answers time for default key" do
      commit = Gitt::Models::Commit[authored_at: "1672593010"]
      expect(enricher.call(commit)).to eq(Time.new(2023, 1, 1, 10, 10, 10, "-0700"))
    end

    it "answers time for custom key" do
      enricher = described_class.new key: :committed_at
      commit = Gitt::Models::Commit[committed_at: "1672611315"]

      expect(enricher.call(commit)).to eq(Time.new(2023, 1, 1, 15, 15, 15, "-0700"))
    end
  end
end
