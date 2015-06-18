require "rails_helper"

describe RailsJskit::Configuration do
  it "has s default app_namespace" do
    expect(subject.app_namespace).to eq("App")
  end

  it "allows you to set the app_namespace" do
    subject.app_namespace = "Test"
    expect(subject.app_namespace).to eq("Test")
  end
end
