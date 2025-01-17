# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Categorizer do
  using Refinements::Pathname

  subject(:categorizer) { described_class.new }

  include_context "with Git repository"
  include_context "with application dependencies"

  describe "#call" do
    let(:subjects) { categorizer.call.map { |_, commit| commit.subject } }

    it "answers commits since last tag when tagged" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `rm -f README.md`
        `git add --all .`
        `git commit --message "Removed README"`

        expect(subjects).to contain_exactly("Removed README")
      end
    end

    it "answers all commits when not tagged" do
      git_repo_dir.change_dir { expect(subjects).to contain_exactly("Added documentation") }
    end

    context "with prefixed commits" do
      before do
        git_repo_dir.change_dir do
          `touch a.txt && git add --all && git commit --message "This is not a good commit message"`
          `touch b.txt && git add --all && git commit --message "Updated gem dependencies"`
          `touch c.txt && git add --all && git commit --message "Fixed README typos"`
          `touch d.txt && git add --all && git commit --message "Updated version release notes"`
          `touch e.txt && git add --all && git commit --message "Removed unused stylesheets"`
          `touch g.txt && git add --all && git commit --message "Refactored authorization"`
        end
      end

      let :proof do
        [
          "Added documentation",
          "Updated gem dependencies",
          "Updated version release notes",
          "Fixed README typos",
          "Removed unused stylesheets",
          "Refactored authorization",
          "This is not a good commit message"
        ]
      end

      it "answers commits grouped by prefix and alpha-sorted per group" do
        git_repo_dir.change_dir { expect(subjects).to eq(proof) }
      end
    end

    context "with prefixed commits using special characters" do
      subject(:categorizer) { described_class.new settings: }

      let :proof do
        [
          "[one] more",
          "=+-#",
          "with spaces",
          "Added documentation",
          "Apple"
        ]
      end

      before do
        git_repo_dir.change_dir do
          `touch a.txt && git add --all && git commit --message "Apple"`
          `touch b.txt && git add --all && git commit --message "with spaces"`
          `touch c.txt && git add --all && git commit --message "=+-#"`
          `touch d.txt && git add --all && git commit --message "[one] more"`
        end
      end

      it "answers commits grouped by prefix and alpha-sorted per group" do
        git_repo_dir.change_dir do
          settings.commit_categories = [{label: "[one]"}, {label: "=+-#"}, {label: "with spaces"}]
          expect(subjects).to eq(proof)
        end
      end
    end

    context "without prefixed commits" do
      subject(:categorizer) { described_class.new settings: }

      before do
        git_repo_dir.change_dir do
          `touch a.txt && git add --all && git commit --message "One"`
          `touch b.txt && git add --all && git commit --message "Two"`
        end
      end

      it "answers alphabetically sorted commits" do
        git_repo_dir.change_dir do
          settings.commit_categories = []
          expect(subjects).to eq(["Added documentation", "One", "Two"])
        end
      end
    end
  end
end
