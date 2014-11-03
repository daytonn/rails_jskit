ApplicationController.class_eval do
  helper_method :jskit

  module JSKit
    mattr_reader :action_payload, :app_payload, :controller_payload
    mattr_accessor :event_namespace, :controller_name, :action_name

    def action_payload=(payload)
      @@action_payload = payload_js([*payload])
    end

    def controller_payload=(payload)
      @@controller_payload = payload_js([*payload])
    end

    def app_payload=(payload)
      @@app_payload = payload_js([*payload])
    end

    private

    def action_event
      [
        JskitRails.configuration.app_namespace,
        "Dispatcher",
        event_trigger(event_name(controller_name, action_name), JSKit.action_payload)
      ].join(".")
    end

    def controller_event
      [
        JskitRails.configuration.app_namespace,
        "Dispatcher",
        event_trigger(event_name(controller_name, "all"), JSKit.controller_payload)
      ].join(".")
    end


    def application_event
      [
        JskitRails.configuration.app_namespace,
        "Dispatcher",
        event_trigger(event_name("application", "all"), JSKit.app_payload)
      ].join(".")
    end

    def event_name(controller, action)
      [event_namespace, "controller", controller, action].compact.join(":")
    end

    def event_trigger(event, payload)
      %Q(trigger("#{event}"#{JSKit.controller_payload});)
    end

    def payload_js(payload)
      payload.empty? ? "" : ", #{payload.map(&:to_json).join(', ')}"
    end

    module_function(
      :action_payload=,
      :app_payload=,
      :controller_payload=,
      :payload_js,
      :application_event,
      :action_event,
      :event_name,
      :event_trigger,
      :controller_event)
  end

  def jskit(config = { namespace: nil })
    JSKit.event_namespace = config[:namespace]
    JSKit.controller_name = controller_name
    JSKit.action_name = action_name

    view_context.javascript_tag [JSKit.application_event, JSKit.controller_event, JSKit.action_event].join("\n")
  end
end
