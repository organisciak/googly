#Filename: scripts/app/collections/eyes.coffee

define([
  'jqueryui', 'underscore', 'backbone', 'app/models/eye'
], ($, _, Backbone, Eye) ->
  ### Create Eyeball ###
  class Eyes extends Backbone.Collection
    model: Eye

    initialize: ->
      @on('remove', @hideModel, @)

    hideModel: (eye) ->
      eye.trigger 'hide'

  # Reminder: the last element in coffeescript is returned 
  # (i.e. the class above)
)
