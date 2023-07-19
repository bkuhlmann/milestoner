# frozen_string_literal: true

RSpec.shared_context "with enriched commit" do
  let :commit do
    Milestoner::Models::Commit[
      author: Milestoner::Models::User[external_id: "1", handle: "zoe", name: "Zoe Washburne"],
      authored_at: "1672593010",
      body: "For link:https://asciidoctor.org[ASCII Doc].",
      collaborators: [
        Milestoner::Models::User[external_id: "2", handle: "river", name: "River Tam"]
      ],
      sha: "180dec7d8ae8",
      subject: "Added documentation",
      deletions: 10,
      format: :asciidoc,
      files_changed: 2,
      issue: Milestoner::Models::Link[id: "123", uri: "https://issue.firefly.com/123"],
      insertions: 5,
      notes: "",
      milestone: "patch",
      review: Milestoner::Models::Link[id: "999", uri: "https://review.firefly.com/456"],
      signature: "Good",
      signers: [
        Milestoner::Models::User[external_id: "3", handle: "mal", name: "Malcolm Renolds"]
      ],
      uri: "https://source.firefly.com/serenity/commit/180dec7d8ae8"
    ]
  end
end
