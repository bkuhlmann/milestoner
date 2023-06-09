# frozen_string_literal: true

require "dry/monads"
require "spec_helper"
require "versionaire"

RSpec.describe Milestoner::Tags::Pusher do
  include Dry::Monads[:result]

  using Versionaire::Cast
  using Infusible::Stub

  subject(:pusher) { described_class.new }

  include_context "with application dependencies"

  let(:git) { instance_spy Gitt::Repository, tag_remote?: false, tags_push: Success("[new tag]") }
  let(:status) { instance_spy Process::Status, success?: true }
  let(:configuration) { Milestoner::Configuration::Model[version: Version("0.0.0")] }

  before { Milestoner::Import.stub git: }

  after { Milestoner::Import.unstub :git }

  describe "#call" do
    it "logs successfull push" do
      pusher.call configuration
      expect(logger.reread).to match(/🔎.+Local tag pushed: 0.0.0./)
    end

    it "answers true with successful push" do
      expect(pusher.call(configuration)).to be(true)
    end

    it "fails when remote repository is not configured" do
      allow(git).to receive(:origin?).and_return(false)
      result = -> { pusher.call configuration }

      expect(&result).to raise_error(Milestoner::Error, "Remote repository not configured.")
    end

    it "fails when remote tag exists" do
      version = configuration.version
      allow(git).to receive(:tag_remote?).with(version).and_return(true)
      result = -> { pusher.call configuration }

      expect(&result).to raise_error(Milestoner::Error, "Remote tag exists: #{version}.")
    end

    context "when push fails to succeed" do
      it "fails with error" do
        allow(git).to receive(:tags_push).and_return(Failure(""))

        result = -> { pusher.call configuration }

        expect(&result).to raise_error(
          Milestoner::Error,
          "Tags could not be pushed to remote repository."
        )
      end
    end
  end
end
