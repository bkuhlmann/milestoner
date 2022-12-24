# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Shell do
  using Refinements::Pathnames
  using Infusible::Stub

  subject(:shell) { described_class.new }

  include_context "with Git repository"
  include_context "with application dependencies"

  before { Milestoner::CLI::Actions::Import.stub configuration:, kernel:, logger: }

  after { Milestoner::CLI::Actions::Import.unstub :configuration, :kernel, :logger }

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
        `git tag --delete 0.0.0 && git push --delete origin 0.0.0`
        shell.call %w[--publish 0.0.0]
      rescue Milestoner::Error
        expect(tag).to eq("0.0.0")
      ensure
        `git tag --delete 0.0.0 && git push --delete origin 0.0.0`
      end
    end

    it "fails to publish when remote repository doesn't exist" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        shell.call %w[--publish 0.0.0]

        expect(logger.reread).to match(/tag exists/i)
      end
    ensure
      `git tag --delete 0.0.0 && git push --delete origin 0.0.0`
    end

    it "prints project status when commits exist" do
      git_repo_dir.change_dir do
        shell.call %w[--status]
        expect(logger.reread).to eq("* Added documentation - Test User\n")
      end
    end

    it "prints no status when commits don't exist" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        shell.call %w[--status]

        expect(logger.reread).to eq("All is quiet.\n")
      end
    end

    it "prints version" do
      shell.call %w[--version]
      expect(logger.reread).to match(/Milestoner\s\d+\.\d+\.\d+/)
    end

    it "prints help" do
      shell.call %w[--help]
      expect(logger.reread).to match(/Milestoner.+USAGE.+/m)
    end

    it "prints usage when no options are given" do
      shell.call
      expect(logger.reread).to match(/Milestoner.+USAGE.+/m)
    end

    it "prints error with invalid option" do
      shell.call %w[--bogus]
      expect(logger.reread).to match(/invalid option.+bogus/)
    end
  end
end
