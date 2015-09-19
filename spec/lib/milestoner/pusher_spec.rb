require "spec_helper"

describe Milestoner::Pusher, :temp_dir do
  subject { described_class.new }

  describe "#push" do
    let(:kernel) { class_spy Kernel }
    subject { described_class.new kernel: kernel }

    it "pushes tags to remote repository", :git_repo do
      Dir.chdir git_repo_dir do
        subject.push
        expect(kernel).to have_received(:system).with("git push --tags")
      end
    end

    it "fails with Git error when not a Git repository" do
      Dir.chdir temp_dir do
        result = -> { subject.push }
        expect(&result).to raise_error(Milestoner::Errors::Git, "Invalid Git repository.")
      end
    end

    it "fails with Git error when remote repository is not defined" do
      Dir.chdir temp_dir do
        `git init`
        subject = described_class.new
        result = -> { subject.push }

        expect(&result).to raise_error(Milestoner::Errors::Git, "Git remote repository is not configured.")
      end
    end
  end
end
