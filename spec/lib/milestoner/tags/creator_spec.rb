# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Tags::Creator do
  using Refinements::Pathnames
  using Refinements::Structs
  using Versionaire::Cast

  subject(:tagger) { described_class.new }

  include_context "with Git repository"
  include_context "with application container"

  let(:configuration) { application_configuration.merge version: Version("0.0.0") }

  let :tag_details do
    ->(version) { Open3.capture2(%(git show --stat --pretty=format:"%b" #{version})).first }
  end

  describe "#call" do
    it "creates tag message" do
      git_repo_dir.change_dir do
        tagger.call configuration
        expect(tag_details.call("0.0.0")).to match(/Version\s0\.0\.0/)
      end
    end

    context "with commits since last tag" do
      let :pattern do
        /
          Version\s0\.0\.0\n\n
          -\sFixed\sREADME\s-\sTest\sUser\n
          -\sAdded\sdocumentation\s-\sTest\sUser\n
          -\sUpdated\sREADME\s-\sTest\sUser\n
          -\sRemoved\sREADME\s-\sTest\sUser\n\n\n\n
        /x
      end

      before do
        git_repo_dir.change_dir do
          `rm -f README.md`
          `git commit --all --message "Removed README"`

          `printf "Update." > README.md`
          `git add . && git commit --all --message "Updated README"`

          `printf "Fix." > README.md`
          `git commit --all --message "Fixed README"`
        end
      end

      it "creates tag message with commits since last tag" do
        git_repo_dir.change_dir do
          tagger.call configuration
          expect(tag_details.call("0.0.0")).to match(pattern)
        end
      end
    end

    context "with backticks in commits" do
      let :pattern do
        /
          Version\s0\.0\.0\n\n
          -\sAdded\sdocumentation\s-\sTest\sUser\n
          -\sUpdated\sREADME\swith\s`bogus\scommand`\sin\smessage\s-\sTest\sUser\n\n\n\n
        /x
      end

      it "does not execute backticks" do
        git_repo_dir.change_dir do
          `printf "Test" > README.md`
          %x(git commit --all --message 'Updated README with \`bogus command\` in message')
          tagger.call configuration

          expect(tag_details.call("0.0.0")).to match(pattern)
        end
      end
    end

    context "when not signed" do
      it "does not sign tag" do
        git_repo_dir.change_dir do
          tagger.call configuration
          expect(tag_details.call("0.0.0")).not_to match(/-{5}BEGIN\sPGP\sSIGNATURE-{5}/)
        end
      end
    end

    context "when signed" do
      let(:gpg_dir) { temp_dir.join ".gnupg" }
      let(:gpg_script) { Bundler.root.join "spec/support/fixtures/gpg_script" }
      let(:gpg_key) { `gpg --list-secret-keys --keyid-format SHORT | grep sec`[14..21] }

      it "signs tag" do
        skip "Required manual input from command line."

        ClimateControl.modify GNUPGHOME: gpg_dir.to_s do
          git_repo_dir.change_dir do
            gpg_dir.make_dir.chmod 0o700
            `gpg --batch --generate-key --quiet --gen-key #{gpg_script}`
            `git config --local user.signingkey #{gpg_key}`
            tagger.call configuration.merge(sign: true)

            expect(tag_details.call("0.0.0")).to match(/-{5}BEGIN\sPGP\sSIGNATURE-{5}/)
          end
        end
      end
    end

    it "logs tag exists when previously created" do
      git_repo_dir.change_dir do
        `git tag #{configuration.version}`
        result = proc { tagger.call configuration }

        expect(&result).to output("Local tag exists: 0.0.0. Skipped.\n").to_stdout
      end
    end

    it "answers false when tag is previously created" do
      git_repo_dir.change_dir do
        `git tag #{configuration.version}`
        expect(tagger.call(configuration)).to eq(false)
      end
    end

    it "logs tag created when tag doesn't exist and is successfully created" do
      git_repo_dir.change_dir do
        result = proc { tagger.call configuration }
        expect(&result).to output("Local tag created: 0.0.0.\n").to_stdout
      end
    end

    it "answers true when tag doesn't exist and is successfully created" do
      git_repo_dir.change_dir { expect(tagger.call(configuration)).to eq(true) }
    end

    context "when GPG program is missing" do
      it "signs tag" do
        git_repo_dir.change_dir do
          `git config --local gpg.program /dev/null`
          result = -> { tagger.call configuration.merge(sign: true) }

          expect(&result).to raise_error(Milestoner::Error, "Unable to create tag: 0.0.0.")
        end
      end
    end

    it "fails with no Git commits" do
      temp_dir.change_dir do
        `git init`
        result = proc { tagger.call configuration }

        expect(&result).to raise_error(Milestoner::Error, "Unable to tag without commits.")
      end
    end

    it "fails with invalid version" do
      result = -> { tagger.call configuration.merge(version: "bogus") }
      expect(&result).to raise_error(Milestoner::Error)
    end
  end
end
