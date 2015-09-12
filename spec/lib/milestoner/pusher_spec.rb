require "spec_helper"

describe Milestoner::Pusher, :temp_dir do
  subject { described_class.new }

  describe "#initialize" do
    it "fails with Git error when not a Git repository" do
      Dir.chdir temp_dir do
        result = -> { described_class.new }
        expect(&result).to raise_error(Milestoner::Errors::Git)
      end
    end
  end

  describe "#push" do
    let(:kernel) { class_spy Kernel }
    subject { described_class.new kernel: kernel }

    it "pushes tags to remote repository" do
      subject.push
      expect(kernel).to have_received(:system).with("git push --tags")
    end
  end
end
