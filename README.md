![RailsJskit](https://raw.githubusercontent.com/daytonn/rails_jskit/master/jskit-logo.png "rails_jskit")
===========

[![Gem Version](https://badge.fury.io/rb/rails_jskit.svg)](http://badge.fury.io/rb/rails_jskit)

rails_jskit is a gem that let's you seamlessly integrate rails with [JSkit](https://github.com/daytonn/jskit). View the example repo [here](https://github.com/daytonn/rails_jskit-example) or see it in action [here](https://jskit-rails-example.herokuapp.com/)

[Documentation](http://daytonn.github.io/rails_jskit/documentation.html)

### Dependencies
* [lodash](https://lodash.com/) or [underscore](http://underscorejs.org/)
* [jquery](https://jquery.com/) or equivalent

Make sure that the dependencies is required in your `application.js` file.

```js
//= require lodash
//= require jquery
```

-- or --

```js
//= require underscore
//= require zepto
```

Installation
------------

Add `rails_jskit` to your Gemfile:

```rb
gem "rails_jskit"
```

Bundle it up:

```sh
bundle install
```

Usage
-----

Add the `jskit` helper to your layout (i.e. `app/views/layouts/application.html.erb`):

```html
<%= jskit %>
```

Add the jskit javascript (i.e. `app/assets/javascripts/application.js`):

```js
//= require rails_jskit
```

That's it, now all controller actions will be triggered on the `JSkit` dispatcher.

### Controllers

JSkit offers controllers as a basic building block for JavaScript functionality. Making a folder inside `app/assets/javascripts` named `controllers` is a great place to put these:

```sh
mkdir app/assets/javascripts/controllers
```

Now simply require that entire directory in your `application.js` file:

```js
//= require_tree ./controllers
```

#### Events

There are three events triggered on every page rendered: a global event, a controller event and an action event. Given a `Posts` controller, when rendering the `index` action, you will notice the three events triggered where the `<%= jskit %>` snippet was placed:

```js
App.Dispatcher.trigger("controller:application:all");
App.Dispatcher.trigger("controller:pages:all");
App.Dispatcher.trigger("controller:pages:index");
```

This allows you to integrate your JavaScript at key points in your rails application with minimal coupling. An event triggered with no corresponding `JSkit` controller or action defined has no effect. 

#### Application Controller

It's common to have some JavaScript that runs on every page of your application. In the past, you may have slapped random bits of code inside a jQuery `$(document).ready` block but not with JSkit. JSkit makes an explicit yet minimally coupled connection between your Rails app and your client-side code. To define application-wide behavior, define an application controller in `app/assets/controller/application_controller.js`:

```js
App.createController("Application", {
  all: function() {
    // This handler will be triggered on all pages
  }
});
```

The `all` method is automatically wired to the `controller:application:all` event, which is triggered on each page via the `<%= jskit %>` snippet. You now have a simple, testable controller to define behavior in your application.

All other controllers are defined in the same way, the only difference is that your other controllers will have actions defined. Assuming you have a `Posts` controller in ruby, whose index action needs a bit of JavaScript to spice up the template. You would simply create a corresponding `Posts` controller in `app/assets/javascripts/posts_controller.js`:

```js
App.createController("Posts", {
  actions: ["index"],
  
  index: function() {
    // do stuff on the index page
  }
});
```

Here you can see that the `actions` array tells JSkit to wire up the `index` method to the `controller:posts:index` event. This event is automatically fired by the `<%= jskit %>` snippet.

#### Mapped Events

Sometimes you may want to map an action to a method with a different name, or you may want to map multiple actions to the same method. This is accomplished using mapped actions. Instead of using a string in the actions array, use an object to map the action name to the controller's method:

```js
App.createController("Posts", {
  actions: [
    "index",
    { new: "setupForm" },
    { edit: "setupForm" },
    { create: "setupForm" }
  ],
  
  index: function() {
    // do stuff on the index page
  },
  
  setupForm: function() {
    // setup the posts form
  }
});
```

Here you can see that the `new`, `edit`, and `create` actions are all being wired up to the same method `setupForm`. This allows you to reuse common behavior that is needed accross multiple actions.

Finally, you may wish to have some functionality that runs on every action of a controller, to do this, simply define an all method. The `all` method is automatically wired to the `controller:<controller name>:all` event:

```js
App.createController("Posts", {
  ...
  
  all: function() {
    // do something on every action of the controller
  },
  
  ...
});
```

This event structure is a simple and powerful way to coordinate your Rails application with the client-side code.

### Event Payloads

In addition to simply triggering events, you may optionally pass data to these events. You can pass arbitrary data to any of the three events triggered on page render. To pass data to the application controller's `all` event:


```rb
class ApplicationController < ApplicationController
  before_action :set_jskit_payload
  
  ...
  
  private 
  
  def set_jskit_payload
    set_app_payload(current_user)
  end
end
```

This will pass the current user object to the `Application` controller. You can also pass multiple values:

```rb
class ApplicationController < ApplicationController
  before_action :set_jskit_payload
  
  ...
  
  private 
  
  def set_jskit_payload
    set_app_payload(current_user, [1, 2, 3], { some: "hash" })
  end
end
```

This will pass each item in the array as an argument to the event handler on the controller. Note that each item will have `to_json` called on it automatically, so there is no need to do it yourself. The above example will produce the following triggered event:

```js
...
App.Dispatcher.trigger("controller:application:all", { first_name: "John", last_name: "Doe" }, [1, 2, 3], { "some": "hash" });
...
```

This allows you to share data from your Rails app without explicit knowldge of how your client-side code will consume it. You may also set the controller and action event payloads in the same way:

```rb
class PostsController < ApplicationController
  before_action :set_jskit_payload
  
  def index
    set_action_payload("PostsController#index")
  end
  
  private
  
  def set_jskit_payload
    set_controller_payload("PostsController")
  end
end
```

This should be everything you need to design and test basic client-side interactions with JSkit. If you'd like to see a working example check out [this repo](https://github.com/daytonn/jskit_rails-example).
