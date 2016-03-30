# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Pusher, :temp_dir do
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

    context "when remote repository is not defined " do
      subject { described_class.new }

      it "fails with Git error when remote repository is not defined" do
        Dir.chdir temp_dir do
          `git init`
          result = -> { subject.push }

          expect(&result).to raise_error(Milestoner::Errors::Git, "Git remote repository not configured.")
        end
      end
    end

    context "when push is unsuccessful" do
      let(:kernel) { class_spy Kernel, system: false }

      it "fails with Git error when push is unsuccessful", :git_repo do
        Dir.chdir git_repo_dir do
          result = -> { subject.push }
          expect(&result).to raise_error(Milestoner::Errors::Git, "Git tags could not be pushed to remote repository.")
        end
      end
    end
  end
end
