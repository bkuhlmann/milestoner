# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Tags::Creator do
  using Refinements::Pathnames
  using Refinements::Structs
  using Versionaire::Cast

  subject(:tagger) { described_class.new }

  include_context "with Git repository"
  include_context "with application dependencies"

  let(:test_configuration) { configuration.merge version: Version("1.2.3") }

  let :tag_details do
    ->(version) { Open3.capture2(%(git show --stat --pretty=format:"%b" #{version})).first }
  end

  describe "#call" do
    before do
      git_repo_dir.change_dir { `git tag --delete 1.2.3 && git push --delete origin 1.2.3` }
    end

    it "creates tag message" do
      git_repo_dir.change_dir do
        tagger.call test_configuration
        expect(tag_details.call("1.2.3")).to match(/Version\s1\.2\.3/)
      end
    end

    context "with commits since last tag" do
      let :pattern do
        /
          Version\s1\.2\.3\n\n
          \*\sFixed\sREADME\s-\sTest\sUser\n
          \*\sAdded\sdocumentation\s-\sTest\sUser\n
          \*\sUpdated\sREADME\s-\sTest\sUser\n
          \*\sRemoved\sREADME\s-\sTest\sUser\n\n\n\n
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
          tagger.call test_configuration
          expect(tag_details.call("1.2.3")).to match(pattern)
        end
      end
    end

    context "with backticks in commits" do
      let :pattern do
        /
          Version\s1\.2\.3\n\n
          \*\sAdded\sdocumentation\s-\sTest\sUser\n
          \*\sUpdated\sREADME\swith\s`bogus\scommand`\sin\smessage\s-\sTest\sUser\n\n\n\n
        /x
      end

      it "does not execute backticks" do
        git_repo_dir.change_dir do
          `printf "Test" > README.md`
          %x(git commit --all --message 'Updated README with \`bogus command\` in message')
          tagger.call test_configuration

          expect(tag_details.call("1.2.3")).to match(pattern)
        end
      end
    end

    it "logs tag exists when previously created" do
      git_repo_dir.change_dir do
        `git tag #{test_configuration.version}`
        tagger.call test_configuration

        expect(logger.reread).to eq("Local tag exists: 1.2.3. Skipped.\n")
      end
    end

    it "answers false when tag is previously created" do
      git_repo_dir.change_dir do
        `git tag #{test_configuration.version}`
        expect(tagger.call(test_configuration)).to be(false)
      end
    end

    it "logs tag created when tag doesn't exist and is successfully created" do
      git_repo_dir.change_dir do
        tagger.call test_configuration
        expect(logger.reread).to eq("Local tag created: 1.2.3.\n")
      end
    end

    it "answers true when tag doesn't exist and is successfully created" do
      git_repo_dir.change_dir { expect(tagger.call(test_configuration)).to be(true) }
    end

    it "fails with no Git commits" do
      temp_dir.change_dir do
        `git init`
        result = proc { tagger.call test_configuration }

        expect(&result).to raise_error(Milestoner::Error, "Unable to tag without commits.")
      end
    end

    it "fails with invalid version" do
      result = -> { tagger.call test_configuration.merge(version: "bogus") }
      expect(&result).to raise_error(Milestoner::Error)
    end
  end
end
