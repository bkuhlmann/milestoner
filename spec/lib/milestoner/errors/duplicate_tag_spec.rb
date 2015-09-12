require "spec_helper"

describe Milestoner::Errors::DuplicateTag do
  subject { described_class.new }

  it_behaves_like "a base error"
end
