# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Milestoner::Tags::Pusher do
  using Versionaire::Cast

  subject(:pusher) { described_class.new }

  include_context "with application container"

  let :repository do
    instance_spy GitPlus::Repository, tag_remote?: false, tag_push: ["", "[new tag]", status]
  end

  let(:status) { instance_spy Process::Status, success?: true }
  let(:configuration) { Milestoner::CLI::Configuration::Content[git_tag_version: Version("0.0.0")] }

  before { application_container.stub :repository, repository }

  after { application_container.unstub :repository }

  describe "#call" do
    it "logs successfull push" do
      result = proc { pusher.call configuration }
      expect(&result).to output("Local tag pushed: 0.0.0.\n").to_stdout
    end

    it "answers true with successful push" do
      expect(pusher.call(configuration)).to eq(true)
    end

    it "fails when remote repository is not configured" do
      allow(repository).to receive(:config_origin?).and_return(false)
      result = -> { pusher.call configuration }

      expect(&result).to raise_error(Milestoner::Error, "Remote repository not configured.")
    end

    it "fails when remote tag exists" do
      version = configuration.git_tag_version
      allow(repository).to receive(:tag_remote?).with(version).and_return(true)
      result = -> { pusher.call configuration }

      expect(&result).to raise_error(Milestoner::Error, "Remote tag exists: #{version}.")
    end

    context "when push fails to succeed" do
      let(:status) { instance_spy Process::Status, success?: false }

      it "fails with error" do
        result = -> { pusher.call configuration }

        expect(&result).to raise_error(
          Milestoner::Error,
          "Tags could not be pushed to remote repository."
        )
      end
    end

    context "when push succeeds but standard error doesn't have new tag" do
      let :repository do
        instance_spy GitPlus::Repository, tag_remote?: false, tag_push: ["", "", status]
      end

      it "fails when push fails" do
        result = -> { pusher.call configuration }

        expect(&result).to raise_error(
          Milestoner::Error,
          "Tags could not be pushed to remote repository."
        )
      end
    end
  end
end
