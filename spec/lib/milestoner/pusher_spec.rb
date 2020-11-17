# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Pusher do
  subject(:pusher) { described_class.new repository: repository }

  let :repository do
    instance_spy GitPlus::Repository, tag_remote?: false, tag_push: ["", "[new tag]", status]
  end

  let(:status) { instance_spy Process::Status, success?: true }
  let(:version) { "0.0.0" }

  describe "#push" do
    it "successfully pushes tags to remote repository" do
      result = -> { pusher.push version }
      expect(&result).to output("").to_stdout
    end

    it "fails when remote repository is not configured" do
      allow(repository).to receive(:config_remote?).and_return(false)
      result = -> { pusher.push version }

      expect(&result).to raise_error(Milestoner::Errors::Git, "Remote repository not configured.")
    end

    it "fails when remote tag exists" do
      allow(repository).to receive(:tag_remote?).with(Versionaire::Version(version))
                                                .and_return(true)
      result = -> { pusher.push version }

      expect(&result).to raise_error(Milestoner::Errors::Git, "Remote tag exists: #{version}.")
    end

    context "when push fails to succeed" do
      let(:status) { instance_spy Process::Status, success?: false }

      it "fails when push fails" do
        result = -> { pusher.push version }

        expect(&result).to raise_error(
          Milestoner::Errors::Git,
          "Tags could not be pushed to remote repository."
        )
      end
    end

    context "when push succeeds but standard error doesn't have new tag" do
      let :repository do
        instance_spy GitPlus::Repository, tag_remote?: false, tag_push: ["", "", status]
      end

      it "fails when push fails" do
        result = -> { pusher.push version }

        expect(&result).to raise_error(
          Milestoner::Errors::Git,
          "Tags could not be pushed to remote repository."
        )
      end
    end
  end
end
