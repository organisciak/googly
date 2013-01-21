$ = jQuery

### Create Trash ###
class Trash
	draw: ->
		$("<div class='trash'>")
			.html("This is the trash")
			.hide()
			.prependTo("body")

	show: ->
		$(".trash").slideDown("fast")
	hide: ->
		$(".trash").slideUp()
	delete: ->
		return

trash = new Trash

### Create Eyeball ###

class Eye
	_properties:
		size: 40
		eye:
			left: 40
			top: 40
		pupil:
			left: 0
			top: 0

	constructor: (@parent) ->
		that = this
		@item = $("<div class='eye'>")
		p = $("<div class='pupil'>")
		@item
			.resizable({ 
				autoHide: true
				aspectRatio: true
				resize: ( event, ui ) ->
					that.size ui.size.width
				handles: "ne, se, sw, nw"
			})
			.draggable({
				stack:	'.eye'
				#snap: '.trash'
				snapMode: 'inner'
				start: -> trash.show()
				stop: -> trash.hide()
				})
			.click (e) ->
				esize = $(this).outerWidth()
				that.pupil(e.offsetX/esize, e.offsetY/esize)
			.dblclick (e) ->
				googly_storage.add new Eye $("body")
			.append(p)
			.prependTo(@parent)
		this
			.position(@_properties.eye.left, @_properties.eye.top)
			.size(@_properties.size)
		console.log 'added eye'
		console.log @_properties
		
	size: (x, speed = 0) ->
		@_properties.size = x
		that = @item
		borderWidth = 1 + x/10
		that
			.animate({
					"width": x
					"height": x
					"border-radius": x
					"border-width": borderWidth
					"margin" : -x
					},
					speed
			)
		
		#Pupil Sizing	
		that.children(".pupil")
			.css("width", x/2)
			.css("height", x/2)
			.css("border-radius", x/2)
		
		#Pupil position
		@pupil(@_properties.pupil.left, @_properties.pupil.top, 0)
			
		#Inverse margins so element doesn't take up any space in parent
		@

	position: (left, top, speed = 0) ->
		@_properties.eye.left = left
		@_properties.eye.top = top
		that = @item
		that
			.animate({
			"left":left
			"top": top
			},
			speed)
		@
		
	export: ->
		### Return object representation of this eye's data ###
		@_properties
	
	pupil: (left, top, speed = 300) ->
		### Pupil position
		Takes a number from 0 to 1, referring 
		to the left to right and top to bottom position
		of the pupil
		###
		@_properties.pupil.left = left
		@_properties.pupil.top = top
		that = this.item
		psizeDiff = that.innerWidth()-that.children(".pupil").outerWidth()
		that.children(".pupil")
			.animate(
					{"margin-left":psizeDiff*left,
					"margin-top":psizeDiff*top
					},
					speed
				)
		@
		
### Constancy functions ###
class Storage
	constructor: (@list =[]) ->
	
	add: (item) ->
		@list.push(item)
		
	save: () ->
		console.log (eye.export() for eye in @list)
		
	load: (eye_data) ->
		for eye in eye_data
			console.log eye
			t = new Eye $("body")
			t
				.size(eye.size)
				.position(eye.eye.left, eye.eye.top)
				.pupil(eye.pupil.left, eye.pupil.top, 0)
			this.add t
		return
		
	delete: ->
		return
		
$ ->
	trash.draw()
	window.googly_storage = new Storage
	storage = googly_storage
	storage.add new Eye($("body"))
	
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
	},{
		size: 30
		eye: {
			zIndex:3
			left:30
			top:60
		}
		pupil: {
			left:0.5
			top:0
		}
	}
	]
	
	storage.load a
	console.log storage.list
	storage.save()