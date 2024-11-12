# frozen_string_literal: true

RSpec.shared_context "with enriched commit" do
  let :commit do
    Milestoner::Models::Commit[
      author: Milestoner::Models::User[external_id: "1", handle: "zoe", name: "Zoe Washburne"],
      authored_at: "1672593010",
      authored_relative_at: "5 hours ago",
      body: "For link:https://asciidoctor.org[ASCII Doc].",
      body_html: %(For <a href="https://asciidoctor.org">ASCII Doc</a>.),
      collaborators: [
        Milestoner::Models::User[external_id: "2", handle: "river", name: "River Tam"]
      ],
      committed_at: "1672611315",
      committed_relative_at: "5 minutes ago",
      created_at: Time.new(2023, 1, 1, 10, 10, 10),
      deletions: 10,
      encoding: "",
      files_changed: 2,
      fingerprint: "",
      fingerprint_key: "",
      format: :asciidoc,
      insertions: 5,
      issue: Milestoner::Models::Link[id: "123", uri: "https://issue.firefly.com/123"],
      milestone: "patch",
      notes: "For link:https://asciidoctor.org[ASCII Doc].",
      notes_html: %(For <a href="https://asciidoctor.org">ASCII Doc</a>.),
      position: 1,
      review: Milestoner::Models::Link[id: "999", uri: "https://review.firefly.com/456"],
      sha: "180dec7d8ae8",
      signature: "Good",
      signers: [
        Milestoner::Models::User[external_id: "3", handle: "mal", name: "Malcolm Renolds"]
      ],
      subject: "Added documentation",
      updated_at: Time.new(2023, 1, 1, 15, 15, 15),
      uri: "https://source.firefly.com/serenity/commit/180dec7d8ae8"
    ]
  end
end
