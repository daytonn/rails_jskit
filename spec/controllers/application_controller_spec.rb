require "rails_helper"

describe ApplicationController, type: :controller do
  describe "#action_payload" do
    it "sets the action_payload to an array of the arguments passed" do
      ApplicationController::JSKit.action_payload = "foo"
      expect(ApplicationController::JSKit.action_payload).to eq(', "foo"')
      ApplicationController::JSKit.action_payload = ["foo", "bar", "baz"]
      expect(ApplicationController::JSKit.action_payload).to eq(', "foo", "bar", "baz"')
    end
  end

  describe "#controller_payload" do
    it "sets the controller_payload to an array of the arguments passed" do
      ApplicationController::JSKit.controller_payload = "foo"
      expect(ApplicationController::JSKit.controller_payload).to eq(', "foo"')
      ApplicationController::JSKit.controller_payload = ["foo", "bar", "baz"]
      expect(ApplicationController::JSKit.controller_payload).to eq(', "foo", "bar", "baz"')
    end
  end

  describe "#app_payload" do
    it "sets the app_payload to an array of the arguments passed" do
      ApplicationController::JSKit.app_payload = "foo"
      expect(ApplicationController::JSKit.app_payload).to eq(', "foo"')
      ApplicationController::JSKit.app_payload = ["foo", "bar", "baz"]
      expect(ApplicationController::JSKit.app_payload).to eq(', "foo", "bar", "baz"')
    end
  end

  describe "#jskit" do
    it "returns a script tag with the global event and the controller event" do
      subject = ApplicationController.new
      allow(ApplicationController::JSKit).to receive(:controller_name) { "test_controller" }
      allow(ApplicationController::JSKit).to receive(:action_name) { "test_action" }
      application_event = ApplicationController::JSKit.send(:application_event)
      controller_event = ApplicationController::JSKit.send(:controller_event)
      action_event = ApplicationController::JSKit.send(:action_event)

      expect(subject.jskit).to eq(subject.view_context.javascript_tag([application_event, controller_event, action_event].join("\n")))
    end
  end
end
