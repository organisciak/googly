$ = jQuery

App = new (Backbone.View.extend({
  Models:{}
  Views:{}
  Collections:{}
  events: {}
  start: ->
    eyeList = new App.Collections.Eyes()
    eyeListView = new App.Views.EyeList({collection: eyeList})

    eye = new App.Models.Eye({title:"Hello"})
    eyeList.add(eye)
    
    eye = new App.Models.Eye({title:"World", size:80})
    eyeList.add(eye)

    eyeListView.render()
    console.log eyeList.toJSON()
    $('body').prepend(eyeListView.el)
}))({el: document.body})

### Page ###
class App.Views.Page extends Backbone.View
  el: 'body'

  initialize: ->
    _.bindAll @
    @collection = new App.Collections.Eyes
    @render()

  render: ->
    ''' $el is a cached JQuery object, to avoid rewrapping '''
    @$el.prepend '<div class="pageView" style="border:solid 1px">Eye Container</div>'
  
  addItem: ->
    '''
    Creates an eye model and passes to the rendering method.
    '''
    eye = new App.Models.Eye
    @collection.add eye

  appendItem: (eye) ->
    '''
    Creates a view of an eye model.
    '''
    eye_view = new App.Views.Eye(model:eye)
    $("div.pageView").append item_view.render().el

### Create Eyeball ###
class App.Collections.Eyes extends Backbone.Collection
  model: App.Models.Eye

  initialize: ->
    @on('remove', @hideModel, @)

  hideModel: (eye) ->
    eye.trigger 'hide'


class App.Views.EyeList extends Backbone.View
  initialize: ->
    @collection.on('add', @addEye, @)
    @collection.on('reset', @addAll, @)

  addEye: (eye) ->
    ''' Create a view for an eye model. '''
    eyeView = new App.Views.Eye({model: eye})
    eyeView.render()
    @$el.append eyeView.el

  addAll: ->
    @$el.empty()
    ''' Create view and call render() for all the items in the list '''
    @collection.forEach(@addEye, @)

  render: ->
    @addAll()

class App.Views.Eye extends Backbone.View
  tagName: 'div'
  className: 'eye'
  # Pro-tip: model.escape is better than model.get in templates, to avoid XSS
  template: _.template('<div class="pupil"></div>')
  events:
    'change': (e) -> console.log(e)
    'click': (e) ->
      esize = @$el.outerWidth()
      @model.set({'pupilLeft':e.offsetX/esize, 'pupilTop': e.offsetY/esize})
    'dblclick': 'newEye'
    'drag': 'drag'
    'dragstop': 'dragStop'
    'resizestop': (e, ui) ->
      console.log e
      # Save object
      @model.set({'size' : ui.size.width})
    'resize': (e, ui) ->
      e.preventDefault()
      # TODO: setting the size turns on the pupil animation, which
      # is run hundreds of times...
      @model.set({'size' : ui.size.width})

  initialize: ->
    _.bindAll @

    # Event Bindings
    #@model.on('change', @render, @)
    @model.on('change:pupilLeft change:pupilTop', @movePupil, @)
    #@model.on('change:eyeLeft change:eyeTop', @renderPosition, @)
    @model.on('change:size', @renderSize, @)
    @model.on('destroy', @remove, @)
    @model.on('hide', @remove, @)

    # UI Interaction, apply only once, on initialize
    
  render: =>
    @$el
      .html(@template(@model.attributes))
      .resizable({
        autoHide: true
        aspectRatio: true
        animate: false
        #ghost: true
        handles: "ne, se, sw, nw"
      })
      .draggable({
        #stack:  '.eye'
        zIndex: 1200
        #snap: '.trash'
        snapMode: 'inner'
        #start: -> trash.show()
      })

    # Positioning and size
    @renderPosition(0)
    @movePupil(0)
    @renderSize()

  remove: =>
    @$el.remove()

  renderSize: (speed = 0) =>
    size = @model.get('size')
    borderWidth = 1 + size / 10
    @$el
      .css("width", size)
      .css("height", size)
      .css('border-radius', size)
      .css('border-width', borderWidth)
      #"margin": -size
    
    @$el.children(".pupil")
    # Pupil Size
      .css("width", size * 2 / 3)
      .css("height", size * 2 / 3)
      .css("border-radius", size * 2 / 3)
    # Pupil Position
    @movePupil(0)

    #Pupil position
    # @pupilPosition(@model.get('pupilLeft'), @model.get('pupilTop'), 0)
    
    #Bounding box Size
    ###that.children(".bounding-box")
        .css("width", that.innerWidth() )
        .css("height", that.innerWidth() )
        .css("top", -borderWidth/2)
        .css("left", -borderWidth/2)###
        
    #Inverse margins so element doesn't take up any space in parent
    @

  movePupil: (speed = 0) =>
    ### Move pupil to position set in model attributes 'pupilLeft' and
    # 'pupilTop'
    ###
    [left, top] = [@model.get('pupilLeft'), @model.get('pupilTop')]
    psizeDiff = @$el.innerWidth()-@$el.children(".pupil").outerWidth()
    @$el.children(".pupil")
      .animate(
        {
        "margin-left": psizeDiff * left
        "margin-top": psizeDiff * top
        },
        speed
      )
    @

  renderPosition: (speed = 0) =>
    @$el
      .animate({
      "left": @model.get("eyeLeft")
      "top": @model.get("eyeTop")
      },
      speed)
    @

  drag: (e, ui) =>
    #console.log e#"TODO: Drag event"
    #Check for overlap with trash
    #t_bord = trash.borders()
    #if (t_bord.top < ui.position.top < t_bord.bottom) and (t_bord.left < ui.position.left < t_bord.right)
    #  console.log("Delete?")
    #  $(this).css("opacity", 0.6)
    #else
    #  $(this).css("opacity", 1)

  dragStop: (e, ui) =>
    #console.log e #"TODO: Drag stop"
    #t_bord = trash.borders()
    #if (t_bord.top < ui.position.top < t_bord.bottom) and (t_bord.left < ui.position.left < t_bord.right)
    #  that.delete()
    #else
    #  {top:that._properties.eye.top, left:that._properties.eye.left} = ui.position
    #trash.hide()
    #googly_storage.save()

  newEye: (e) =>
    ''' Placeholder for doubleclick event'''
    console.log "TODO: New Eye event"

class App.Models.Eye extends Backbone.Model

defaults:
  size: 40
  eyeLeft: 40
  eyeTop: 40
  pupilLeft: 0
  pupilTop: 0

### Constancy functions ###

$ ->
  App.start()

  '''eye = App.Models.Eye()
  view = App.Views.Eye model:eye

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
    

