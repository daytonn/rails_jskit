//= require jskit_rails

App.createController("Pages", {
  actions: ['index'],

  index: function(data) {
    console.log(arguments);
  }
});
