# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Citations::URI do
  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers URI when key exists" do
      expect(transformer.call({project_uri: "https://demo.com"})).to be_success(
        project_uri: "https://demo.com"
      )
    end

    it "answers citation URL when key is missing and citation exists" do
      transformer = described_class.new path: SPEC_ROOT.join("support/fixtures/CITATION.cff")
      expect(transformer.call({})).to be_success(project_uri: "https://acme.io/projects/demo")
    end

    it "answers formatted URL when specifiers are detected" do
      attributes = {
        organization_uri: "https://acme.io",
        project_name: "test",
        project_uri: "%<organization_uri>s/projects/%<project_name>s"
      }

      expect(transformer.call(attributes)).to be_success(
        organization_uri: "https://acme.io",
        project_name: "test",
        project_uri: "https://acme.io/projects/test"
      )
    end

    it "answers empty hash when key is missing" do
      transformer = described_class.new path: Pathname("bogus.cff")
      expect(transformer.call({})).to be_success({})
    end

    it "answers failure when string specifier is missing" do
      attributes = {project_uri: "%<organization_uri>s/projects/%<project_name>s"}
      transformer = described_class.new path: Pathname("bogus.cff")

      expect(transformer.call(attributes)).to be_failure(
        step: :transform,
        payload: %(Unable to transform :project_uri, missing specifier: "<organization_uri>".)
      )
    end
  end
end
