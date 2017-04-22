# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Publisher do
  let(:version) { "0.1.0" }
  let(:tagger) { instance_spy Milestoner::Tagger }
  let(:pusher) { instance_spy Milestoner::Pusher }
  subject { described_class.new tagger: tagger, pusher: pusher }

  describe "#publish" do
    context "with success" do
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

    context "with failure" do
      before { allow(tagger).to receive(:create).and_raise(Milestoner::Errors::Git) }

      it "deletes tag and raises error", :aggregate_failures do
        result = -> { subject.publish version }

        expect(&result).to raise_error(Milestoner::Errors::Git)
        expect(tagger).to have_received(:delete).with(version)
      end
    end
  end
end
