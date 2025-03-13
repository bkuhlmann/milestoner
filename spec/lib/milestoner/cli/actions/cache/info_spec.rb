# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Cache::Info do
  subject(:action) { described_class.new }

  include_context "with application dependencies"
  include_context "with user"

  describe "#call" do
    it "logs path information when cache exists" do
      record = user
      cache.write(:users) { upsert record }

      action.call
      expect(logger.reread).to match(/🟢.+Path: #{temp_dir.join "database.store"}\./)
    end

    it "logs no path information when cache doesn't exist" do
      action.call
      expect(logger.reread).to match(/🟢.+No cache found\./)
    end
  end
end
