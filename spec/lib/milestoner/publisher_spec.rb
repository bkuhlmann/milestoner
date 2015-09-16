require "spec_helper"

describe Milestoner::Publisher do
  let(:version) { "0.1.0" }
  let(:tagger) { instance_spy Milestoner::Tagger }
  let(:pusher) { instance_spy Milestoner::Pusher }
  subject { described_class.new tagger, pusher }

  describe "#publish" do
    it "creates tag" do
      subject.publish version
      expect(tagger).to have_received(:create).with(version, sign: false)
    end

    it "creates signed tag" do
      subject.publish version, sign: true
      expect(tagger).to have_received(:create).with(version, sign: true)
    end

    it "pushed tag" do
      subject.publish version
      expect(pusher).to have_received(:push)
    end

    it "destroys tag when exception occurs", :aggregate_failures do
      allow(tagger).to receive(:create).and_raise(Milestoner::Errors::Git)
      result = -> { subject.publish version }

      expect(&result).to raise_error(Milestoner::Errors::Git)
      expect(tagger).to have_received(:destroy)
    end
  end
end
