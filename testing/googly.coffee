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
	constructor: (@parent) ->
		that = this
		this.item = $("<div class='eye'>")
		p = $("<div class='pupil'>")
		this.item
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
				googly_storage.add (new Eye $("body") )
			.append(p)
			.prependTo(@parent)
		this.size(40).position(40,40)
		console.log 'added eye'
		
	size: (x) ->
		that = this.item
		borderWidth = 1 + x/10
		that
			.css("width", x)
			.css("height", x)
			.css("border-radius", x)
			.css("border-width", borderWidth)
			.css("margin", -x)
		
		#Pupil Sizing	
		that.children(".pupil")
			.css("width", x/2)
			.css("height", x/2)
			.css("border-radius", x/2)
			
		#Inverse margins so element doesn't take up any space in parent
		this

	position: (left, top) ->
		that = this.item
		that
			.css("left", left)
			.css("top", top)
		this
		
	export: ->
		### Return object representation of this eye's data ###
		eye = this.item
		pupil = eye.children(".pupil")
		a = {
			size: eye.width(),
			eye: {
				left: eye.css("left"),
				top: eye.css("top")
			},
			pupil: {
				left: pupil.css("margin-left"),
				top: pupil.css("margin-top")
			}
		}
		a
	
	
	pupil: (left, top, speed = 300) ->
		### Takes a number from 0 to 1, referring 
		to the left to right and top to bottom position
		of the pupil
		###
		that = this.item
		psizeDiff = that.innerWidth()-that.children(".pupil").outerWidth()
		that.children(".pupil")
			.animate(
					{"margin-left":psizeDiff*left,
					"margin-top":psizeDiff*top
					},
					speed
				)
		###
		that.children(".pupil")
			.css("margin-left", left)
			.css("margin-top", top)
		###
		
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
			t.size(eye.size)
			t.position(eye.eye.left, eye.eye.top)
			t.pupil(eye.pupil.left, eye.pupil.top, 0)
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
			top:0
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