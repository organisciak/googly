$ = jQuery

### Page ###
class PageView extends Backbone.View
  el: 'body'

  initialize: ->
    _.bindAll @

    @collection = new EyeList
    # Bind this view's @appendItem to the collection's @add
    @collection.bind 'add', @appendItem

    @render()

  render: ->
    ''' $el is a cached JQuery object, to avoid rewrapping '''
    @$el.prepend '<div style="border:solid 1px">Eye Container</div>'
  
  addItem: ->
    '''
    Creates an eye model and passes to the rendering method.
    '''
    eye = new Eye
    @collection.add eye

  appendItem: (eye) ->
    '''
    Creates a view of an eye model.
    '''
    eye_view = new EyeView(model:eye)
    @$el.append item_view.render().el

### Create Eyeball ###
class EyeList extends Backbone.Collection
  model: Eye

class EyeView extends Backbone.View
  el: $ 'body'

  initialize: ->
    _.bindAll @

    @model.bind 'change', @render
    @model.bind 'remove', @unrender
  
  render: ->
    @$el.prepend("<div class='eye'>")

class Eye extends Backbone.Model

  defaults:
    size: 40
    position:
      eye:
        left: 40
        top:40
      pupil:
        left:0
        top:0

### Constancy functions ###

$ ->
  canvas = new PageView
  #eye = new EyeView()
  '''eye = Eye()
  view = EyeView model:eye

  a = [{
      size: 60
      eye: {
          zIndex:3
          left:334
          top:156
      }
      pupil: {
          left:1
          top:1
      }
  }
  ]'''
    

