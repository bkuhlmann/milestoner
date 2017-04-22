# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI do
  describe ".start" do
    let(:version) { "0.1.0" }
    let(:options) { [] }
    let(:command_line) { Array(command).concat options }
    let :cli do
      lambda do
        load "milestoner/cli.rb" # Ensures clean Thor `.method_option` evaluation per spec.
        described_class.start command_line
      end
    end

    shared_examples_for "a version error", :git_repo do
      let(:version) { "bogus" }

      it "prints invalid version error" do
        Dir.chdir(git_repo_dir) do
          expect(&cli).to output(/Invalid version conversion\: bogus/).to_stdout
        end
      end
    end

    shared_examples_for "a commits command", :git_repo do
      it "prints commits for new tag" do
        Dir.chdir(git_repo_dir) do
          expect(&cli).to output(/\-\sAdded\sdummy\sfiles\.\n/).to_stdout
        end
      end
    end

    shared_examples_for "an unsigned tag", :temp_dir do
      let(:tagger) { instance_spy Milestoner::Tagger }
      before { allow(Milestoner::Tagger).to receive(:new).and_return(tagger) }

      it "creates an unsigned tag" do
        ClimateControl.modify HOME: temp_dir do
          cli.call
          expect(tagger).to have_received(:create).with(version, sign: false)
        end
      end
    end

    shared_examples_for "a signed tag", :temp_dir do
      let(:options) { [version, "-s"] }
      let(:tagger) { instance_spy Milestoner::Tagger }
      before { allow(Milestoner::Tagger).to receive(:new).and_return(tagger) }

      it "signs tag" do
        ClimateControl.modify HOME: temp_dir do
          cli.call
          expect(tagger).to have_received(:create).with(version, sign: true)
        end
      end
    end

    shared_examples_for "a tag command", :git_repo do
      let(:options) { [version] }

      it_behaves_like "an unsigned tag"
      it_behaves_like "a signed tag"
      it_behaves_like "a version error"

      it "prints repository has been tagged" do
        ClimateControl.modify HOME: temp_dir do
          Dir.chdir(git_repo_dir) do
            expect(&cli).to output(/Repository\stagged\:\sv0\.1\.0/).to_stdout
          end
        end
      end
    end

    shared_examples_for "a push command", :git_repo do
      let(:pusher) { instance_spy Milestoner::Pusher }

      it "pushes tags" do
        allow(Milestoner::Pusher).to receive(:new).and_return(pusher)

        Dir.chdir(git_repo_dir) do
          cli.call
          expect(pusher).to have_received(:push)
        end
      end

      it "prints repository has been tagged" do
        allow(Milestoner::Pusher).to receive(:new).and_return(pusher)

        Dir.chdir(git_repo_dir) do
          expect(&cli).to output(/info\s+Tags\spushed\sto\sremote\srepository\./).to_stdout
        end
      end
    end

    shared_examples_for "a publish command", :git_repo do
      let(:options) { [version] }
      let(:pusher) { instance_spy Milestoner::Pusher }

      it_behaves_like "an unsigned tag"
      it_behaves_like "a signed tag"
      it_behaves_like "a version error"

      it "prints repository has been tagged and published" do
        allow(Milestoner::Pusher).to receive(:new).and_return(pusher)

        ClimateControl.modify HOME: temp_dir do
          Dir.chdir(git_repo_dir) do
            text = /
              \s+info\s+Repository\stagged\sand\spushed\:\sv0\.1\.0\.\n
              \s+info\s+Milestone\spublished\!\n
            /x

            expect(&cli).to output(text).to_stdout
          end
        end
      end
    end

    shared_examples_for "a config command", :git_repo do
      let(:configuration_path) { File.join git_repo_dir, Milestoner::Identity.file_name }
      before { FileUtils.touch configuration_path }

      context "with info option" do
        let(:options) { %w[-i] }

        it "prints configuration path" do
          Dir.chdir(git_repo_dir) do
            expect(&cli).to output("#{configuration_path}\n").to_stdout
          end
        end
      end

      context "with no options" do
        it "prints help text" do
          expect(&cli).to output(/Manage gem configuration./).to_stdout
        end
      end
    end

    shared_examples_for "a version command" do
      it "prints version" do
        expect(&cli).to output(/Milestoner\s#{Milestoner::Identity.version}\n/).to_stdout
      end
    end

    shared_examples_for "a help command" do
      it "prints usage" do
        regex = /#{Milestoner::Identity.label}\s#{Milestoner::Identity.version}\scommands:\n/
        expect(&cli).to output(regex).to_stdout
      end
    end

    describe "--commits" do
      let(:command) { "--commits" }
      it_behaves_like "a commits command"
    end

    describe "-C" do
      let(:command) { "-C" }
      it_behaves_like "a commits command"
    end

    describe "--tag" do
      let(:command) { "--tag" }
      it_behaves_like "a tag command"
    end

    describe "-t" do
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

    describe "--config" do
      let(:command) { "--config" }
      it_behaves_like "a config command"
    end

    describe "-c" do
      let(:command) { "-c" }
      it_behaves_like "a config command"
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
