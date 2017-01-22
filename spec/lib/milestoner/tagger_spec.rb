# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Tagger, :temp_dir, :git_repo do
  let(:version) { Versionaire::Version.new minor: 1 }
  let(:prefixes) { %w[Fixed Added Updated Removed Refactored] }

  let :tag_details do
    ->(version) { Open3.capture2(%(git show --stat --pretty=format:"%b" v#{version})).first }
  end

  subject { described_class.new version, commit_prefixes: prefixes }

  describe "#initialize" do
    it "answers default version" do
      expect(subject.version).to eq(version)
    end

    it "answers default commit prefixes" do
      expect(subject.commit_prefixes).to eq(prefixes)
    end

    it "fails with invalid version" do
      result = -> { described_class.new "bogus" }
      expect(&result).to raise_error(Versionaire::Errors::Conversion)
    end
  end

  describe "#commit_prefix_regex" do
    context "with prefixes" do
      it "answers regex for matching specific git commit prefixes" do
        expect(subject.commit_prefix_regex).to eq(/Fixed|Added|Updated|Removed|Refactored/)
      end
    end

    context "without prefixes" do
      let(:prefixes) { [] }

      it "answers regex for matching specific git commit prefixes" do
        expect(subject.commit_prefix_regex).to eq(//)
      end
    end
  end

  describe "#tagged?" do
    it "answers true when tags exist" do
      Dir.chdir(git_repo_dir) do
        `git tag v0.0.0`
        expect(subject.tagged?).to eq(true)
      end
    end

    it "answers false when tags don't exist" do
      Dir.chdir(git_repo_dir) do
        expect(subject.tagged?).to eq(false)
      end
    end

    it "fails with Git error when not a Git repository" do
      Dir.chdir temp_dir do
        result = -> { subject.tagged? }
        expect(&result).to raise_error(Milestoner::Errors::Git)
      end
    end
  end

  describe "#duplicate?" do
    it "answers true when tag is identical" do
      Dir.chdir(git_repo_dir) do
        subject.create
        expect(subject.duplicate?).to eq(true)
      end
    end

    it "answers false when tag doesn't exist" do
      Dir.chdir(git_repo_dir) do
        expect(subject.duplicate?).to eq(false)
      end
    end

    it "fails with Git error when not a Git repository" do
      Dir.chdir temp_dir do
        result = -> { subject.duplicate? }
        expect(&result).to raise_error(Milestoner::Errors::Git)
      end
    end
  end

  describe "#commits" do
    context "when tagged" do
      it "answers commits since last tag" do
        Dir.chdir(git_repo_dir) do
          `git tag v0.0.0`
          `git rm one.txt`
          `git commit --all --message "Removed one.txt."`

          expect(subject.commits).to contain_exactly("Removed one.txt.")
        end
      end
    end

    context "when not tagged" do
      it "answers all known commits" do
        Dir.chdir(git_repo_dir) do
          expect(subject.commits).to contain_exactly("Added dummy files.")
        end
      end
    end

    context "with prefixed commits" do
      let :raw_commits do
        [
          "This is not a good commit message.",
          "Refactored strings to use double quotes instead of single quotes.",
          "Updated gem dependencies.",
          "Fixed README typos.",
          "Updated version release notes.",
          "Removed unused stylesheets.",
          "Bogus commit message.",
          "Another bogus commit message.",
          "Added upgrade notes to README.",
          "Refactored common functionality to module.",
          "Removed unnecessary spacing.",
          "Added spec helper methods.",
          "Refactored authorization to base controller.",
          "Updated and restored original deploy functionality.",
          "Fixed issues with current directory not being cleaned after build."
        ]
      end
      before { allow(subject).to receive(:raw_commits).and_return(raw_commits) }

      it "answers commits grouped by prefix and alpha-sorted per group" do
        expect(subject.commits).to eq(
          [
            "Fixed README typos.",
            "Fixed issues with current directory not being cleaned after build.",
            "Added spec helper methods.",
            "Added upgrade notes to README.",
            "Updated and restored original deploy functionality.",
            "Updated gem dependencies.",
            "Updated version release notes.",
            "Removed unnecessary spacing.",
            "Removed unused stylesheets.",
            "Refactored authorization to base controller.",
            "Refactored common functionality to module.",
            "Refactored strings to use double quotes instead of single quotes.",
            "Another bogus commit message.",
            "Bogus commit message.",
            "This is not a good commit message."
          ]
        )
      end
    end

    context "with prefixed commits using special characters" do
      let(:prefixes) { ["[one]", "$\#{@", "with spaces"] }
      let(:raw_commits) { ["Apple", "with spaces yes", "$\#{@ junk", "[one] more"] }
      before { allow(subject).to receive(:raw_commits).and_return(raw_commits) }

      it "answers commits grouped by prefix and alpha-sorted per group" do
        expect(subject.commits).to eq(["[one] more", "$\#{@ junk", "with spaces yes", "Apple"])
      end
    end

    context "without prefixed commits" do
      let(:prefixes) { [] }
      let(:raw_commits) { %w[One Two Three] }
      before { allow(subject).to receive(:raw_commits).and_return(raw_commits) }

      it "answers alphabetically sorted commits" do
        expect(subject.commits).to eq(%w[One Three Two])
      end
    end

    context "with duplicate commit messages" do
      let :raw_commits do
        [
          "Added spec helper methods.",
          "Updated gem dependencies.",
          "Updated gem dependencies.",
          "Updated gem dependencies."
        ]
      end
      before { allow(subject).to receive(:raw_commits).and_return(raw_commits) }

      it "answers commits with duplicates removed" do
        expect(subject.commits).to eq(
          [
            "Added spec helper methods.",
            "Updated gem dependencies."
          ]
        )
      end
    end

    context "with commit messages that include [ci skip] strings" do
      let :raw_commits do
        [
          "Fixed failing [ci skip] CI builds.",
          "Added spec helper methods. [ci skip]",
          "[ci skip] Updated gem dependencies."
        ]
      end
      before { allow(subject).to receive(:raw_commits).and_return(raw_commits) }

      it "answers commits messages with [ci skip] strings removed" do
        expect(subject.commits).to eq(
          [
            "Fixed failing CI builds.",
            "Added spec helper methods.",
            "Updated gem dependencies."
          ]
        )
      end
    end

    it "fails with Git error when not a Git repository" do
      Dir.chdir temp_dir do
        result = -> { subject.commits }
        expect(&result).to raise_error(Milestoner::Errors::Git)
      end
    end
  end

  describe "#commit_list" do
    let(:raw_commits) { %w[One Two Three] }
    before { allow(subject).to receive(:raw_commits).and_return(raw_commits) }

    it "answers a formatted list of commit messages" do
      expect(subject.commit_list).to contain_exactly("- One", "- Two", "- Three")
    end
  end

  describe "#create" do
    context "with initialized version" do
      it "creates new tag" do
        Dir.chdir(git_repo_dir) do
          subject.create
          expect(tag_details.call("0.1.0")).to match(/tag\sv0\.1\.0/)
        end
      end
    end

    context "with custom version" do
      it "creates new tag" do
        Dir.chdir(git_repo_dir) do
          subject.create "0.2.0"
          expect(tag_details.call("0.2.0")).to match(/tag\sv0\.2\.0/)
        end
      end
    end

    it "uses tag message" do
      Dir.chdir(git_repo_dir) do
        subject.create
        expect(tag_details.call("0.1.0")).to match(/Version\s0\.1\.0\./)
      end
    end

    it "uses tag message and includes commits since last tag" do
      Dir.chdir(git_repo_dir) do
        `git rm one.txt`
        `git commit --all --message "Removed one."`

        `printf "Test" > two.txt`
        `git commit --all --message "Updated two."`

        `printf "Three." > three.txt`
        `git commit --all --message "Fixed three."`

        subject.create

        expect(tag_details.call("0.1.0")).to match(/
          Version\s0\.1\.0\.\n\n
          \-\sFixed\sthree\.\n
          \-\sAdded\sdummy\sfiles\.\n
          \-\sUpdated\stwo\.\n
          \-\sRemoved\sone\.\n\n\n\n
        /x)
      end
    end

    it "does not execute backticks in commit subject when adding tag message" do
      Dir.chdir(git_repo_dir) do
        `printf "Test" > two.txt`
        %x(git commit --all --message 'Updated two.txt with \`bogus command\` in message.')

        subject.create

        expect(tag_details.call("0.1.0")).to match(/
          Version\s0\.1\.0\.\n\n
          \-\sAdded\sdummy\sfiles\.\n
          \-\sUpdated\stwo\.txt\swith\s\`bogus\scommand\`\sin\smessage\.\n\n\n\n
        /x)
      end
    end

    context "when not signed" do
      it "does not sign tag" do
        Dir.chdir(git_repo_dir) do
          subject.create
          expect(tag_details.call("0.1.0")).to_not match(/\-{5}BEGIN\sPGP\sSIGNATURE\-{5}/)
        end
      end
    end

    context "when signed" do
      # FIX: Research how to generate sufficient entropy for signed keys on a CI machine.
      unless ENV["CI"]
        let(:gpg_dir) { File.join temp_dir, ".gnupg" }
        let(:gpg_script) { File.join temp_dir, "..", "..", "spec", "support", "gpg_script" }
        let(:git_email) { "tester@example.com" }
        let :gpg_key do
          `gpg --list-keys #{git_email} | grep pub | awk '{print $2}' | cut -d'/' -f 2`.chomp
        end

        it "signs tag" do
          ClimateControl.modify GNUPGHOME: gpg_dir do
            Dir.chdir(git_repo_dir) do
              FileUtils.mkdir gpg_dir
              FileUtils.chmod 0o700, gpg_dir
              `gpg --batch --quiet --gen-key #{gpg_script}`
              `git config --local user.signingkey #{gpg_key}`
              subject.create sign: true

              expect(tag_details.call("0.1.0")).to match(/\-{5}BEGIN\sPGP\sSIGNATURE\-{5}/)
            end
          end
        end
      end
    end

    context "when duplicate tag exists" do
      it "fails with duplicate tag error" do
        Dir.chdir(git_repo_dir) do
          subject.create
          result = -> { subject.create }

          expect(&result).to raise_error(
            Milestoner::Errors::DuplicateTag,
            "Duplicate tag exists: v0.1.0."
          )
        end
      end
    end

    context "when GPG program is missing" do
      it "signs tag" do
        Dir.chdir(git_repo_dir) do
          `git config --local gpg.program /dev/null`
          result = -> { subject.create sign: true }

          expect(&result).to raise_error(
            Milestoner::Errors::Git,
            "Unable to create tag: v0.1.0."
          )
        end
      end
    end

    it "fails with invalid Git repository" do
      Dir.chdir temp_dir do
        result = -> { subject.create }
        expect(&result).to raise_error(Milestoner::Errors::Git, "Invalid Git repository.")
      end
    end

    it "fails with no Git commits" do
      Dir.chdir temp_dir do
        `git init`
        result = -> { subject.create }

        expect(&result).to raise_error(Milestoner::Errors::Git, "Unable to tag without commits.")
      end
    end

    it "fails with invalid version" do
      result = -> { subject.create "bogus" }
      expect(&result).to raise_error(Versionaire::Errors::Conversion)
    end
  end

  describe "#delete" do
    context "with initialized version" do
      it "does not update version number" do
        Dir.chdir(git_repo_dir) do
          subject.delete
          expect(subject.version).to eq(version)
        end
      end

      it "deletes existing tag" do
        Dir.chdir(git_repo_dir) do
          subject.create
          subject.delete
          expect(`git tag`).to eq("")
        end
      end

      it "only deletes duplicate tag" do
        Dir.chdir(git_repo_dir) do
          _, stderr = subject.delete
          expect(stderr).to eq(nil)
        end
      end

      it "fails when not a Git repository" do
        Dir.chdir temp_dir do
          result = -> { subject.delete }
          expect(&result).to raise_error(Milestoner::Errors::Git, "Invalid Git repository.")
        end
      end
    end

    context "with custom version" do
      let(:version) { Versionaire::Version "1.1.1" }
      subject { described_class.new }

      it "updates version number" do
        Dir.chdir(git_repo_dir) do
          subject.delete version
          expect(subject.version).to eq(version)
        end
      end

      it "deletes existing tag" do
        Dir.chdir(git_repo_dir) do
          subject.create version
          subject.delete version
          expect(`git tag`).to eq("")
        end
      end

      it "only deletes duplicate tag" do
        Dir.chdir(git_repo_dir) do
          _, stderr = subject.delete version
          expect(stderr).to eq(nil)
        end
      end

      it "fails when not a Git repository" do
        Dir.chdir temp_dir do
          result = -> { subject.delete version }
          expect(&result).to raise_error(Milestoner::Errors::Git, "Invalid Git repository.")
        end
      end
    end

    context "with invalid version" do
      it "raises Versionaire error" do
        result = -> { subject.delete "bogus" }
        expect(&result).to raise_error(Versionaire::Errors::Conversion)
      end
    end
  end
end
