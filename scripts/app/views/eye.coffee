#Filename: apps/views/eye.coffee

define([
  'jqueryui', 'underscore', 'backbone'
], ($, _, Backbone) ->
  class EyesView extends Backbone.View
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


)
