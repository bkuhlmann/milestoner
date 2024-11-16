# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Commits::Enricher do
  include Dry::Monads[:result]

  using Refinements::Struct

  subject(:enricher) { described_class.new categorizer: }

  include_context "with application dependencies"
  include_context "with enriched commit"

  let(:categorizer) { instance_double Milestoner::Commits::Categorizer, call: [[1, git_commit]] }

  let :git_commit do
    commit.with
    Gitt::Models::Commit[
      author_email: "zoe@firefly.com",
      author_name: "Zoe Washburne",
      authored_at: "1672593010",
      authored_relative_at: "1 day ago",
      body: "For link:https://test.io[Test].",
      body_lines: [],
      body_paragraphs: [],
      committed_at: "1672611315",
      committed_relative_at: "5 minutes ago",
      deletions: 10,
      files_changed: 2,
      insertions: 5,
      lines: [],
      raw: "",
      sha: "180dec7d8ae8",
      signature: "Good",
      subject: "Added documentation",
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
      settings.merge! commit_uri: "https://github.com/tester/test/commit/%<id>s",
                      review_uri: "https://github.com/tester/test/pulls/%<id>s",
                      tracker_uri: "https://github.com/tester/test/issues/%<id>s"

      body = %(<div class="paragraph">\n<p>For <a href="https://test.io">Test</a>.</p>\n</div>)

      expect(enricher.call).to eq(
        Success(
          [
            Milestoner::Models::Commit[
              author: Milestoner::Models::User.new,
              authored_at: "1672593010",
              authored_relative_at: "1 day ago",
              body: "For link:https://test.io[Test].",
              body_html: body,
              collaborators: [],
              committed_at: "1672611315",
              committed_relative_at: "5 minutes ago",
              created_at: Time.new(2023, 1, 1, 10, 10, 10, "-0700"),
              deletions: 10,
              files_changed: 2,
              format: "asciidoc",
              insertions: 5,
              issue: Milestoner::Models::Link[
                id: "123",
                uri: "https://github.com/tester/test/issues/123"
              ],
              milestone: "patch",
              notes_html: "",
              position: 1,
              review: Milestoner::Models::Link[
                id: "All",
                uri: "https://github.com/tester/test/pulls/"
              ],
              sha: "180dec7d8ae8",
              signature: "Good",
              signers: [],
              subject: "Added documentation",
              updated_at: Time.new(2023, 1, 1, 15, 15, 15, "-0700"),
              uri: "https://github.com/tester/test/commit/180dec7d8ae8"
            ]
          ]
        )
      )
    end
  end
end
