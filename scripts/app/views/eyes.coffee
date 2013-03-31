#Filename: apps/views/eye.coffee

define([
  'jqueryui', 'underscore', 'backbone', 'app/views/eye'
], ($, _, Backbone, EyeView) ->
  class EyesView extends Backbone.View
    initialize: ->
      @collection.on('add', @addEye, @)
      @collection.on('reset', @addAll, @)

    addEye: (eye) ->
      ''' Create a view for an eye model. '''
      eyeView = new EyeView({model: eye})
      eyeView.render()
      @$el.append eyeView.el

    addAll: ->
      @$el.empty()
      ''' Create view and call render() for all the items in the list '''
      @collection.forEach(@addEye, @)

    render: ->
      @addAll()
)
