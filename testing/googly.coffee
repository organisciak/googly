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
		return
		#$(".trash").slideUp()
	delete: ->
		return

trash = new Trash

### Create Eyeball ###
eye = (parent) ->
	e = $("<div class='eye'>")
	p = $("<div class='pupil'>")
	e
		.draggable({
		stack:	'.eye'
		snap: '.trash'
		snapMode: 'inner'
		start: -> trash.show()
		stop: -> trash.hide()
		})
		.click (e) ->
			w = $(this).outerWidth()
			h = $(this).outerHeight()
			offsetX = 10*e.offsetX/w
			offsetY = 10*e.offsetY/h
			$(this).children(".pupil").animate(
				{"margin-left":offsetX,
				"margin-top":offsetY
				}
			)
		.dblclick (e) ->
			eye $("body")
		.append(p)
		.prependTo(parent)
	
	console.log 'added eye'
	return

$ ->
	trash.draw()
	eye $("body")
	
	###
	$( ".eye" )
		.draggable()

	###