//= require rails_jskit

App.createController("Pages", {
  actions: ['index'],

  index: function(data) {
    console.log(arguments);
  }
});
