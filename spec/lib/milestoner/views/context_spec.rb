# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Milestoner::Views::Context do
  using Refinements::Struct
  using Versionaire::Cast

  subject(:a_context) { described_class.new }

  include_context "with application dependencies"

  describe "#build_stylesheet" do
    it "answers stylesheet" do
      expect(a_context.build_stylesheet).to eq("page")
    end
  end

  describe "#generator_label" do
    it "answers label" do
      expect(a_context.generator_label).to eq("Milestoner")
    end
  end

  describe "#generator_uri" do
    it "answers URI" do
      expect(a_context.generator_uri).to eq("https://alchemists.io/projects/milestoner")
    end
  end

  describe "#generator_version" do
    it "answers version" do
      expect(a_context.generator_version).to match(/\d+\.\d+\.\d+/)
    end
  end

  describe "#project_author" do
    it "answers author" do
      expect(a_context.project_author).to eq("Tester")
    end
  end

  describe "#project_description" do
    it "answers description" do
      expect(a_context.project_description).to eq("A test.")
    end
  end

  describe "#project_label" do
    it "answers label" do
      expect(a_context.project_label).to eq("Test")
    end
  end

  describe "#project_name" do
    it "answers name" do
      expect(a_context.project_name).to eq("test")
    end
  end

  describe "#project_slug" do
    it "answers name and version" do
      expect(a_context.project_slug).to eq("test_123")
    end

    it "answers name only when version is missing" do
      settings.project_version = nil
      expect(a_context.project_slug).to eq("test")
    end

    it "answers version only when name is missing" do
      settings.project_name = nil
      expect(a_context.project_slug).to eq("123")
    end

    it "answers empty string when label and version are missing" do
      settings.project_name = nil
      settings.project_version = nil

      expect(a_context.project_slug).to eq("")
    end
  end

  describe "#project_title" do
    it "answers labeled version" do
      expect(a_context.project_title).to eq("Test 1.2.3")
    end

    it "answers label only when version is missing" do
      settings.project_version = nil
      expect(a_context.project_title).to eq("Test")
    end

    it "answers version only when label is missing" do
      settings.project_label = nil
      expect(a_context.project_title).to eq("1.2.3")
    end

    it "answers empty string when label and version are missing" do
      settings.project_label = nil
      settings.project_version = nil

      expect(a_context.project_title).to eq("")
    end
  end

  describe "#project_version" do
    it "answers version" do
      expect(a_context.project_version).to eq(Version("1.2.3"))
    end
  end
end
