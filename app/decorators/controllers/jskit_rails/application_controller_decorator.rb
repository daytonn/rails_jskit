::ApplicationController.class_eval do
  helper_method :jskit_rails

  def jskit_rails(config = { namespace: nil })
    "<script>\n//<![CDATA[\n#{JskitRails.configuration.app_namespace}.Dispatcher.trigger(\"controller:all\");\n#{JskitRails.configuration.app_namespace}.Dispatcher.trigger(\"#{jskit_event_name(config)}\"#{jskit_payload});\n//]]>\n</script>".html_safe
  end

  def jskit_event_name(config)
    [config[:namespace], "controller", controller_name, action_name].compact.join(":")
  end

  def jskit_payload
    @jskit_payload.blank? ? "" : ", #{[*@jskit_payload].map(&:to_json).join(", ")}"
  end

  def set_jskit_payload(*payload)
    @jskit_payload = payload
  end
end
