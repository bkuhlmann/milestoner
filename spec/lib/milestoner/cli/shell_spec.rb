# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Shell do
  using Refinements::Pathnames

  subject(:shell) { described_class.new }

  include_context "with Git repository"
  include_context "with application container"

  let :tag_details do
    ->(version) { Open3.capture2(%(git show --stat --pretty=format:"%b" #{version})).first }
  end

  describe "#call" do
    it "edits configuration" do
      shell.call %w[--config edit]
      expect(kernel).to have_received(:system).with(include("EDITOR"))
    end

    it "views configuration" do
      shell.call %w[--config view]
      expect(kernel).to have_received(:system).with(include("cat"))
    end

    it "creates tag when publishing" do
      git_repo_dir.change_dir do
        shell.call %w[--publish 0.0.0]
      rescue Milestoner::Error
        expect(tag_details.call("0.0.0")).to match(/Version\s0\.0\.0/)
      end
    end

    it "fails to publish when remote repository doesn't exist" do
      git_repo_dir.change_dir do
        result = proc { shell.call %w[--publish 0.0.0] }
        expect(&result).to output(/could not be pushed/).to_stdout
      end
    end

    it "fails to push when remote repository doesn't exist" do
      git_repo_dir.change_dir do
        result = proc { shell.call %w[--push 0.0.0] }
        expect(&result).to output(/could not be pushed/).to_stdout
      end
    end

    it "prints project status when commits exist" do
      git_repo_dir.change_dir do
        result = proc { shell.call %w[--status] }
        expect(&result).to output("- Added documentation - Test User\n").to_stdout
      end
    end

    it "prints no status when commits don't exist" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        result = proc { shell.call %w[--status] }

        expect(&result).to output("All is quiet.\n").to_stdout
      end
    end

    it "creates tag" do
      git_repo_dir.change_dir do
        shell.call %w[--tag 0.0.0]
        expect(tag_details.call("0.0.0")).to match(/Version\s0\.0\.0/)
      end
    end

    it "prints version" do
      result = proc { shell.call %w[--version] }
      expect(&result).to output(/Milestoner\s\d+\.\d+\.\d+/).to_stdout
    end

    it "prints help" do
      result = proc { shell.call %w[--help] }
      expect(&result).to output(/Milestoner.+USAGE.+SECURITY OPTIONS/m).to_stdout
    end

    it "prints usage when no options are given" do
      result = proc { shell.call }
      expect(&result).to output(/Milestoner.+USAGE.+SECURITY OPTIONS.+/m).to_stdout
    end

    it "prints error with invalid option" do
      result = proc { shell.call %w[--bogus] }
      expect(&result).to output(/invalid option.+bogus/).to_stdout
    end
  end
end
