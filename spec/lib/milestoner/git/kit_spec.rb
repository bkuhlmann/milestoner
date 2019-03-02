# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Git::Kit, :temp_dir do
  subject(:kit) { described_class.new }

  let(:git_dir) { File.join temp_dir, ".git" }

  describe "#supported?" do
    context "when .git directory exists" do
      before { FileUtils.mkdir_p git_dir }

      it "answers true" do
        Dir.chdir(temp_dir) { expect(kit.supported?).to eq(true) }
      end
    end

    context "when .git directory doesn't exist" do
      it "answers false" do
        Dir.chdir(temp_dir) { expect(kit.supported?).to eq(false) }
      end
    end
  end

  describe "#commits?" do
    context "when repository has commits", :git_repo do
      it "answers true" do
        Dir.chdir(git_repo_dir) { expect(kit.commits?).to eq(true) }
      end
    end

    context "when repository doesn't have commits" do
      before { Dir.chdir(temp_dir) { `git init` } }

      it "answers false" do
        Dir.chdir(temp_dir) { expect(kit.commits?).to eq(false) }
      end
    end
  end

  describe "push_tags", :git_repo do
    # rubocop:disable RSpec/SubjectStub
    it "successfully pushes tags" do
      allow(kit).to receive(:`).and_return("")
      expect(kit.push_tags).to eq("")
    end
    # rubocop:enable RSpec/SubjectStub

    # rubocop:disable RSpec/SubjectStub
    it "fails to push tags" do
      allow(kit).to receive(:`).and_return("error")
      expect(kit.push_tags).to eq("error")
    end
    # rubocop:enable RSpec/SubjectStub
  end

  describe "#tagged?", :git_repo do
    context "with exiting tags" do
      it "answers true" do
        Dir.chdir git_repo_dir do
          `git tag 0.1.0`
          expect(kit.tagged?).to eq(true)
        end
      end
    end

    context "without existing tags" do
      it "answers false" do
        Dir.chdir git_repo_dir do
          expect(kit.tagged?).to eq(false)
        end
      end
    end

    context "with uninitialized repository" do
      it "answers false" do
        ClimateControl.modify GIT_DIR: temp_dir.to_s do
          expect(kit.tagged?).to eq(false)
        end
      end
    end
  end

  describe "#tag_local?", :git_repo do
    let(:tag) { "0.1.0" }

    context "with matching tag" do
      it "answers true" do
        Dir.chdir git_repo_dir do
          `git tag #{tag}`
          expect(kit.tag_local?(tag)).to eq(true)
        end
      end
    end

    context "without matching tag" do
      it "answers false" do
        Dir.chdir git_repo_dir do
          expect(kit.tag_local?(tag)).to eq(false)
        end
      end
    end
  end

  describe "#tag_remote?", :git_repo do
    context "with matching tag" do
      it "answers true" do
        Dir.chdir git_repo_dir do
          expect(kit.tag_remote?("0.1.0")).to eq(true)
        end
      end
    end

    context "without matching tag" do
      it "answers false" do
        Dir.chdir git_repo_dir do
          expect(kit.tag_remote?("v0.1.0")).to eq(false)
        end
      end
    end
  end

  describe "#remote?" do
    before { Dir.chdir(temp_dir) { `git init` } }

    context "when remote repository is defined" do
      before do
        Dir.chdir(temp_dir) { `git config remote.origin.url git@github.com:test/example.git` }
      end

      it "answers true" do
        Dir.chdir(temp_dir) { expect(kit.remote?).to eq(true) }
      end
    end

    context "when remote repository is not defined" do
      it "answers false" do
        Dir.chdir(temp_dir) { expect(kit.remote?).to eq(false) }
      end
    end
  end
end
