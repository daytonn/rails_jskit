require "rails_helper"

describe JskitRails do
  describe "#configure" do
    it "allows you to set configuration values" do
      JskitRails.configure do |config|
        config.app_namespace = "Test"
      end
      expect(subject.configuration.app_namespace).to eq("Test")
    end
  end
end
