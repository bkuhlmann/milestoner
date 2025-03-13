# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Project::Author do
  subject(:transformer) { described_class.new git: }

  let(:git) { instance_double Gitt::Repository }

  describe "#call" do
    it "answers author when key exists" do
      allow(git).to receive(:get).with("user.name", nil).and_return(Success("Git Example"))

      expect(transformer.call({project_author: "Test Example"})).to be_success(
        project_author: "Test Example"
      )
    end

    it "answers full Git name when custom user is missing and Git user exists" do
      allow(git).to receive(:get).with("user.name", nil).and_return(Success("Git Example"))
      expect(transformer.call({})).to be_success(project_author: "Git Example")
    end

    it "answers empty hash when custom and Git users are missing" do
      allow(git).to receive(:get).with("user.name", nil).and_return(Success(nil))
      expect(transformer.call({})).to be_success({})
    end

    it "answers empty hash when custom user is missing and Git user is a failure" do
      allow(git).to receive(:get).with("user.name", nil).and_return(Failure("Danger!"))
      expect(transformer.call({})).to be_success({})
    end
  end
end
