# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Commits::Enricher do
  include Dry::Monads[:result]

  subject(:enricher) { described_class.new categorizer: }

  include_context "with application dependencies"
  include_context "with enriched commit"

  let(:categorizer) { instance_double Milestoner::Commits::Categorizer, call: [git_commit] }

  let :git_commit do
    Gitt::Models::Commit[
      author_email: "zoe@firefly.com",
      author_name: "Zoe Washburne",
      authored_at: "1672593010",
      authored_relative_at: "1 day ago",
      body: "For link:https://test.io[Test].",
      body_lines: [],
      body_paragraphs: [],
      lines: [],
      raw: "",
      sha: "180dec7d8ae8",
      subject: "Added documentation",
      signature: "Good",
      deletions: 10,
      insertions: 5,
      files_changed: 2,
      trailers: [
        Gitt::Models::Trailer[key: "Issue", value: "123"],
        Gitt::Models::Trailer[key: "Tracker", value: "git_hub"],
        Gitt::Models::Trailer[key: "Milestone", value: "patch"],
        Gitt::Models::Trailer[key: "Format", value: "asciidoc"]
      ]
    ]
  end

  describe "#call" do
    it "answers commits" do
      body = %(<div class="paragraph">\n<p>For <a href="https://test.io">Test</a>.</p>\n</div>)

      expect(enricher.call).to eq(
        Success(
          [
            Milestoner::Models::Commit[
              author: Milestoner::Models::User.new,
              authored_at: "1672593010",
              body:,
              deletions: 10,
              files_changed: 2,
              insertions: 5,
              sha: "180dec7d8ae8",
              signature: "Good",
              subject: "Added documentation",
              collaborators: [],
              format: "asciidoc",
              issue: Milestoner::Models::Link[
                id: "123",
                uri: "https://github.com/acme/test/issues/123"
              ],
              milestone: "patch",
              notes: "",
              review: Milestoner::Models::Link[
                id: "All",
                uri: "https://github.com/acme/test/pulls/"
              ],
              signers: [],
              uri: "https://github.com/acme/test/commit/180dec7d8ae8"
            ]
          ]
        )
      )
    end
  end
end
