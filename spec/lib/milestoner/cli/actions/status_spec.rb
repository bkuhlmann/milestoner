# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Status do
  using Refinements::Pathnames

  subject(:action) { described_class.new }

  include_context "with Git repository"

  describe "#call" do
    it "logs new commits when they exist" do
      git_repo_dir.change_dir do
        result = proc { action.call }
        expect(&result).to output("- Added documentation - Test User\n").to_stdout
      end
    end

    it "logs nothing when commits don't exist" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        result = proc { action.call }

        expect(&result).to output("All is quiet.\n").to_stdout
      end
    end

    it "fails when status can't be obtained" do
      categorizer = instance_double Milestoner::Commits::Categorizer
      allow(categorizer).to receive(:call).and_raise(Milestoner::Error, "Danger!")
      expectation = proc { described_class.new(categorizer: categorizer).call }

      expect(&expectation).to raise_error(Milestoner::Error, "Danger!")
    end
  end
end
