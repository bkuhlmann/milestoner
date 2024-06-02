# frozen_string_literal: true

require "dry/monads"
require "spec_helper"
require "versionaire"

RSpec.describe Milestoner::Tags::Pusher do
  include Dry::Monads[:result]

  using Versionaire::Cast

  subject(:pusher) { described_class.new }

  include_context "with application dependencies"

  let(:git) { instance_spy Gitt::Repository, tag_remote?: false, tags_push: Success("[new tag]") }
  let(:status) { instance_spy Process::Status, success?: true }

  before { Milestoner::Container.stub git: }

  describe "#call" do
    it "logs success" do
      pusher.call
      expect(logger.reread).to match(/🔎.+Local tag pushed: 1.2.3./)
    end

    it "answers true with successful" do
      expect(pusher.call).to be(true)
    end

    it "fails with invalid version" do
      result = -> { pusher.call "bogus" }
      expect(&result).to raise_error(Milestoner::Error, /Invalid version/)
    end

    it "fails when remote repository is not configured" do
      allow(git).to receive(:origin?).and_return(false)
      result = -> { pusher.call }

      expect(&result).to raise_error(Milestoner::Error, "Remote repository not configured.")
    end

    it "fails when remote tag exists" do
      version = settings.project_version
      allow(git).to receive(:tag_remote?).with(version).and_return(true)
      result = -> { pusher.call }

      expect(&result).to raise_error(Milestoner::Error, "Remote tag exists: #{version}.")
    end

    context "when push fails" do
      it "fails with error" do
        allow(git).to receive(:tags_push).and_return(Failure(""))

        result = -> { pusher.call }

        expect(&result).to raise_error(
          Milestoner::Error,
          "Tags could not be pushed to remote repository."
        )
      end
    end
  end
end
