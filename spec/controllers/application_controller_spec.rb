require "rails_helper"

describe ApplicationController, type: :controller do
  describe "#set_jskit_payload" do
    it "sets the payload to an array of the arguments passed" do
      subject.set_jskit_payload("foo")
      expect(subject.send(:jskit_payload)).to eq(', "foo"')
      subject.set_jskit_payload("foo", "bar", "baz")
      expect(subject.send(:jskit_payload)).to eq(', "foo", "bar", "baz"')
    end
  end

  describe "#jskit_event_name" do
    before do
      allow(subject).to receive(:controller_name) { "test_controller" }
      allow(subject).to receive(:action_name) { "test_action" }
    end

    it "returns the event name" do
      expect(subject.send(:jskit_event_name, namespace: nil)).to eq("controller:test_controller:test_action")
    end

    context "with namespace" do
      it "returns the controller event name prefixed with the namespace" do
        expect(subject.send(:jskit_event_name, namespace: "test")).to eq("test:controller:test_controller:test_action")
      end
    end
  end

  describe "#jskit" do
    it "returns a script tag with the global event and the controller event" do
      global_event = subject.send(:jskit_global_event)
      controller_event = subject.send(:jskit_controller_event)
      expect(subject.jskit).to eq(subject.view_context.javascript_tag([global_event, controller_event].join("\n")))
    end
  end
end
