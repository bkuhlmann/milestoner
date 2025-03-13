# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Collector do
  using Refinements::Pathname

  subject(:collector) { described_class.new }

  include_context "with Git repository"

  describe "#call" do
    let(:subjects) { collector.call.value_or([]).map(&:subject) }

    it "answers commits from first commit to tag when tag exists" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`

        subjects = collector.call(min: nil, max: "0.0.0").value_or([]).map(&:subject)

        expect(subjects).to contain_exactly("Added documentation")
      end
    end

    it "answers commits since last tag when tag exists" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `touch a.txt && git add --all && git commit --message "Added A"`
        `touch b.txt && git add --all && git commit --message "Added B"`

        expect(subjects).to contain_exactly("Added A", "Added B")
      end
    end

    it "answers specific range of commits when tag exists" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `touch a.txt && git add --all && git commit --message "Added A"`
        `touch b.txt && git add --all && git commit --message "Added B"`

        subjects = collector.call(min: "0.0.0", max: "HEAD").value_or([]).map(&:subject)

        expect(subjects).to contain_exactly("Added A", "Added B")
      end
    end

    it "fails when commit range is invalid and tag exists" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`

        expect(collector.call(min: :danger, max: :invalid)).to be_failure(
          "Invalid minimum and/or maximum range: danger..invalid."
        )
      end
    end

    it "answers all commits when no tags exist" do
      git_repo_dir.change_dir do
        `touch a.txt && git add --all && git commit --message "Added A"`
        `touch b.txt && git add --all && git commit --message "Added B"`

        expect(subjects).to contain_exactly("Added documentation", "Added A", "Added B")
      end
    end

    it "answers failure when repository has no commits" do
      temp_dir.change_dir do
        `git init`

        expect(collector.call).to be_failure(
          "fatal: your current branch 'main' does not have any commits yet\n"
        )
      end
    end
  end
end
