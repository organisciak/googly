#Filename: scripts/app/collections/eyes.coffee

define([
  'jqueryui', 'underscore', 'backbone'
], ($, _, Backbone) ->
  class Eye extends Backbone.Model
    defaults:
      size: 40
      eyeLeft: 40
      eyeTop: 40
      pupilLeft: 0
      pupilTop: 0

    # Reminder: the last element in coffeescript is returned 
    # (i.e. the class above)
)


