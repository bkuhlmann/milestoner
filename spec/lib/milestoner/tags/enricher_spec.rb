# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Tags::Enricher do
  include Dry::Monads[:result]

  using Refinements::Pathname
  using Versionaire::Cast

  subject(:tagger) { described_class.new }

  include_context "with application dependencies"
  include_context "with Git repository"

  describe "#call" do
    it "answers default version for commits with no tag" do
      git_repo_dir.change_dir do
        expect(tagger.call).to match(
          Success(
            array_including(
              have_attributes(
                author: Milestoner::Models::User.new,
                commits: [have_attributes(subject: "Added documentation")],
                version: Version("1.2.3")
              )
            )
          )
        )
      end
    end

    it "answers projected milestone when tag exists" do
      git_repo_dir.change_dir do
        `git tag 0.0.0 --message 0.0.0`
        expect(tagger.call.success.map(&:version)).to eq([Version("1.2.3")])
      end
    end

    it "answers milestone with empty commits when tag exists with and no new commits" do
      git_repo_dir.change_dir do
        `git tag 0.0.0 --message 0.0.0`

        expect(tagger.call).to eq(
          Success(
            [
              Milestoner::Models::Tag[
                author: Milestoner::Models::User.new,
                commits: [],
                committed_at: settings.loaded_at,
                sha: nil,
                signature: nil,
                version: Version("1.2.3")
              ]
            ]
          )
        )
      end
    end

    it "answers failure when tail is tag" do
      settings.build_tail = "tag"

      git_repo_dir.change_dir do
        `touch a.txt && git add --all && git commit --message "Added A"`
        `git tag 0.0.1 --message 0.0.1`

        expect(tagger.call.success.first).to have_attributes(
          author: Milestoner::Models::User.new,
          commits: kind_of(Array),
          committed_at: kind_of(Time),
          sha: kind_of(String),
          signature: "",
          version: Version("0.0.1")
        )
      end
    end

    it "answers empty tag no tags or commits exist" do
      temp_dir.change_dir do
        `git init`

        expect(tagger.call).to eq(
          Success(
            [
              Milestoner::Models::Tag[
                author: Milestoner::Models::User.new,
                commits: [],
                committed_at: settings.loaded_at,
                sha: nil,
                signature: nil,
                version: Version("1.2.3")
              ]
            ]
          )
        )
      end
    end

    context "with cache and custom build maximum" do
      before do
        settings.build_max = 10

        cache.write :users do |table|
          table.create Milestoner::Models::User[external_id: 1, handle: "test", name: "Test User"]
        end
      end

      it "answers projected milestone when tag and commits exist" do
        git_repo_dir.change_dir do
          `git tag 0.0.0 --message 0.0.0`
          `touch a.txt && git add --all && git commit --message "Added A"`

          expect(tagger.call.success.first).to have_attributes(
            author: Milestoner::Models::User.new,
            commits: kind_of(Array),
            committed_at: kind_of(Time),
            sha: nil,
            signature: nil,
            version: Version("1.2.3")
          )
        end
      end

      it "answers projected and last milestones" do
        git_repo_dir.change_dir do
          `git tag 0.0.0 --message 0.0.0`
          `git tag 0.0.1 --message 0.0.1`

          expect(tagger.call.success.map(&:version)).to eq([Version("1.2.3"), Version("0.0.1")])
        end
      end

      it "answers last milestone when build tail is tag" do
        settings.build_tail = "tag"

        git_repo_dir.change_dir do
          `git tag 0.0.0 --message 0.0.0`
          `git tag 0.0.1 --message 0.0.1`

          expect(tagger.call.success.first).to have_attributes(
            author: Milestoner::Models::User[external_id: 1, handle: "test", name: "Test User"],
            commits: [],
            committed_at: kind_of(Time),
            sha: match(/[0-9a-f]{40}/),
            signature: "",
            version: Version("0.0.1")
          )
        end
      end
    end

    context "with invalid version" do
      before { settings.project_version = "bogus" }

      it "logs error for no tags or commits" do
        git_repo_dir.change_dir do
          `git tag 0.0.0 --message 0.0.0`
          `touch a.txt && git add --all && git commit --message "Added A"`

          expect(tagger.call).to eq(Failure("No tags or commits."))
        end
      end

      it "logs error for invalid version" do
        git_repo_dir.change_dir do
          `git tag 0.0.0 --message 0.0.0`
          `touch a.txt && git add --all && git commit --message "Added A"`
          tagger.call

          expect(logger.reread).to match(/🛑.+Invalid version/)
        end
      end
    end
  end
end
