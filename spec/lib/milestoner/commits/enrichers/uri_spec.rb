# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::URI do
  subject(:enricher) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers link when trailer exists" do
      settings.commit_uri = "https://github.com/tester/test/commit/%<id>s"
      commit = Gitt::Models::Commit[sha: "180dec7d8ae8"]

      expect(enricher.call(commit)).to eq("https://github.com/tester/test/commit/180dec7d8ae8")
    end
  end
end
