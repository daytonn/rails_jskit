require "rails_helper"

describe RailsJskit::VERSION do
  it "reads the version from the VERSION file" do
    expect(RailsJskit::VERSION).to eq(File.read(File.join(File.expand_path("../../..", __FILE__), "VERSION")))
  end
end
