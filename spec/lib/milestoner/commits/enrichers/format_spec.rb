# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::Format do
  subject(:enricher) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers trailer format when trailer exists" do
      commit = Gitt::Models::Commit[
        trailers: [Gitt::Models::Trailer[key: "Format", value: "markdown"]]
      ]

      expect(enricher.call(commit)).to eq("markdown")
    end

    it "answers default format when trailer is missing" do
      commit = Gitt::Models::Commit[trailers: []]
      expect(enricher.call(commit)).to eq("asciidoc")
    end
  end
end
