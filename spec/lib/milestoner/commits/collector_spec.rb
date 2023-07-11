# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Collector do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:collector) { described_class.new }

  include_context "with Git repository"

  describe "#call" do
    let(:subjects) { collector.call.value_or([]).map(&:subject) }

    it "answers commits since last tag when tag exists" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `touch a.txt && git add --all && git commit --message "Added A"`
        `touch b.txt && git add --all && git commit --message "Added B"`

        expect(subjects).to contain_exactly("Added A", "Added B")
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

        expect(collector.call).to eq(
          Failure("fatal: your current branch 'main' does not have any commits yet\n")
        )
      end
    end
  end
end
