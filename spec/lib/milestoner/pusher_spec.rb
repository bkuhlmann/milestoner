require "spec_helper"

describe Milestoner::Pusher do
  subject { described_class.new }

  describe "#push" do
    let(:kernel) { class_spy Kernel }
    subject { described_class.new kernel: kernel }

    it "pushes tags to remote repository" do
      subject.push
      expect(kernel).to have_received(:system).with("git push --tags")
    end
  end
end
