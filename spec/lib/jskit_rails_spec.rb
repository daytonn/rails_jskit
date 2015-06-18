require "rails_helper"

describe RailsJskit do
  describe "#configure" do
    it "allows you to set configuration values" do
      RailsJskit.configure do |config|
        config.app_namespace = "Test"
      end
      expect(subject.configuration.app_namespace).to eq("Test")
    end
  end
end
