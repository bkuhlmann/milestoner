# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::Colleague do
  subject(:enricher) { described_class.new key: "co-authored-by" }

  include_context "with application dependencies"
  include_context "with user"

  describe "#call" do
    it "answers users when found in cache" do
      record = user
      cache.write(:users) { upsert record }

      commit = Gitt::Models::Commit[
        trailers: [
          Gitt::Models::Trailer[key: "co-authored-by", value: "Test <test@example.com"]
        ]
      ]

      expect(enricher.call(commit)).to eq([user])
    end

    it "answers empty array when user isn't found in cache" do
      commit = Gitt::Models::Commit[
        trailers: [
          Gitt::Models::Trailer[key: "co-authored-by", value: "Test <test@example.com"]
        ]
      ]

      expect(enricher.call(commit)).to eq([])
    end

    it "answers empty array when trailers are empty" do
      commit = Gitt::Models::Commit[trailers: []]
      expect(enricher.call(commit)).to eq([])
    end
  end
end
