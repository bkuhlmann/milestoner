require "spec_helper"

describe Milestoner::Release, :temp_dir do
  let(:repo_dir) { File.join temp_dir, "tester" }
  let(:version) { "0.1.0" }
  let(:tag_details) { Open3.capture2(%(git show --stat --pretty=format:"%b" v#{version})).first }
  subject { described_class.new version }

  before do
    FileUtils.mkdir repo_dir
    Dir.chdir(repo_dir) do
      FileUtils.touch "one.txt"
      FileUtils.touch "two.txt"
      FileUtils.touch "three.txt"
      `git init`
      `git add --all .`
      `git commit --all --message "Added dummy files."`
    end
  end

  describe ".commit_prefixes" do
    it "answers git commit prefixes in specific order" do
      expect(described_class.commit_prefixes).to eq(%w(Fixed Added Updated Removed Refactored))
    end
  end

  describe ".commit_prefix_regex" do
    it "answers regex for matching specific git commit prefixes" do
      expect(described_class.commit_prefix_regex).to eq(/\A(Fixed|Added|Updated|Removed|Refactored)/)
    end
  end

  describe ".version_regex" do
    it "answers regex for valid version formats" do
      expect(described_class.version_regex).to eq(/\A\d{1}\.\d{1}\.\d{1}\z/)
    end
  end

  describe "#initialize" do
    it "answers initialized version" do
      expect(subject.version).to eq("0.1.0")
    end

    it "raises version error when version is invalid" do
      message = "Invalid version: bogus. Use: <major>.<minor>.<maintenance>."
      result = -> { described_class.new "bogus" }

      expect(&result).to raise_error(Milestoner::VersionError, message)
    end

    it "raises version error when version valid but contains extra characters" do
      message = "Invalid version: what-v0.1.0-bogus. Use: <major>.<minor>.<maintenance>."
      result = -> { described_class.new "what-v0.1.0-bogus" }

      expect(&result).to raise_error(Milestoner::VersionError, message)
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
  end

  describe "#commits" do
    context "when tagged" do
      it "answers commits since last tag" do
        Dir.chdir(repo_dir) do
          `git tag v0.0.0`
          `git rm one.txt`
          `git commit --all --message "Removed one.txt."`

          expect(subject.commits).to eq("Removed one.txt.\n")
        end
      end
    end

    context "when not tagged" do
      it "answers all known commits" do
        Dir.chdir(repo_dir) do
          expect(subject.commits).to eq("Added dummy files.\n")
        end
      end
    end
  end

  describe "#commits_sorted" do
    let :unsorted_commits do
      [
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
        "This is not a good commit message.",
        "Refactored authorization to base controller.",
        "Updated and restored original deploy functionality.",
        "Fixed issues with current directory not being cleaned after build."
      ].join("\n")
    end
    before { allow(subject).to receive(:commits).and_return(unsorted_commits) }

    it "answers sorted commits" do
      expect(subject.commits_sorted).to eq([
        "Fixed issues with current directory not being cleaned after build.",
        "Fixed README typos.",
        "Added spec helper methods.",
        "Added upgrade notes to README.",
        "Updated version release notes.",
        "Updated and restored original deploy functionality.",
        "Updated gem dependencies.",
        "Removed unused stylesheets.",
        "Removed unnecessary spacing.",
        "Refactored common functionality to module.",
        "Refactored strings to use double quotes instead of single quotes.",
        "Refactored authorization to base controller.",
        "Another bogus commit message.",
        "Bogus commit message.",
        "This is not a good commit message."
      ])
    end
  end

  describe "#tag" do
    it "tags repository" do
      Dir.chdir(repo_dir) do
        subject.tag
        expect(tag_details).to match(/tag\sv0\.1\.0/)
      end
    end

    it "uses tag message" do
      Dir.chdir(repo_dir) do
        subject.tag
        expect(tag_details).to match(/Version\s0\.1\.0\./)
      end
    end

    it "uses tag message with commits since last tag" do
      Dir.chdir(repo_dir) do
        `git rm one.txt`
        `git commit --all --message "Removed one."`

        `printf "Test" > two.txt`
        `git commit --all --message "Updated two."`

        `printf "Three." > three.txt`
        `git commit --all --message "Fixed three."`

        subject.tag

        expect(tag_details).to match(/
          Version\s0\.1\.0\.\n\n
          \-\sFixed\sthree\.\n
          \-\sAdded\sdummy\sfiles\.\n
          \-\sUpdated\stwo\.\n
          \-\sRemoved\sone\.\n\n\n
        /x)
      end
    end

    context "when not signed" do
      it "does not sign tag" do
        Dir.chdir(repo_dir) do
          subject.tag
          expect(tag_details).to_not match(/\-{5}BEGIN\sPGP\sSIGNATURE\-{5}/)
        end
      end
    end

    context "when signed" do
      let(:gpg_dir) { File.join temp_dir, ".gnupg" }
      let(:gpg_email) { "tester@example.com" }
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
            gpg << "Testy Tester\n"

            gpg.wait_for :output, /Email address/i
            gpg << "#{gpg_email}\n"

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

            key = `gpg --list-keys #{gpg_email} | grep pub | awk '{print $2}' | cut -d'/' -f 2`.chomp
            `git config --local user.signingkey #{key}`
          end
        end
      end

      it "signs tag" do
        ClimateControl.modify GNUPGHOME: gpg_dir do
          Dir.chdir(repo_dir) do
            subject.tag sign: true
            expect(tag_details).to match(/\-{5}BEGIN\sPGP\sSIGNATURE\-{5}/)
          end
        end
      end
    end
  end
end
