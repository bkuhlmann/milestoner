# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Pusher do
  subject(:pusher) { described_class.new git: git }

  let(:git) { instance_spy Git::Kit::Core, tag_remote?: false, push_tags: "" }
  let(:version) { "0.0.0" }

  describe "#push" do
    it "successfully pushes tags to remote repository" do
      result = -> { pusher.push version }
      expect(&result).to output("").to_stdout
    end

    it "fails when remote repository is not configured" do
      allow(git).to receive(:remote?).and_return(false)
      result = -> { pusher.push version }

      expect(&result).to raise_error(Milestoner::Errors::Git, "Remote repository not configured.")
    end

    it "fails when remote tag exists" do
      allow(git).to receive(:tag_remote?).with(Versionaire::Version(version)).and_return(true)
      result = -> { pusher.push version }

      expect(&result).to raise_error(Milestoner::Errors::Git, "Remote tag exists: #{version}.")
    end

    it "fails when push fails" do
      allow(git).to receive(:push_tags).and_return("error")
      result = -> { pusher.push version }

      expect(&result).to raise_error(
        Milestoner::Errors::Git,
        "Tags could not be pushed to remote repository."
      )
    end
  end
end
