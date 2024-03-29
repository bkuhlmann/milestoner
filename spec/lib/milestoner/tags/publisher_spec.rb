# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Milestoner::Tags::Publisher do
  using Versionaire::Cast

  subject(:publisher) { described_class.new creator:, pusher: }

  include_context "with application dependencies"

  let(:creator) { instance_spy Milestoner::Tags::Creator }
  let(:pusher) { instance_spy Milestoner::Tags::Pusher }

  describe "#call" do
    it "creates tag" do
      publisher.call
      expect(creator).to have_received(:call).with(nil)
    end

    it "pushes tags" do
      publisher.call
      expect(pusher).to have_received(:call).with(nil)
    end

    it "logs successful publish" do
      publisher.call
      expect(logger.reread).to match(/🟢.+Published: 1.2.3!/)
    end

    it "answers true with successful publish" do
      expect(publisher.call).to be(true)
    end
  end
end
