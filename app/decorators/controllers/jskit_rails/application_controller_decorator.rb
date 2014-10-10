ApplicationController.class_eval do
  helper_method :jskit

  def jskit(config = { namespace: nil })
    view_context.javascript_tag [jskit_global_event, jskit_controller_event].join("\n")
  end

  def set_jskit_payload(*payload)
    @jskit_payload = payload
  end

  private

  def jskit_payload
    @jskit_payload.blank? ? "" : ", #{[*@jskit_payload].map(&:to_json).join(', ')}"
  end

  def jskit_event_name(config)
    [config[:namespace], "controller", controller_name, action_name].compact.join(":")
  end

  def jskit_global_event
    [
      JskitRails.configuration.app_namespace,
      "Dispatcher",
      "trigger(\"controller:all\");"
    ].join(".")
  end

  def jskit_controller_event
    [
      JskitRails.configuration.app_namespace,
      "Dispatcher",
      "trigger(\"#{jskit_event_name(config)}\"#{jskit_payload});"
    ].join(".")
  end
end
