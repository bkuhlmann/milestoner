# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Versioner do
  using Refinements::Pathname
  using Versionaire::Cast

  subject(:versioner) { described_class.new }

  include_context "with Git repository"
  include_context "with application dependencies"

  describe "#call" do
    it "answers next major version" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `touch a.txt && git add --all && git commit --message "Added A" --trailer "Milestone=patch"`
        `touch b.txt && git add --all && git commit --message "Added B" --trailer "Milestone=major"`
        `touch c.txt && git add --all && git commit --message "Added C" --trailer "Milestone=minor"`

        expect(versioner.call).to eq(Version("1.0.0"))
      end
    end

    it "answers next minor version" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `touch a.txt && git add --all && git commit --message "Added A" --trailer "Milestone=patch"`
        `touch b.txt && git add --all && git commit --message "Added B" --trailer "Milestone=patch"`
        `touch c.txt && git add --all && git commit --message "Added C" --trailer "Milestone=minor"`

        expect(versioner.call).to eq(Version("0.1.0"))
      end
    end

    it "answers next patch version" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `touch a.txt && git add --all && git commit --message "Added A" --trailer "Milestone=patch"`
        `touch b.txt && git add --all && git commit --message "Added B" --trailer "Milestone=patch"`
        `touch c.txt && git add --all && git commit --message "Added C" --trailer "Milestone=patch"`

        expect(versioner.call).to eq(Version("0.0.1"))
      end
    end

    it "answers default version without version trailers" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `touch a.txt && git add --all && git commit --message "Added A"`
        `touch b.txt && git add --all && git commit --message "Added B"`
        `touch c.txt && git add --all && git commit --message "Added C"`

        expect(versioner.call).to eq(Version("0.0.0"))
      end
    end

    it "answers default version with versioned commits and no tags" do
      git_repo_dir.change_dir do
        `touch a.txt && git add --all && git commit --message "Added A" --trailer "Milestone=major"`
        expect(versioner.call).to eq(Version("0.0.0"))
      end
    end

    it "answers default version when no tags exist" do
      git_repo_dir.change_dir { expect(versioner.call).to eq(Version("0.0.0")) }
    end

    it "answers logs debug information for invalid tag" do
      git_repo_dir.change_dir do
        `git tag bogus`
        `touch a.txt && git add --all && git commit --message "Added A" --trailer "Milestone=patch"`
        versioner.call

        expect(logger.reread).to match(/🔎.+Invalid version/)
      end
    end

    it "answers default version with invalid tag" do
      git_repo_dir.change_dir do
        `git tag bogus`
        `touch a.txt && git add --all && git commit --message "Added A" --trailer "Milestone=patch"`

        expect(versioner.call).to eq(Version("0.0.0"))
      end
    end
  end
end
