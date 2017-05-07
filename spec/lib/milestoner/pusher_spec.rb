# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Pusher do
  let(:git) { instance_spy Milestoner::Git::Kit, tag_remote?: false, push_tags: "" }
  let(:version) { "v0.0.0" }
  subject { described_class.new git: git }

  describe "#push" do
    it "successfully pushes tags to remote repository" do
      result = -> { subject.push version }
      expect(&result).to output("").to_stdout
    end

    it "fails when remote repository is not configured" do
      allow(git).to receive(:remote?).and_return(false)
      result = -> { subject.push version }

      expect(&result).to raise_error(Milestoner::Errors::Git, "Remote repository not configured.")
    end

    it "fails when remote tag exists" do
      allow(git).to receive(:tag_remote?).with(version).and_return(true)
      result = -> { subject.push version }

      expect(&result).to raise_error(Milestoner::Errors::Git, "Remote tag exists: #{version}.")
    end

    it "fails when push fails" do
      allow(git).to receive(:push_tags).and_return("error")
      result = -> { subject.push version }

      expect(&result).to raise_error(
        Milestoner::Errors::Git,
        "Tags could not be pushed to remote repository."
      )
    end
  end
end
