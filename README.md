![RailsJskit](https://raw.githubusercontent.com/daytonn/rails_jskit/master/logo.png "rails_jskit")
===========

[![Gem Version](https://badge.fury.io/rb/rails_jskit.svg)](http://badge.fury.io/rb/rails_jskit)

rails_jskit is a gem that let's you seamlessly integrate rails with [JSkit](https://github.com/daytonn/jskit). View the example repo [here](https://github.com/daytonn/rails_jskit-example).

* [Online Documentation](http://daytonn.github.io/rails_jskit/documentation.html)
* [Dependencies](#dependencies)
* [Installation](#installation)
  - [Automatic Installation](#automatic-installation)
  - [Manual Installation](#manual-installation)
* [Documentation](#getting-started)
  - [Application Object](#application-object)
    * [Dispatcher](#dispatcher)
    * [Controllers Object](#controllers-object)
    * [Controller Factories](#controller-factories)
  - [Controllers](#controllers)
    * [Actions](#actions)
    * [Mapped Actions](#mapped-actions)
    * [The `all` Action](#the-all-action)
    * [Creating an Application Controller](#creating-an-application-controller)
    * [Passing Data To Actions](#passing-data-to-actions)
    * [Elements](#elements)
    * [Events](#events)

* [Configuration](#configuration)
* [Testing](#getting-started)
  - [Controller Factories](#controller-factories)
  - [Testing Actions](#testing-actions)
  - [Testing Elements](#testing-elements)
  - [Testing Events](#testing-events)

Dependencies
------------

RailsJskit requires `jquery` (or equivalent) and `lodash` (or equivalent). Require them in your `app/assets/javascripts/application.js` before `//= require rails_jskit`.

```js
// app/assets/javascripts/application.js
//= require lodash
//= require jquery
```

Installation
------------

Add `rails_jskit` to your Gemfile:

```ruby
# Gemfile
gem "rails_jskit"
```

Bundle it up

```sh
bundle install
```

###Automatic Installation

RailsJskit comes with handy generators to get you started quickly. Use the generator to install jskit:

```sh
rails generate jskit:install
```

Or you can install it the good old-fashioned way, by hand:

###Manual Installation

Create a `app/assets/javascripts/controllers/` directory and add rails_jskit to `app/assets/javascripts/application.js`:

```js
// app/assets/javascripts/application.js
...
//= require rails_jskit
//= require_tree ./controllers
```

Add `jskit` to your application layout:

```erb
# app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
<head>
  <title>JskitExample</title>
  <%= stylesheet_link_tag 'application', media: 'all' %>
  <%= csrf_meta_tags %>
</head>
<body>
  <%= yield %>
  <%= javascript_include_tag 'application' %>
  <%= jskit %>
</body>
</html>
```

**That's it!** You're ready to use RailsJskit.

Now all your controllers will be loaded at runtime but nothing will execute until events are dispatched.

Documentation
-------------

### Application Object

RailsJskit will automatically create a JSkit application object for you, using the configured `app_namespace` for the global variable name _(defaults to "App")_. This global namespace provides you a way to interact with your JSkit application. You can [configure](#configuration) this setting in your initializer `(config/initializers/rails_jskit.rb)`.

#### Dispatcher

Every JSkit application has a `Dispatcher` object. This object is responsible for registering and triggering events in your application. In general you don't interact directly with the application's Dispatcher, though it's important to know what it is and what it's doing. By default, every controller created by your application will have it's own reference to the Dispatcher object. A controller's actions will automatically be registered on the Dispatcher when it's created, so you shouldn't need to interact with the Dispatcher directly.

#### Controllers Object

Every JSkit application also has a `Controllers` object that stores the Controllers instantiated by your application at runtime. Everytime you create a controller, an instance is created on the controllers object:

```ruby

// app/assets/javascripts/controllers/posts_controller.js
App.createController("Posts", {
  ...
});

App.Controllers.Posts;// Instantiated Posts controller object
```

#### Controller Factories

In addition to instances of each controller, the factory used to create the controller is stored on the application object itself. The factory is a function that will create a freshly initialized controller, useful in testing environments:

```ruby

// app/assets/javascripts/controllers/posts_controller.js
App.createController("Posts", {
  ...
});

App.PostsController;// Factory function to create fresh Posts controller objects
```

### Controllers

The basic component of JSkit is the Controller. Controllers allow you to coordinate JavaScript execution with your Rails controllers. For example, assuming you have a `PostsController` in `app/controllers/posts_controller.rb`.

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  def index
    render :index
  end
end
```

#### Actions

To define JavaScript for that controller, create a corresponding JSkit controller in `app/assets/javascripts/controllers/posts_controller.js` and define it's `actions`. The actions array tells JSkit which functions you want automatically wired to the controller's events. If you wish to run javascript on the `index` action of the `PostsController`, it would look something like this:

```js
// app/assets/javascripts/controllers/posts_controller.js
App.createController("Posts", {
  actions: ["index"]

  index: function() {
    // behavior for posts#index
  }
});
```

Now whenever your `PostsController` renders the `index` action, the JSkit controller's index method will execute. It's that simple.

#### Mapped Actions

You may find yourself wanting to wire up an action with a different function name than it's corresponding rails controlller, or you may want to assign the same function to multiple actions. This can be acheived by using a mapped action:

```js
// app/assets/javascripts/controllers/posts_controller.js
App.createController("Posts", {
  actions: [{
    edit: "setupForm",
    create: "setupForm",
    update: "setupform"
  }],

  ...
  setupForm: function() {
    // form setup
  }
  ...
});
```

This will wire the three events `controllers:posts:edit`, `controllers:posts:create`, and `controllers:posts:upate` to the `setupForm` function.

This simple convention is flexible enough to accomplish any sane JavaScript task for a given action.

_Note: you can mix and match objects and strings within the actions array but it's probably best to define the string actions first and pass an object as the last item in the array. This is only for readability as JSkit does not care about the position of the actions in the array._

```js
...
actions: [
  "index",
  "show",
  {
    edit: "setupForm",
    create: "setupForm",
    update: "setupForm"
  }
]
```

#### The `all` action

There are times when you want a bit of JavaScript to run for every action of a given controller. In this case you can define an `all` method on the controller which will automatically be triggered on every action of the controller:

```js
...
all: function() {
  console.log("Happens on every action");
}
...
```

_Note: you don't have to add `all` to the actions array, JSkit knows what you mean._

#### Creating an Application Controller

In some cases, you may want some JavaScript to run on every single page of your application. Something like fading out flash notifications, or instantiating dynamic menus or something of that nature. In this case you can create an Application Controller at: `app/assets/javscripts/controllers/application_controller.js`

```js
// app/assets/javscripts/controllers/application
App.createController("Application", {
  all: function() {
    setTimeout(function() {
      $("#notifications").fadeOut();
    }, 3000);

    $("#menu").menuify();
  }
});
```

There is nothing special about this controller except the fact that RailsJskit will trigger the `controller:application:all` event on every action of every controller. Which means that the `all` method will execute on every page.

#### Passing Data To Actions

Sometimes you may find yourself wanting to pass data from the Rails side of your application to the client side. The JSkit event system accounts for this and RailsJskit provides a simple interface to this functionality. JSkit has three payload methods, which are available to your application's controllers. The three methods correspond to the three levels of triggered events on any given page.

  1. `set_app_payload` (sent with "controllers:application:all")
  2. `set_controller_payload` (sent with "controllers:[controller name]:[action name]")
  3. `set_action_payload` (sent with "controllers:[controller name][action name]")

Let's assume you want to pass devise's `current_user` object to the application controller. For this you would use `app_payload`

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :jskit_app_payload

  private

  def jskit_app_payload
    set_app_payload(current_user)
  end
end
```

This will pass the `current_user` as JSON in the `controllers:application:all` event:

```js
App.Dispatcher.trigger("controller:application:all", { email: "user@example.com", first_name: "John", last_name: "Smith"... });
```

Your application controller can make use of this data by assigning the argument to the action function:

```js
// app/assets/javascripts/controllers/application_controller.js
App.createController("Application", {
  all: function(currentUser) {
    App.currentUser = currentUser;// { email: "user@example.com", first_name: "John", last_name: "Smith"... }
  }
});
```

These payload methods will take any number of arguments and pass them in order to the event handler. This allows for a simple but flexible way to pass data to your client-side application.

The `set_controller_payload` method and the `set_action_payload` work in the same way only they pass data to their specific events.

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :jskit_controller_payload

  def index
    set_action_payload("Data from the PostsController#index action")
  end

  private jskit_controller_payload

  def jskit_controller_payload
    set_controller_payload("Data from the PostsController")
  end
end
```

This data can be accessed in the JSkit controller like so:

```js
// app/assets/javascript/controllers/posts_controller.js
App.createController("Posts", {
  actions: ["index"],

  all: function(message) {
    console.log(message);// "Data from the PostsController"
  },

  index: function(message) {
    console.log(message);// "Data from the PostsController#index action"
  }
});
```

#### Elements

It's guaranteed you'll end up saving a reference to an `HTMLElement` wrapped in `jQuery` _(the proverbial jQuery burrito)_. You do this so often, it really helps to have a shorthand for doing so. Consider the following code:

```js
// app/assets/controllers/posts_controller.js
App.createController("Posts", {
  actions: ["index"],

  cacheElements: function() {
    this.$postList = $("ul#posts");
    this.$commentToggleLink = $("a.comment-toggle");
    this.$modalWindow = $("#modal-window");
    this.$modalCloseButton = $("#modal-window-close");
  },

  index: function() {
    this.cacheElements();
    // do stuff with elements
  }
});
```

This is generally pretty clean code. It's easy to read and it's simple. The problem is that we're going to want to do the same thing in other actions. We can use the same `cacheElements` method but we may not need all the selectors.

If we do want to scope elements to actions, we'll need a way to scope the selected elements to specific actions. JSkit allows you to define this behavior with a simple `elements` object on the controller. Which looks something like this:

```js
// app/assets/controllers/posts_controller.js
App.createController("Posts", {
  elements: {
    index: {
      postList: "ul#posts",
      commentToggleLink: "a.comment-toggle",
      modalWindow: "#modal-window",
      modalCloseButton: "#modal-window-close"
    }
  },

  index: function() {
    // do stuff with elements
  }
});
```

This keeps all the DOM selection one simple structure that cuts down on the clutter.

_Note: all keys under each action will be set as variables prefixed with the `$` to indicate that it's a `jQuery` wrapped set._

The above example would create three variables on the controller object when the `index` action is triggered:

```js
// app/assets/controllers/posts_controller.js
App.createController("Posts", {
  elements: {
    index: {
      postList: "ul#posts",
      commentToggleLink: "a.comment-toggle",
      modalWindow: "#modal-window",
      modalCloseButton: "#modal-window-close"
    }
  },

  index: function() {
    this.$postList;
    this.$commentToggleLink;
    this.$modalWindow;
    this.$modalCloseButton;
  }
});
```

#### Events

Another common piece of boilerplate code is registering for events on `jQuery` wrapped elements. You know, the meat and potatoes of js development. JSkit has a novel way of tidying up event registration as well. An action's elements can be wired up to event handler functions (defined on the controller) by adding them to the element key's value as an array (tuple):

```js
// app/assets/controllers/posts_controller.js
App.createController("Posts", {
  elements: {
    index: {
      launchModalButton: ["#launch-modal", { click: "openModalWindow" }],
      modalCloseButton: ["#modal-window-close", { click: "closeModalWindow" }]
    }
  },

  openModalWindow: function() {
    this.$modalWindow.removeClass("hidden");
  },

  closeModalWindow: function() {
    this.$modalWindow.addClass("hidden");
  }
});
```

This is a simple way reduce some of the repetetive code in your everyday JavaScript. It's also tested in JSkit itself, so you don't need to test that the events were registered properly.

_Note: if you are not doing anything else in an action but wiring elements and events, you can skip adding the action to the `actions` array, and creating a function for that action._

##### Multiple Events

It is also possible to register multiple events on a given element, to do so simply add event keys to the event object for the given action:

```js
// app/assets/javscripts/controllers/posts_controller.js
App.createController("Posts", {
  elements: {
    index: {
      nameField: ["input#name", {
        change: "handleNameFieldChange",
        keyup: "handleNameFieldKeyup"
      }]
    }
  },

  handleNameFieldChange: function(evnt) {
    // handle name field change
  },

  handleNameFieldKeyup: function(evnt) {
    // handle name field keyup
  }
});
```

Configuration
-------------

At this point, RailsJskit only has one setting, the `app_namespace`. If you're fine with the default namespace of `App`, you don't need to change it. Otherwise create an initializer:

```ruby
# config/initializers/rails_jskit.rb
RailsJskit.configure do |config|
  config.app_namespace = "MyApp"
end
```

Now you can refer to your application globally as `MyApp`.

```js
// app/assets/javascripts/controllers/application_controller.js
MyApp.createController("Posts", {...});
```

Testing
-------

One of the main advantages of RailsJSkit is that it provides a simple structure that's easily tested. There are however, a few things you need to keep in mind while testing JSkit controllers.

When testing, it's important to use the [Controller Factories](#controller-factories) to create your test subjects. This ensures that you always have a fresh version of the controller that has not been mutated by previous tests. A basic jasmine/mocha style JSkit controller test looks something like this:

```js
// spec/javscripts/controllers/posts_controller_spec.js
describe("PostsController", function() {
  var subject;
  beforeEach(function() {
    subject = App.PostsController.create();// creates a fresh controller
  });

  describe("#index", function() {
    it("has tests", function() {
      expect(true).to.equal(true);
    });
  });
});
```

### Testing Actions

Testing actions is straight-forward, since they are just functions on your controller object, you can simply call them and test their behavior:

```js
// app/assets/javscripts/controller/posts_controller.js
App.createController("Posts", {
  actions: ["index"],

  elements: {
    index: {
      pageContainer: "#container",
    }
  },

  index: function(color) {
    this.color = color;
    this.$pageContainer.css("background-color", this.color);
  }
});
```

```js
// spec/javscripts/controllers/posts_controller_spec.js
describe("PostsController", function() {
  var subject;
  beforeEach(function() {
    subject = App.PostsController.create();
  });

  describe("#index", function() {
    it("sets the color variable with the given value", function() {
      subject.index("#FF0000");
      expect(subject.color).to.equal("#FF0000");
    });

    it("changes the page background color to the given color", function() {
      subject.index("#FF0000");
      expect(subject.$pageContainer.css("background-color")).to.equal("#FF0000");
    });
  });
});
```

Obviously this is a contrived example but you can see that testing an action is as simple as testing a function.

### Testing Elements

While you don't have to test the functionality of JSkit itself, you may want to assert that a certain action has access to a given element. To do this we can simply test the values in the elements object, without having to add fixtures to the test DOM:

```js
// spec/javscripts/controllers/posts_controller_spec.js
describe("PostsController", function() {
  var subject;
  beforeEach(function() {
    subject = App.PostsController.create();
  });

  describe("#index", function() {
    describe("elements", function() {
      it("saves a reference to the #container element", function() {
        expect(subject.elements.index.pageContainer).to.equal("#container");
      });
    });
  });
});
```

### Testing Events

Testing events is just as easy as testing elements:

```js
// app/assets/javscripts/controllers/posts_controller.js
App.createController("Posts", {
  elements: {
    index: {
      expandCommentsButton: ["#expand-comments", {
        click: "handleExpandCommentsClick"
      }]
    }
  },

  handleExpandCommentsClick: function() {
    ...
  }
});
```

```js
// spec/javscripts/controllers/posts_controller_spec.js
describe("PostsController", function() {
  var subject;
  beforeEach(function() {
    subject = App.PostsController.create();
  });

  describe("#index", function() {
    describe("events", function() {
      it("wires up `handleExpandCommentsClick` on click of the $expandCommentsButton", function() {
        expect(subject.events.index.expandCommentsButton[1].click).to.equal("handleExpandCommentsClick");
      });
    });
  });
});
```
