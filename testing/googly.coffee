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
			console.log "MOUSE OFFSETY #{ e.offsetY }"
			esize = $(this).outerWidth()
			console.log "ESIZE #{ esize }"
			psizeDiff = $(this).innerWidth()-$(this).children(".pupil").outerWidth()
			console.log "PSIZE #{ psizeDiff }"
			offsetX = psizeDiff*e.offsetX/esize
			offsetY = psizeDiff*e.offsetY/esize
			console.log "PUPIL OFFSETY #{ offsetY }"
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