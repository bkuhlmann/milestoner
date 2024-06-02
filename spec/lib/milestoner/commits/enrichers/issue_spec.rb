# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::Issue do
  subject(:enricher) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers issue when trailer exists" do
      commit = Gitt::Models::Commit[trailers: [Gitt::Models::Trailer[key: "Issue", value: "123"]]]

      expect(enricher.call(commit)).to eq(
        Milestoner::Models::Link[
          id: "123",
          uri: "https://github.com/unknown/test/issues/123"
        ]
      )
    end

    it "answers empty issue when trailer doesn't exist" do
      commit = Gitt::Models::Commit[trailers: []]

      expect(enricher.call(commit)).to eq(
        Milestoner::Models::Link[
          id: "All",
          uri: "https://github.com/unknown/test/issues/"
        ]
      )
    end
  end
end
