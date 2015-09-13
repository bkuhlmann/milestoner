require "spec_helper"

describe Milestoner::Tagger, :temp_dir do
  let(:repo_dir) { File.join temp_dir, "tester" }
  let(:version) { "0.1.0" }
  let(:prefixes) { %w(Fixed Added Updated Removed Refactored) }
  let(:git_name) { "Testy Tester" }
  let(:git_email) { "tester@example.com" }
  let(:tag_details) { ->(version) { Open3.capture2(%(git show --stat --pretty=format:"%b" v#{version})).first } }
  subject { described_class.new version, commit_prefixes: prefixes }

  before do
    FileUtils.mkdir repo_dir
    Dir.chdir(repo_dir) do
      FileUtils.touch "one.txt"
      FileUtils.touch "two.txt"
      FileUtils.touch "three.txt"
      `git init`
      `git config --local user.name "#{git_name}"`
      `git config --local user.email "#{git_email}"`
      `git add --all .`
      `git commit --all --message "Added dummy files."`
    end
  end

  describe ".version_regex" do
    it "answers regex for valid version formats" do
      expect(described_class.version_regex).to eq(/\A\d{1}\.\d{1}\.\d{1}\z/)
    end
  end

  describe "#initialize" do
    it "answers initialized version number" do
      expect(subject.version_number).to eq("0.1.0")
    end

    it "answers initialized commit prefixes" do
      expect(subject.commit_prefixes).to eq(prefixes)
    end
  end

  describe "#version_label" do
    it "answers version label" do
      expect(subject.version_label).to eq("v0.1.0")
    end
  end

  describe "#version_message" do
    it "answers version message" do
      expect(subject.version_message).to eq("Version 0.1.0.")
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
      Dir.chdir(repo_dir) do
        `git tag v0.0.0`
        expect(subject.tagged?).to eq(true)
      end
    end

    it "answers false when tags don't exist" do
      Dir.chdir(repo_dir) do
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
      Dir.chdir(repo_dir) do
        subject.create
        expect(subject.duplicate?).to eq(true)
      end
    end

    it "answers false when tag doesn't exist" do
      Dir.chdir(repo_dir) do
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
        Dir.chdir(repo_dir) do
          `git tag v0.0.0`
          `git rm one.txt`
          `git commit --all --message "Removed one.txt."`

          expect(subject.commits).to contain_exactly("Removed one.txt.")
        end
      end
    end

    context "when not tagged" do
      it "answers all known commits" do
        Dir.chdir(repo_dir) do
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
        expect(subject.commits).to eq([
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
        ])
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
      let(:raw_commits) { %w(One Two Three) }
      before { allow(subject).to receive(:raw_commits).and_return(raw_commits) }

      it "answers alphabetically sorted commits" do
        expect(subject.commits).to eq(%w(One Three Two))
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
        expect(subject.commits).to eq([
          "Added spec helper methods.",
          "Updated gem dependencies."
        ])
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
        expect(subject.commits).to eq([
          "Fixed failing CI builds.",
          "Added spec helper methods.",
          "Updated gem dependencies."
        ])
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
    let(:raw_commits) { %w(One Two Three) }
    before { allow(subject).to receive(:raw_commits).and_return(raw_commits) }

    it "answers a formatted list of commit messages" do
      expect(subject.commit_list).to contain_exactly("- One", "- Two", "- Three")
    end
  end

  describe "#create" do
    it "creates, with initialized version, new tag for repository" do
      Dir.chdir(repo_dir) do
        subject.create
        expect(tag_details.call("0.1.0")).to match(/tag\sv0\.1\.0/)
      end
    end

    it "creates, with given version, new tag for repository" do
      Dir.chdir(repo_dir) do
        subject.create "0.2.0"
        expect(tag_details.call("0.2.0")).to match(/tag\sv0\.2\.0/)
      end
    end

    it "uses tag message" do
      Dir.chdir(repo_dir) do
        subject.create
        expect(tag_details.call("0.1.0")).to match(/Version\s0\.1\.0\./)
      end
    end

    it "uses tag message and includes commits since last tag" do
      Dir.chdir(repo_dir) do
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
          \-\sRemoved\sone\.\n\n\n
        /x)
      end
    end

    it "does not execute backticks in commit subject when adding tag message" do
      Dir.chdir(repo_dir) do
        `printf "Test" > two.txt`
        %x(git commit --all --message 'Updated two.txt with \`bogus command\` in message.')

        subject.create

        expect(tag_details.call("0.1.0")).to match(/
          Version\s0\.1\.0\.\n\n
          \-\sAdded\sdummy\sfiles\.\n
          \-\sUpdated\stwo\.txt\swith\s\`bogus\scommand\`\sin\smessage\.\n\n\n
        /x)
      end
    end

    context "when not signed" do
      it "does not sign tag" do
        Dir.chdir(repo_dir) do
          subject.create
          expect(tag_details.call("0.1.0")).to_not match(/\-{5}BEGIN\sPGP\sSIGNATURE\-{5}/)
        end
      end
    end

    context "when signed" do
      let(:gpg_dir) { File.join temp_dir, ".gnupg" }
      let(:git_email) { "tester@example.com" }
      let(:gpg_key) { `gpg --list-keys #{git_email} | grep pub | awk '{print $2}' | cut -d'/' -f 2`.chomp }
      let(:gpg_passphrase) { "testonly" }
      before do
        FileUtils.mkdir gpg_dir

        ClimateControl.modify GNUPGHOME: gpg_dir do
          Dir.chdir(repo_dir) do
            gpg = Greenletters::Process.new "gpg --gen-key", transcript: $stdout

            gpg.start!

            gpg.wait_for :output, /Please select what kind of key you want/i
            gpg << "1\n"

            gpg.wait_for :output, /RSA keys may be between 1024 and 4096 bits long/i
            gpg << "1024\n"

            gpg.wait_for :output, /Please specify how long the key should be valid/i
            gpg << "0\n"

            gpg.wait_for :output, /Is this correct/i
            gpg << "y\n"

            gpg.wait_for :output, /Real name/i
            gpg << "#{git_name}\n"

            gpg.wait_for :output, /Email address/i
            gpg << "#{git_email}\n"

            gpg.wait_for :output, /Comment/i
            gpg << "Test\n"

            gpg.wait_for :output, /Change.+/i
            gpg << "O\n"

            gpg.wait_for :output, /Enter passphrase/i
            gpg << "#{gpg_passphrase}\n"

            gpg.wait_for :output, /Repeat passphrase/i
            gpg << "#{gpg_passphrase}\n"

            gpg.wait_for :output, /We need to generate a lot of random bytes/i
            gpg.wait_for :output, /public and secret key created and signed/i

            File.open(File.join(gpg_dir, "gpg.conf"), "a") { |file| file.write "passphrase #{gpg_passphrase}\n" }

            `git config --local user.signingkey #{gpg_key}`
          end
        end
      end

      it "signs tag" do
        ClimateControl.modify GNUPGHOME: gpg_dir do
          Dir.chdir(repo_dir) do
            subject.create sign: true
            expect(tag_details.call("0.1.0")).to match(/\-{5}BEGIN\sPGP\sSIGNATURE\-{5}/)
          end
        end
      end
    end

    context "when duplicate tag exists" do
      it "fails with duplicate tag error" do
        Dir.chdir(repo_dir) do
          subject.create
          result = -> { subject.create }

          expect(&result).to raise_error(Milestoner::Errors::DuplicateTag, "Duplicate tag exists: v0.1.0.")
        end
      end
    end

    it "fails with Git error when not a Git repository" do
      Dir.chdir temp_dir do
        result = -> { subject.create }
        expect(&result).to raise_error(Milestoner::Errors::Git)
      end
    end

    it "fails with version error when initialized version is invalid" do
      message = "Invalid version: bogus. Use: <major>.<minor>.<maintenance>."
      subject = described_class.new "bogus"
      result = -> { subject.create }

      expect(&result).to raise_error(Milestoner::Errors::Version, message)
    end

    it "fails with version error when creating with invalid version" do
      message = "Invalid version: bogus. Use: <major>.<minor>.<maintenance>."
      result = -> { subject.create "bogus" }

      expect(&result).to raise_error(Milestoner::Errors::Version, message)
    end
  end

  describe "#destroy" do
    it "destroys existing tag" do
      Dir.chdir(repo_dir) do
        subject.create
        subject.destroy
        expect(`git tag`).to eq("")
      end
    end

    it "fails with Git error when not a Git repository" do
      Dir.chdir temp_dir do
        result = -> { subject.destroy }
        expect(&result).to raise_error(Milestoner::Errors::Git)
      end
    end
  end
end
