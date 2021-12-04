# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Categorizer do
  using Refinements::Pathnames

  subject(:categorizer) { described_class.new }

  include_context "with Git repository"

  describe "#call" do
    it "answers commits since last tag when tagged" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `rm -f README.md`
        `git commit --all --message "Removed README"`

        expect(categorizer.call.map(&:subject)).to contain_exactly("Removed README")
      end
    end

    it "answers all commits when not tagged" do
      git_repo_dir.change_dir do
        expect(categorizer.call.map(&:subject)).to contain_exactly("Added documentation")
      end
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
          "Fixed README typos",
          "Added documentation",
          "Updated gem dependencies",
          "Updated version release notes",
          "Removed unused stylesheets",
          "Refactored authorization",
          "This is not a good commit message"
        ]
      end

      it "answers commits grouped by prefix and alpha-sorted per group" do
        git_repo_dir.change_dir { expect(categorizer.call.map(&:subject)).to eq(proof) }
      end
    end

    context "with prefixed commits using special characters" do
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
          configuration = Milestoner::Configuration::Content[
            prefixes: ["[one]", "=+-#", "with spaces"]
          ]
          subjects = categorizer.call(configuration).map(&:subject)

          expect(subjects).to eq(proof)
        end
      end
    end

    context "without prefixed commits" do
      before do
        git_repo_dir.change_dir do
          `touch a.txt && git add --all && git commit --message "One"`
          `touch b.txt && git add --all && git commit --message "Two"`
        end
      end

      it "answers alphabetically sorted commits" do
        git_repo_dir.change_dir do
          configuration = Milestoner::Configuration::Content[prefixes: []]
          subjects = categorizer.call(configuration).map(&:subject)

          expect(subjects).to eq(["Added documentation", "One", "Two"])
        end
      end
    end

    context "with duplicate commit messages" do
      before do
        git_repo_dir.change_dir do
          `touch a.txt && git add --all && git commit --message "Updated gem dependencies"`
          `touch b.txt && git add --all && git commit --message "Updated gem dependencies"`
        end
      end

      it "answers commits with duplicates removed" do
        git_repo_dir.change_dir do
          expect(categorizer.call.map(&:subject)).to eq(
            [
              "Added documentation",
              "Updated gem dependencies"
            ]
          )
        end
      end
    end
  end
end
