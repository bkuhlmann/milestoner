# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Cache::List do
  include Dry::Monads[:result]

  subject(:action) { described_class.new }

  include_context "with application dependencies"
  include_context "with user"

  describe "#call" do
    it "logs loading information" do
      action.call
      expect(logger.reread).to match(/🟢.+Listing users.../)
    end

    it "lists users when users exist" do
      record = user
      cache.commit(:users) { upsert record }
      action.call

      expect(kernel).to have_received(:puts).with("1, test, Test")
    end

    it "logs users missing when users don't exist" do
      action.call
      expect(logger.reread).to match(/🟢.+No users found\./)
    end
  end
end
