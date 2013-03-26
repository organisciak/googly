$ = jQuery

### Page ###
class PageView extends Backbone.View
  el: 'body'

  initialize: ->
    _.bindAll @
    @collection = new EyeList
    @render()

  render: ->
    ''' $el is a cached JQuery object, to avoid rewrapping '''
    @$el.prepend '<div class="pageView" style="border:solid 1px">Eye Container</div>'
  
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
    $("div.pageView").append item_view.render().el

### Create Eyeball ###
class EyeList extends Backbone.Collection
  model: Eye

  initialize: ->
    @on('remove', @hideModel, @)

  hideModel: (eye) ->
    eye.trigger 'hide'


class EyeListView extends Backbone.View
  initialize: ->
    @collection.on('add', @addEye, @)
    @collection.on('reset', @addAll, @)

  addEye: (eye) ->
    ''' Create a view for an eye model. '''
    eyeView = new EyeView({model: eye})
    eyeView.render()
    @$el.append eyeView.el

  addAll: ->
    @$el.html("")
    ''' Create view and call render() for all the items in the list '''
    @collection.forEach(@addEye, @)

  render: ->
    @addAll()


class EyeView extends Backbone.View
  tagName: 'div'
  className: 'eye'
  template: _.template('<div class="pupil"></div>')
  events:
    'click': 'movepupil',
    'dblclick': 'newEye'

  initialize: ->
    _.bindAll @

    # @model.bind 'change', @render
    # @model.bind 'remove', @remove
    # Event Bindings
    console.log @model
    @model.on('change', @render, @)
    @model.on('destroy', @remove, @)
    @model.on('hide', @remove, @)

  render: =>
    @$el.html @template(@model.toJSON)
    console.log "rendering"

  remove: =>
    @$el.remove()

  movepupil: (e) =>
    '''Placeholder for click event'''
    console.log(@model.get('title'))

  newEye: (e) =>
    ''' Placeholder for doubleclick event'''
    return

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
  #canvas = new PageView
  #canvas.addItem()
  eyeList = new EyeList()
  eyeListView = new EyeListView({collection: eyeList})
  
  eye = new Eye({title:"Hello"})
  eyeList.add(eye)
  
  eye = new Eye({title:"World"})
  eyeList.add(eye)

  eyeListView.render()
  eyeListView.render()
  console.log eyeList.toJSON()
  $('body').prepend(eyeListView.el)

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
    

