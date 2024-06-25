# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Tags::Publisher do
  include Dry::Monads[:result]

  subject(:publisher) { described_class.new creator:, pusher: }

  include_context "with application dependencies"

  let(:creator) { instance_spy Milestoner::Tags::Creator, call: Success(version) }
  let(:pusher) { instance_spy Milestoner::Tags::Pusher, call: Success(version) }
  let(:version) { "1.2.3" }

  describe "#call" do
    it "creates tag" do
      publisher.call version
      expect(creator).to have_received(:call).with(version)
    end

    it "pushes tags" do
      publisher.call version
      expect(pusher).to have_received(:call).with(version)
    end

    it "answers version when success" do
      expect(publisher.call(version)).to eq(Success(version))
    end

    it "logs published version when success" do
      publisher.call version
      expect(logger.reread).to match(/🟢.+Published: 1.2.3/)
    end

    it "answers failure when create fails" do
      allow(creator).to receive(:call).with(version).and_return Failure("Danger!")
      expect(publisher.call(version)).to eq(Failure("Danger!"))
    end

    it "answers failure when push fails" do
      allow(pusher).to receive(:call).with(version).and_return Failure("Danger!")
      expect(publisher.call(version)).to eq(Failure("Danger!"))
    end
  end
end
