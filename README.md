jskit_rails
===========

jskit_rails is a gem that let's you seamlessly integrate rails with [JSKit](https://github.com/daytonn/jskit).

Installation
------------

Add `jskit_rails` to your Gemfile:

```rb
gem "jskit_rails"
```

Bundle it up:

```sh
bundle install
```

Add the `jskit` helper to your layout (i.e. `app/views/layouts/application.html.erb`):

```html
<%= jskit %>
```

Add the jskit javascript (i.e. `app/assets/javascripts/application.js`):

```js
//= require jskit_rails
```

That's it, now all controller actions will be triggered on the `JSKit` dispatcher. For example, assume you have a `PagesController` with an `index` action. When we visit the `pages#index` page the `jskit` helper will trigger the appropriate event:

```js
App.Dispatcher.trigger("controller:pages:index");
```

If you wish to pass data to the event handler, simply set the payload from the controller:

```rb
class PagesController < ApplicationController
  def index
    set_jskit_payload("foo", [1, 2, 3], { some: "object" })
  end
end
```

Everything passed to `set_payload` will be converted to json for you (via `to_json`) and passed to the dispatcher:

```js
App.Dispatcher.trigger("controller:pages:index", "foo", [1, 2, 3], { "some": "object" });
```

Here is an example application using `jskit_rails`: [jskit-rails-example](https://github.com/daytonn/jskit-rails-example)
