#Filename: app.js

define(['jqueryui', 'underscore', 'backbone',
  'cs!app/collections/eyes',
  'cs!app/views/eyes',
  'cs!app/views/eye',
  'cs!app/models/eye'
  ],
($, _, Backbone, Eyes, EyesView, EyeView, Eye) ->
  App = new (Backbone.View.extend({
    Models:{}
    Views:{}
    Collections:{}
    events: {}
    start: ->
      eyeList = new Eyes()
      eyeListView = new EyesView({collection: eyeList})

      eye = new Eye({title:"Hello"})
      eyeList.add(eye)
      
      eye = new Eye({title:"World", size:80})
      eyeList.add(eye)

      eyeListView.render()
      console.log eyeList.toJSON()
      $('body').prepend(eyeListView.el)
  }))({el: document.body})
  return App
)


