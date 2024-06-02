# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::Review do
  subject(:enricher) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers link when trailer exists" do
      settings.review_uri = "https://github.com/tester/test/pulls/"

      expect(enricher.call).to eq(
        Milestoner::Models::Link[id: "All", uri: "https://github.com/tester/test/pulls/"]
      )
    end
  end
end
