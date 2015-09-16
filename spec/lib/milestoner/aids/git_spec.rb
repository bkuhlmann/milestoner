require "spec_helper"

describe Milestoner::Aids::Git, :temp_dir do
  subject { instance_double("dummy").extend Milestoner::Aids::Git }
  let(:git_dir) { File.join temp_dir, ".git" }

  describe "#git_supported?" do
    context "when .git directory exists" do
      before { FileUtils.mkdir_p git_dir }

      it "answers true" do
        Dir.chdir(temp_dir) { expect(subject.git_supported?).to eq(true) }
      end
    end

    context "when .git directory doesn't exist" do
      it "answers false" do
        Dir.chdir(temp_dir) { expect(subject.git_supported?).to eq(false) }
      end
    end
  end

  describe "#git_remote?" do
    before { Dir.chdir(temp_dir) { `git init` } }

    context "when remote repository is defined" do
      before do
        Dir.chdir(temp_dir) { `git config remote.origin.url git@github.com:example/example.git` }
      end

      it "answers true" do
        Dir.chdir(temp_dir) { expect(subject.git_remote?).to eq(true) }
      end
    end

    context "when remote repository is not defined" do
      it "answers false" do
        Dir.chdir(temp_dir) { expect(subject.git_remote?).to eq(false) }
      end
    end
  end
end
