ApplicationController.class_eval do
  helper_method :jskit

  def jskit(config = { namespace: nil })
    events = [
      application_event(config),
      controller_event(config),
      action_event(config)
    ].join("\n")

    view_context.javascript_tag(events)
  end

  def set_action_payload(*args)
    @action_payload = payload_js(args)
  end

  def set_controller_payload(*args)
    @controller_payload = payload_js(args)
  end

  def set_app_payload(*args)
    @app_payload = payload_js(args)
  end

  private

  def payload_js(payload)
    comma = ", "
    comma + payload.map(&:to_json).join(comma)
  end

  def action_event(config)
    build_event_trigger(config, controller_name, action_name, @action_payload)
  end

  def controller_event(config)
    build_event_trigger(config, controller_name, "all", @controller_payload)
  end

  def application_event(config)
    build_event_trigger(config, "application", "all", @app_payload)
  end

  def build_event_trigger(config, middle_namespace, final_namespace, payload)
    event = [
      config[:namespace],
      "controller",
      middle_namespace,
      final_namespace
    ].compact.join(":")

    [
      JskitRails.configuration.app_namespace,
      "Dispatcher",
      %Q(trigger("#{event}"#{payload});)
    ].join(".")
  end
end
