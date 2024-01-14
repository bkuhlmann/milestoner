# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Milestoner::Views::Context do
  using Refinements::Struct
  using Versionaire::Cast

  subject(:a_context) { described_class.new }

  include_context "with application dependencies"

  describe "#generator_label" do
    it "answers configuration generator label" do
      expect(a_context.generator_label).to eq("Test Generator")
    end
  end

  describe "#generator_uri" do
    it "answers configuration generator URI" do
      expect(a_context.generator_uri).to eq("https://test.com")
    end
  end

  describe "#project_author" do
    it "answers configuration author" do
      expect(a_context.project_author).to eq("Test Author")
    end
  end

  describe "#project_description" do
    it "answers configuration description" do
      expect(a_context.project_description).to eq("Test description.")
    end
  end

  describe "#project_generator" do
    it "answers configuration generator" do
      expect(a_context.project_generator).to be(nil)
    end
  end

  describe "#project_label" do
    it "answers configuration label" do
      expect(a_context.project_label).to eq("Test Label")
    end
  end

  describe "#project_title" do
    it "answers labeled version" do
      expect(a_context.project_title).to eq("Test Label 1.2.3")
    end

    it "answers label only when version is missing" do
      input.project_version = nil
      expect(a_context.project_title).to eq("Test Label")
    end

    it "answers version only when label is missing" do
      input.project_label = nil
      expect(a_context.project_title).to eq("1.2.3")
    end

    it "answers empty string when label and version are missing" do
      input.project_label = nil
      input.project_version = nil

      expect(a_context.project_title).to eq("")
    end
  end

  describe "#project_version" do
    it "answers configuration version" do
      expect(a_context.project_version).to eq(Version("1.2.3"))
    end
  end
end
