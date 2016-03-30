# frozen_string_literal: true

require "spec_helper"
require "milestoner/cli"

RSpec.describe Milestoner::CLI do
  describe ".start" do
    let(:version) { "0.1.0" }
    let(:options) { [] }
    let(:command_line) { Array(command).concat options }
    let(:results) { -> { described_class.start command_line } }

    shared_examples_for "a Git repository error" do
      it "prints invalid repository error" do
        Dir.chdir(temp_dir) do
          expect(&results).to output(/error\s+Invalid\sGit\srepository\./).to_stdout
        end
      end
    end

    shared_examples_for "a version error" do
      let(:options) { [] }

      it "prints invalid version error", :git_repo do
        Dir.chdir(git_repo_dir) do
          error = /error\s+Invalid\sversion\:\s\.\sUse\:\s\<major\>\.\<minor\>\.\<maintenance\>/
          expect(&results).to output(error).to_stdout
        end
      end
    end

    shared_examples_for "a commits command" do
      it "prints commits for new tag", :git_repo do
        Dir.chdir(git_repo_dir) do
          expect(&results).to output(/\-\sAdded\sdummy\sfiles\.\n/).to_stdout
        end
      end

      it_behaves_like "a Git repository error"
    end

    shared_examples_for "an unsigned tag" do
      let(:tagger) { instance_spy Milestoner::Tagger }
      before { allow(Milestoner::Tagger).to receive(:new).and_return(tagger) }

      it "creates an unsigned tag" do
        ClimateControl.modify HOME: temp_dir do
          results.call
          expect(tagger).to have_received(:create).with(version, sign: false)
        end
      end
    end

    shared_examples_for "a signed tag" do
      let(:options) { [version, "-s"] }
      let(:tagger) { instance_spy Milestoner::Tagger }
      before { allow(Milestoner::Tagger).to receive(:new).and_return(tagger) }

      it "signs tag" do
        ClimateControl.modify HOME: temp_dir do
          results.call
          expect(tagger).to have_received(:create).with(version, sign: true)
        end
      end
    end

    shared_examples_for "a tag command" do
      let(:options) { [version] }

      it_behaves_like "an unsigned tag"
      it_behaves_like "a signed tag"
      it_behaves_like "a version error"
      it_behaves_like "a Git repository error"

      it "prints repository has been tagged" do
        ClimateControl.modify HOME: temp_dir do
          Dir.chdir(git_repo_dir) do
            expect(&results).to output(/Repository\stagged\:\sv0\.1\.0/).to_stdout
          end
        end
      end
    end

    shared_examples_for "a push command" do
      let(:pusher) { instance_spy Milestoner::Pusher }

      it "pushes tags", :git_repo do
        allow(Milestoner::Pusher).to receive(:new).and_return(pusher)

        Dir.chdir(git_repo_dir) do
          results.call
          expect(pusher).to have_received(:push)
        end
      end

      it "prints repository has been tagged", :git_repo do
        allow(Milestoner::Pusher).to receive(:new).and_return(pusher)

        Dir.chdir(git_repo_dir) do
          expect(&results).to output(/info\s+Tags\spushed\sto\sremote\srepository\./).to_stdout
        end
      end

      it_behaves_like "a Git repository error"
    end

    shared_examples_for "a publish command" do
      let(:options) { [version] }
      let(:pusher) { instance_spy Milestoner::Pusher }

      it_behaves_like "an unsigned tag"
      it_behaves_like "a signed tag"
      it_behaves_like "a version error"
      it_behaves_like "a Git repository error"

      it "prints repository has been tagged and published", :git_repo do
        allow(Milestoner::Pusher).to receive(:new).and_return(pusher)

        ClimateControl.modify HOME: temp_dir do
          Dir.chdir(git_repo_dir) do
            text = /
              \s+info\s+Repository\stagged\sand\spushed\:\sv0\.1\.0\.\n
              \s+info\s+Milestone\spublished\!\n
            /x

            expect(&results).to output(text).to_stdout
          end
        end
      end
    end

    shared_examples_for "an edit command" do
      let(:global_configuration_path) { File.join ENV["HOME"], Milestoner::Identity.file_name }

      it "edits global configuration", :git_repo do
        ClimateControl.modify EDITOR: %(printf "%s\n") do
          Dir.chdir(git_repo_dir) do
            expect(&results).to output(/info\s+Editing\:\s#{global_configuration_path}\.\.\./).to_stdout
          end
        end
      end
    end

    shared_examples_for "a version command" do
      it "prints version" do
        expect(&results).to output(/Milestoner\s#{Milestoner::Identity.version}\n/).to_stdout
      end
    end

    shared_examples_for "a help command" do
      it "prints usage" do
        regex = /#{Milestoner::Identity.label}\s#{Milestoner::Identity.version}\scommands:\n/
        expect(&results).to output(regex).to_stdout
      end
    end

    describe "--commits" do
      let(:command) { "--commits" }
      it_behaves_like "a commits command"
    end

    describe "-c" do
      let(:command) { "-c" }
      it_behaves_like "a commits command"
    end

    describe "--tag", :git_repo do
      let(:command) { "--tag" }
      it_behaves_like "a tag command"
    end

    describe "-t", :git_repo do
      let(:command) { "-t" }
      it_behaves_like "a tag command"
    end

    describe "--push" do
      let(:command) { "--push" }
      it_behaves_like "a push command"
    end

    describe "-p" do
      let(:command) { "-p" }
      it_behaves_like "a push command"
    end

    describe "--publish" do
      let(:command) { "--publish" }
      it_behaves_like "a publish command"
    end

    describe "-P" do
      let(:command) { "-P" }
      it_behaves_like "a publish command"
    end

    describe "--edit" do
      let(:command) { "--edit" }
      it_behaves_like "an edit command"
    end

    describe "-e" do
      let(:command) { "-e" }
      it_behaves_like "an edit command"
    end

    describe "--version" do
      let(:command) { "--version" }
      it_behaves_like "a version command"
    end

    describe "-v" do
      let(:command) { "-v" }
      it_behaves_like "a version command"
    end

    describe "--help" do
      let(:command) { "--help" }
      it_behaves_like "a help command"
    end

    describe "-h" do
      let(:command) { "-h" }
      it_behaves_like "a help command"
    end

    context "with no command" do
      let(:command) { nil }
      it_behaves_like "a help command"
    end
  end
end
