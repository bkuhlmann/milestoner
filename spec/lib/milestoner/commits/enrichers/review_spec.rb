# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::Review do
  subject(:enricher) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers link when trailer exists" do
      expect(enricher.call).to eq(
        Milestoner::Models::Link[id: "All", uri: "https://github.com/acme/test/pulls/"]
      )
    end
  end
end
