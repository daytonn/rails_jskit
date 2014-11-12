require "rails_helper"

describe ApplicationController, type: :controller do
  shared_examples "a payload setter" do |payload_type|
    describe "#set_#{payload_type}_payload" do
      it "sets the #{payload_type}_payload to an array of the passed arguments" do
        controller.send("set_#{payload_type}_payload", "foo")
        expect(assigns("#{payload_type}_payload")).to eq(', "foo"')
        controller.send("set_#{payload_type}_payload", "foo", "bar", "baz")
        expect(assigns("#{payload_type}_payload")).to eq(', "foo", "bar", "baz"')
      end
    end
  end

  it_behaves_like "a payload setter", :action
  it_behaves_like "a payload setter", :controller
  it_behaves_like "a payload setter", :app

  describe "#jskit" do
    class OrdersController < ApplicationController
    end

    it "returns a script tag with the global event and the controller event" do
      controller = OrdersController.new
      controller.action_name = "action"
      view_context = controller.view_context

      app_event = "App.Dispatcher.trigger(\"controller:application:all\", \"baz\");"
      controller_event = "App.Dispatcher.trigger(\"controller:orders:all\", \"bar\");"
      action_event = "App.Dispatcher.trigger(\"controller:orders:action\", \"foo\");"
      expected_js = view_context.javascript_tag([app_event, controller_event, action_event].join("\n"))

      controller.set_action_payload("foo")
      controller.set_controller_payload("bar")
      controller.set_app_payload("baz")

      expect(controller.jskit).to eq(expected_js)
    end

    it "is exposed as a helper method" do
      expect(controller.view_context.jskit).to eq(controller.jskit)
    end

    it "namespaces events based on the config" do
      controller = OrdersController.new
      controller.action_name = "action"
      view_context = controller.view_context

      app_event = "App.Dispatcher.trigger(\"some_namespace:controller:application:all\");"
      controller_event = "App.Dispatcher.trigger(\"some_namespace:controller:orders:all\");"
      action_event = "App.Dispatcher.trigger(\"some_namespace:controller:orders:action\");"
      expected_js = view_context.javascript_tag([app_event, controller_event, action_event].join("\n"))

      expect(controller.jskit(namespace: "some_namespace")).to eq(expected_js)
    end
  end
end
