require "rails_helper"

describe JskitRails::VERSION do
  it "reads the version from the VERSION file" do
    expect(JskitRails::VERSION).to eq(File.read(File.join(File.expand_path("../..", __FILE__), "VERSION")))
  end
end
