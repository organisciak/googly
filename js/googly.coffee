$ = jQuery

### Create Trash ###
class Trash
    draw: ->
        t = $("<div class='trash'>")
        t
            .html("This is the trash")
            .hide()
            .prependTo("body")
            
        @element = t
    show: ->
        @element.slideDown("fast")
    hide: ->
        @element.slideUp()
    borders: ->
        {top:top, left:left} = @element.position()
        [bottom, right] = [top+@element.height(), left+@element.width()]
        {"top":top, "left":left, "bottom":bottom, "right":right}
    delete: ->
        return

trash = new Trash

### Create Eyeball ###

class Eye
    constructor: (@parent) ->
        @_properties = 
            size: 40
            eye:
                left: 40+document.body.scrollLeft
                top: 40+document.body.scrollTop
            pupil:
                left: 0
                top: 0
        that = this
        @item = $("<div class='eye'>")
        #b = $("<div class='bounding-box'>")
        p = $("<div class='pupil'>")
        @item
            .resizable({ 
                autoHide: true
                aspectRatio: true
                resize: ( event, ui ) ->
                    that.size ui.size.width
                handles: "ne, se, sw, nw"
                stop: (event, ui ) ->
                    googly_storage.save()
            })
            .draggable({
                #stack:  '.eye'
                zIndex: 1200
                #snap: '.trash'
                snapMode: 'inner'
                start: -> trash.show()
                drag: (event, ui) ->
                    #Check for overlap with trash
                    t_bord = trash.borders()
                    if (t_bord.top < ui.position.top < t_bord.bottom) and (t_bord.left < ui.position.left < t_bord.right)
                        console.log("Delete?")
                        $(this).css("opacity", 0.6)
                    else
                        $(this).css("opacity", 1)
                stop: (event, ui) -> 
                    t_bord = trash.borders()
                    if (t_bord.top < ui.position.top < t_bord.bottom) and (t_bord.left < ui.position.left < t_bord.right)
                        that.delete()
                    else
                        {top:that._properties.eye.top, left:that._properties.eye.left} = ui.position
                    trash.hide()
                    googly_storage.save()
                })
            .click (e) ->
                esize = $(this).outerWidth()
                that.pupil(e.offsetX/esize, e.offsetY/esize)
            .dblclick (e) ->
                googly_storage.add new Eye $("body")
            #.append(b)
            .append(p)
            .prependTo(@parent)
        this
            .position(@_properties.eye.left, @_properties.eye.top)
            .size(@_properties.size)
        
    delete: =>
        console.log "Delete me!"
    
    size: (x, speed = 0) =>
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
            .css("width", x*2/3)
            .css("height", x*2/3)
            .css("border-radius", x*2/3)
        
        #Pupil position
        @pupil(@_properties.pupil.left, @_properties.pupil.top, 0)
        
        #Bounding box Size
        ###that.children(".bounding-box")
            .css("width", that.innerWidth() )
            .css("height", that.innerWidth() )
            .css("top", -borderWidth/2)
            .css("left", -borderWidth/2)###
            
        #Inverse margins so element doesn't take up any space in parent
        @

    position: (left, top, speed = 0) =>
        [@_properties.eye.left,@_properties.eye.top] = [left, top]
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
    
    pupil: (left, top, speed = 300) =>
        ### Pupil position
        Takes a number from 0 to 1, referring 
        to the left to right and top to bottom position
        of the pupil
        ###
        [@_properties.pupil.left,@_properties.pupil.top] = [left, top]
        that = this.item
        psizeDiff = that.innerWidth()-that.children(".pupil").outerWidth()
        that.children(".pupil")
            .animate(
                    {
                    "margin-left": psizeDiff*left
                    "margin-top": psizeDiff*top
                    },
                    speed
                )
        @
        
### Constancy functions ###
class Storage
    constructor: (@type, @list =[]) ->
        @key = window.location.href
    
    add: (item) ->
        @list.push(item)
        
    save: () ->
        data = (eye.export() for eye in @list)
        if @type is "local"
            @save_local(data)
        else if @type is "extension"
            @save_extension(data)
            
    save_local: (data) ->
        str = JSON.stringify data
        localStorage.setItem(@key, str)
        console.log "Saved localStorage key for #{@key}:#{str}"
    
    save_extension: (data) ->
        chrome.extension.sendMessage(
            {task:"save", data:data}, 
            (response) ->
              if response.status is 'success'
                console.log 'Saved to extension storage successfully'
        )

    load: (eye_data = false) ->
        if not eye_data
            if @type is "local"
                eye_data = @load_local()
                @_draw(eye_data)
                console.log "Loaded localStorage key for #{@key}"
            else if @type is "extension"
                @load_extension()
        else
            @_draw(eye_data)
    
    _draw: (eye_data) =>
        if $.isEmptyObject(eye_data)
            console.log "Eye data is empty. Drawing default"
            t = new Eye $("body")
            this.add t
        for eye in eye_data
            console.log eye
            t = new Eye $("body")
            t
                .size(eye.size)
                .position(eye.eye.left, eye.eye.top)
                .pupil(eye.pupil.left, eye.pupil.top, 0)
            this.add t
        @save()
        return
            
    load_extension: (data) ->
        chrome.extension.sendMessage(
            {task:"load"}, 
            (response) =>
              if response.status is "success"
                  @_draw(response.data)
              
        )
    
    load_local: ->
        str = localStorage.getItem(@key)
        JSON.parse str
        
    delete: ->
        return

$ ->
    trash.draw()
    window.googly_storage = new Storage("extension")
    storage = googly_storage
    
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
    
    storage.load(false)
    storage.save()

	chrome.extension.onMessage.addListener( (request, sender, sendResponse) ->
		if request.type is "add"
			googly_storage.add new Eye $("body")
			sendResponse({status:"success", action:"add eye"})
		else if request.type is "exists"
			sendResponse({status:"success", action:"check script injection"})
	  )