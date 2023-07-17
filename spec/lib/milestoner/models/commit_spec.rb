# frozen_string_literal: true

require "gitt"
require "spec_helper"

RSpec.describe Milestoner::Models::Commit do
  describe ".for" do
    it "answers commit for Gitt commit" do
      commit = described_class.for Gitt::Models::Commit[body_lines: [], raw: "original"],
                                   author: "Author",
                                   collaborators: ["Collaborator"],
                                   signers: ["Signer"]

      expect(commit).to eq(
        described_class[author: "Author", collaborators: ["Collaborator"], signers: ["Signer"]]
      )
    end
  end
end
