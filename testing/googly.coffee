$ = jQuery

### Create Eyeball ###
eye = (parent) ->
	e = $("<div class='eye'>")
	p = $("<div class='pupil'>")
	
	e.append(p).prependTo(parent)



$ ->
	eye $("body")
	
	$( ".eye" )
		.draggable()
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
			$(this).css("background-color", "red")