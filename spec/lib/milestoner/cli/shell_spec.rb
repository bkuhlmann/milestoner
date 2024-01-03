# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Shell do
  using Refinements::Pathname
  using Infusible::Stub

  subject(:shell) { described_class.new }

  include_context "with Git repository"
  include_context "with application dependencies"

  before { Sod::Import.stub kernel:, logger: }

  after { Sod::Import.unstub :kernel, :logger }

  describe "#call" do
    it "prints configuration usage" do
      shell.call %w[config]
      expect(kernel).to have_received(:puts).with(/Manage configuration.+/m)
    end

    it "creates tag when publishing", :aggregate_failures do
      git_repo_dir.change_dir do
        `git fetch --tags && git tag --delete 0.0.0 && git push --delete origin 0.0.0`
        shell.call %w[--publish 0.0.0]

        expect(`git describe --tags --abbrev=0`.chomp).to eq("0.0.0")
      rescue Milestoner::Error
        # For CI since it can't push.
        expect(`git describe --tags --abbrev=0`.chomp).to eq("")
      end
    end

    it "fails to publish when remote repository doesn't exist" do
      git_repo_dir.change_dir do
        `git config --unset remote.origin.url`
        expectation = proc { shell.call %w[--publish 0.0.0] }

        expect(&expectation).to raise_error(Milestoner::Error, /not configured/)
      end
    end

    it "prints project status when commits exist" do
      git_repo_dir.change_dir do
        shell.call %w[--status]
        expect(kernel).to have_received(:puts).with("* Added documentation - Test User")
      end
    end

    it "prints no status when commits don't exist" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        shell.call %w[--status]

        expect(logger.reread).to match(/🟢.+All is quiet./)
      end
    end

    it "prints version" do
      shell.call %w[--version]
      expect(kernel).to have_received(:puts).with(/Milestoner\s\d+\.\d+\.\d+/)
    end

    it "prints help" do
      shell.call %w[--help]
      expect(kernel).to have_received(:puts).with(/Milestoner.+USAGE.+/m)
    end
  end
end
