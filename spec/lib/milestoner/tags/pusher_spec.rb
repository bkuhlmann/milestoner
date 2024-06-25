# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Tags::Pusher do
  include Dry::Monads[:result]

  subject(:pusher) { described_class.new }

  include_context "with application dependencies"

  let(:git) { instance_spy Gitt::Repository, tag_remote?: false, tags_push: Success("[new tag]") }
  let(:status) { instance_spy Process::Status, success?: true }
  let(:version) { "1.2.3" }

  before { Milestoner::Container.stub git: }

  describe "#call" do
    it "answers version when success" do
      expect(pusher.call(version)).to eq(Success(version))
    end

    it "logs local tags pushed debug information when success" do
      pusher.call version
      expect(logger.reread).to match(/🔎.+Local tag pushed: 1.2.3./)
    end

    it "fails when remote repository is not configured" do
      allow(git).to receive(:origin?).and_return(false)
      expect(pusher.call(version)).to eq(Failure("Remote repository not configured."))
    end

    it "fails when remote tag exists" do
      allow(git).to receive(:tag_remote?).with(version).and_return(true)
      expect(pusher.call(version)).to eq(Failure("Remote tag exists: #{version}."))
    end

    it "answers failure when tags can't be pushed" do
      allow(git).to receive(:tags_push).and_return(Failure())

      expect(pusher.call(version)).to eq(
        Failure("Tags could not be pushed to remote repository.")
      )
    end
  end
end
