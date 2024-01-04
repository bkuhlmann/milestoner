# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::Note do
  subject(:enricher) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers HTML content" do
      commit = Gitt::Models::Commit[body: "A test.", notes: "A note.", trailers: []]

      expect(enricher.call(commit)).to eq(<<~CONTENT.strip)
        <div class="paragraph">
        <p>A note.</p>
        </div>
      CONTENT
    end

    it "answers empty string for empty notes" do
      commit = Gitt::Models::Commit[body: "A test.", notes: "", trailers: []]
      expect(enricher.call(commit)).to eq("")
    end
  end
end
