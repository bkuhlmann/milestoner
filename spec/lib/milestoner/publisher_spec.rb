# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Publisher do
  let(:version) { "0.1.0" }
  let(:tagger) { instance_spy Milestoner::Tagger }
  let(:pusher) { instance_spy Milestoner::Pusher }
  subject { described_class.new tagger: tagger, pusher: pusher }

  describe "#publish" do
    it "creates tag" do
      subject.publish version
      expect(tagger).to have_received(:create).with(version, sign: false)
    end

    it "creates signed tag" do
      subject.publish version, sign: true
      expect(tagger).to have_received(:create).with(version, sign: true)
    end

    it "pushes tag to remote repository" do
      subject.publish version
      expect(pusher).to have_received(:push)
    end
  end
end
