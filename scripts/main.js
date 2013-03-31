// Filename: main.js

// Require.js allows us to configure shortcut alias
// There usage will become more apparent further along in the tutorial.
require.config({
  paths: {
    jquery: 'lib/jquery-1.8.3',
    jqueryui: 'lib/jquery-ui-1.9.2.custom',
    underscore: 'lib/underscore',
    backbone: 'lib/backbone',
    'coffee-script': 'lib/coffee-script'
  },
  shim: {
       'jqueryui': {
            exports: '$',
            deps: ['jquery']
        },
        'underscore': {
            exports: '_'
        },
        'backbone': {
            exports: 'Backbone',
            deps: ['underscore', 'jquery']
        }
  }

});

require(['cs!app'], function(App) {
  // The "app" dependency is passed in as "App"
  App.start();
});
