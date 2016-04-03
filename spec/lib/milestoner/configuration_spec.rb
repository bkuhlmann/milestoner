# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration, :temp_dir do
  let(:file_name) { ".testrc" }
  subject { described_class.new }

  describe "#global_file_path" do
    it "answers default file path" do
      expect(subject.global_file_path).to eq(File.join(ENV["HOME"], Milestoner::Identity.file_name))
    end

    it "answers custom file path" do
      subject = described_class.new file_name
      expect(subject.global_file_path).to eq(File.join(ENV["HOME"], file_name))
    end
  end

  describe "#local_file_path" do
    it "answers default file path" do
      expect(subject.local_file_path).to eq(File.join(Dir.pwd, Milestoner::Identity.file_name))
    end

    it "answers custom file path" do
      subject = described_class.new file_name
      expect(subject.local_file_path).to eq(File.join(Dir.pwd, file_name))
    end
  end

  describe "#global?" do
    it "answers true when global configuration file exists" do
      ClimateControl.modify HOME: temp_dir do
        FileUtils.touch subject.global_file_path
        expect(subject.global?).to eq(true)
      end
    end

    it "answers false when global configuration file doesn't exist" do
      ClimateControl.modify HOME: temp_dir do
        expect(subject.global?).to eq(false)
      end
    end
  end

  describe "#local?" do
    it "answers true when local configuration file exists" do
      Dir.chdir temp_dir do
        FileUtils.touch subject.local_file_path
        expect(subject.local?).to eq(true)
      end
    end

    it "answers false when local configuration file doesn't exist" do
      Dir.chdir temp_dir do
        expect(subject.local?).to eq(false)
      end
    end
  end

  describe "#computed_file_path" do
    context "when local configuration exists" do
      let(:local_file) { File.join temp_dir, Milestoner::Identity.file_name }
      before { FileUtils.touch local_file }

      it "answers local file path" do
        Dir.chdir temp_dir do
          expect(subject.computed_file_path).to eq(subject.local_file_path)
        end
      end
    end

    context "when local configuration doesn't exists" do
      it "answers global file path" do
        Dir.chdir temp_dir do
          expect(subject.computed_file_path).to eq(subject.global_file_path)
        end
      end
    end
  end

  describe "#settings" do
    let(:global_file) { File.join temp_dir, file_name }
    let(:local_dir) { File.join temp_dir, "local" }
    let(:local_file) { File.join local_dir, file_name }
    let(:defaults) { {} }
    let(:global_defaults) { {example: "Global"} }
    let(:local_defaults) { {example: "Local"} }
    subject { described_class.new file_name, defaults: defaults }

    context "when using global path" do
      before { File.open(global_file, "w") { |file| file << global_defaults.to_yaml } }

      it "answers global settings" do
        ClimateControl.modify HOME: temp_dir do
          expect(subject.settings).to eq(global_defaults)
        end
      end
    end

    context "when using local path" do
      before do
        FileUtils.mkdir_p local_dir
        File.open(global_file, "w") { |file| file << global_defaults.to_yaml }
        File.open(local_file, "w") { |file| file << local_defaults.to_yaml }
      end

      it "answers local settings" do
        ClimateControl.modify HOME: temp_dir do
          Dir.chdir local_dir do
            expect(subject.settings).to eq(local_defaults)
          end
        end
      end
    end

    context "when configuration file doesn't exist" do
      it "answers default settings" do
        ClimateControl.modify HOME: temp_dir do
          expect(subject.settings).to eq({})
        end
      end
    end

    context "when file has nil values" do
      let(:global_defaults) { {one: "one", two: nil, three: "three"} }
      before { File.open(global_file, "w") { |file| file << global_defaults.to_yaml } }

      it "answers settings with values only" do
        ClimateControl.modify HOME: temp_dir do
          expect(subject.settings).to eq(one: "one", three: "three")
        end
      end
    end

    context "when defaults have nil values" do
      let(:defaults) { {one: "one", two: nil, three: "three"} }

      it "answers settings with values only" do
        ClimateControl.modify HOME: temp_dir do
          expect(subject.settings).to eq(one: "one", three: "three")
        end
      end
    end

    context "when using file and default settings" do
      let(:global_defaults) { {two: %w(red black white), four: 4} }
      let(:defaults) { {one: 1, two: 2, three: 3} }
      before { File.open(global_file, "w") { |file| file << global_defaults.to_yaml } }

      it "answers merged settings with file taking precedence over defaults" do
        ClimateControl.modify HOME: temp_dir do
          expect(subject.settings).to eq(one: 1, two: %w(red black white), three: 3, four: 4)
        end
      end
    end
  end
end
