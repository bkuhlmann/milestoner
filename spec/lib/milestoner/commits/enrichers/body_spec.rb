# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::Body do
  subject(:enricher) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers HTML for default format" do
      commit = Gitt::Models::Commit[body: "A test.", trailers: []]

      expect(enricher.call(commit)).to eq(<<~CONTENT.strip)
        <div class="paragraph">
        <p>A test.</p>
        </div>
      CONTENT
    end

    it "answers HTML for custom format" do
      commit = Gitt::Models::Commit[
        body: "A [link](https://example.com).",
        trailers: [Gitt::Models::Trailer[key: "Format", value: "markdown"]]
      ]

      expect(enricher.call(commit)).to eq(%(<p>A <a href="https://example.com">link</a>.</p>\n))
    end
  end
end
