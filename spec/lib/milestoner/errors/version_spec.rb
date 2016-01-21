# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Errors::Version do
  subject { described_class.new }

  it_behaves_like "a base error"
end
