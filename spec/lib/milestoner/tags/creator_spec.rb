# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Tags::Creator do
  include Dry::Monads[:result]

  using Refinements::Pathname
  using Refinements::Struct

  subject(:creator) { described_class.new }

  include_context "with Git repository"
  include_context "with application dependencies"

  let(:tag) { Milestoner::Container[:git].tag_show(version).bind(&:version) }
  let(:version) { "1.2.3" }

  describe "#call" do
    before do
      git_repo_dir.change_dir do
        `(git tag --delete #{version} && git push --delete origin #{version}) 2> /dev/null`
      end
    end

    it "creates tag when success" do
      git_repo_dir.change_dir do
        creator.call version
        expect(tag).to eq("1.2.3")
      end
    end

    it "answers version when success" do
      git_repo_dir.change_dir { expect(creator.call(version)).to eq(Success(version)) }
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
          creator.call version
          expect(tag).to eq("1.2.3")
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
          creator.call version

          expect(tag).to eq("1.2.3")
        end
      end
    end

    it "logs warning when local tag exists" do
      git_repo_dir.change_dir do
        `git tag #{version}`
        creator.call version

        expect(logger.reread).to match(/⚠️.+Local tag exists: 1.2.3. Skipped./)
      end
    end

    it "answers success with version when local tag exists" do
      git_repo_dir.change_dir do
        `git tag #{version}`
        expect(creator.call(version)).to eq(Success(version))
      end
    end

    it "answers failure when commits don't exist" do
      temp_dir.change_dir do
        `git init`

        expect(creator.call(version)).to eq(
          Failure("Your current branch 'main' does not have any commits yet.")
        )
      end
    end
  end
end
