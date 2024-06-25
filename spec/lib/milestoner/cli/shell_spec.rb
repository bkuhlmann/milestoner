# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Milestoner::CLI::Shell do
  using Refinements::Pathname
  using Refinements::String
  using Refinements::StringIO
  using Versionaire::Cast

  subject(:shell) { described_class.new }

  include_context "with Git repository"
  include_context "with application dependencies"

  let(:kernel) { class_spy Kernel }

  before { Sod::Container.stub! logger:, io: }

  after { Sod::Container.restore }

  describe "#call" do
    it "prints configuration usage" do
      shell.call %w[config]
      expect(io.reread).to match(/Manage configuration.+/m)
    end

    it "prints cache usage" do
      shell.call %w[cache]
      expect(io.reread).to match(/Manage cache.+/m)
    end

    it "prints build usage" do
      shell.call %w[build]
      expect(io.reread).to match(/Build milestone.+/m)
    end

    it "prints next version" do
      git_repo_dir.change_dir do
        shell.call %w[--next]
        expect(io.reread).to eq("1.2.3\n")
      end
    end

    it "creates tag when publishing", :aggregate_failures do
      git_repo_dir.change_dir do
        `git fetch --tags && git tag --delete 0.0.0 && git push --delete origin 0.0.0`
        shell.call %w[--publish 0.0.0]

        if ENV.fetch("CI", false) == "true"
          # CI can't push tags.
          expect(`git describe --tags --abbrev=0`.chomp).to eq("")
        else
          expect(`git describe --tags --abbrev=0`.chomp).to eq("0.0.0")
        end
      end
    end

    it "fails to publish when remote repository doesn't exist" do
      git_repo_dir.change_dir do
        `git config --unset remote.origin.url`
        shell.call %w[--publish 0.0.0]

        expect(logger.reread).to match(/🛑.+Remote repository not configured\./)
      end
    end

    it "prints version" do
      shell.call %w[--version]
      expect(io.reread).to match(/Milestoner\s\d+\.\d+\.\d+/)
    end

    it "prints help" do
      shell.call %w[--help]
      expect(io.reread).to match(/Milestoner.+USAGE.+/m)
    end
  end
end
