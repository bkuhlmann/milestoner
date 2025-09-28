# frozen_string_literal: true

require "gitt"
require "spec_helper"

RSpec.describe Milestoner::Models::Commit do
  subject :commit do
    described_class[
      author: Milestoner::Models::User[external_id: 1, handle: "jsmith", name: "Jill Smith"],
      collaborators: [
        Milestoner::Models::User[external_id: 2, handle: "bbob", name: "Billy Bob"]
      ],
      signers: [
        Milestoner::Models::User[external_id: 3, handle: "csmith", name: "Charlie Smith"]
      ]
    ]
  end

  describe ".for" do
    it "answers commit for Gitt commit" do
      commit = described_class.for Gitt::Models::Commit[body_paragraphs: [], raw: "original"],
                                   author: "Author",
                                   collaborators: ["Collaborator"],
                                   signers: ["Signer"]

      expect(commit).to eq(
        described_class[author: "Author", collaborators: ["Collaborator"], signers: ["Signer"]]
      )
    end
  end

  describe "#contributors" do
    it "answers author, collaborators, and signers sorted by name" do
      expect(commit.contributors).to eq(
        [
          Milestoner::Models::User[external_id: 2, handle: "bbob", name: "Billy Bob"],
          Milestoner::Models::User[external_id: 3, handle: "csmith", name: "Charlie Smith"],
          Milestoner::Models::User[external_id: 1, handle: "jsmith", name: "Jill Smith"]
        ]
      )
    end
  end
end
