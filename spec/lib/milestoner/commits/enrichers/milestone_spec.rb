# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::Milestone do
  subject(:enricher) { described_class.new }

  describe "#call" do
    it "answers version when specified" do
      commit = Gitt::Models::Commit[
        trailers: [Gitt::Models::Trailer[key: "Milestone", value: "patch"]]
      ]

      expect(enricher.call(commit)).to eq("patch")
    end

    it "answers unknown when unspecified" do
      commit = Gitt::Models::Commit[trailers: []]
      expect(enricher.call(commit)).to eq("unknown")
    end
  end
end
