# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Git::Config, :git_repo do
  subject(:config) { described_class.new }

  describe "#get" do
    let(:key) { "user.name" }

    context "when key exists" do
      it "answers key value" do
        Dir.chdir(git_repo_dir) do
          stdout, = config.get key
          expect(stdout).to eq("Test Example\n")
        end
      end

      it "answers empty error" do
        Dir.chdir(git_repo_dir) do
          _, stderr, = config.get key
          expect(stderr).to eq("")
        end
      end

      it "answers success status" do
        Dir.chdir(git_repo_dir) do
          _, _, status = config.get key
          expect(status.success?).to eq(true)
        end
      end
    end

    context "when key doesn't exist" do
      it "answers empty key value" do
        ClimateControl.modify HOME: git_repo_dir do
          stdout, = config.get "user.test"
          expect(stdout).to eq("")
        end
      end

      it "answers empty error" do
        ClimateControl.modify HOME: git_repo_dir do
          _, stderr, = config.get "user.test"
          expect(stderr).to eq("")
        end
      end

      it "answers failure status" do
        ClimateControl.modify HOME: git_repo_dir do
          _, _, status = config.get "user.test"
          expect(status.success?).to eq(false)
        end
      end
    end

    context "when key is invalid" do
      let(:key) { "bogus" }

      it "answers empty key value" do
        ClimateControl.modify HOME: git_repo_dir do
          stdout, = config.get key
          expect(stdout).to eq("")
        end
      end

      it "answers error message" do
        ClimateControl.modify HOME: git_repo_dir do
          _, stderr, = config.get key
          expect(stderr).to match(/error.+#{key}/)
        end
      end

      it "answers failure status" do
        ClimateControl.modify HOME: git_repo_dir do
          _, _, status = config.get key
          expect(status.success?).to eq(false)
        end
      end
    end
  end

  describe "#set" do
    context "when key exists" do
      let(:key) { "user.name" }
      let(:value) { "Jayne Doe" }

      it "create key value" do
        Dir.chdir(git_repo_dir) do
          config.set key, value
          stdout, = config.get key

          expect(stdout).to eq("#{value}\n")
        end
      end

      it "answers empty output" do
        Dir.chdir(git_repo_dir) do
          stdout, = config.set key, value
          expect(stdout).to eq("")
        end
      end

      it "answers empty error" do
        Dir.chdir(git_repo_dir) do
          _, stderr, = config.set key, value
          expect(stderr).to eq("")
        end
      end

      it "answers success status" do
        Dir.chdir(git_repo_dir) do
          _, _, status = config.set key, value
          expect(status.success?).to eq(true)
        end
      end
    end

    context "when key doesn't exist" do
      let(:key) { "user.text" }
      let(:value) { "Text Example" }

      it "create key value" do
        Dir.chdir(git_repo_dir) do
          config.set key, value
          stdout, = config.get key

          expect(stdout).to eq("#{value}\n")
        end
      end

      it "answers empty output" do
        Dir.chdir(git_repo_dir) do
          stdout, = config.set key, value
          expect(stdout).to eq("")
        end
      end

      it "answers empty error" do
        Dir.chdir(git_repo_dir) do
          _, stderr, = config.set key, value
          expect(stderr).to eq("")
        end
      end

      it "answers success status" do
        Dir.chdir(git_repo_dir) do
          _, _, status = config.set key, value
          expect(status.success?).to eq(true)
        end
      end
    end
  end

  describe "#value" do
    context "when key exists" do
      it "answers key without whitespace" do
        Dir.chdir(git_repo_dir) do
          expect(config.value("user.name")).to eq("Test Example")
        end
      end
    end

    context "when key doesn't exist" do
      it "answers empty string" do
        Dir.chdir(git_repo_dir) do
          expect(config.value("user.unknown")).to eq("")
        end
      end
    end
  end
end
