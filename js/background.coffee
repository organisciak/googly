callScriptOrLoad = (tabid = null, request_type="exists") ->
    resp = null
    try
        chrome.tabs.sendMessage(tabid, {type: request_type}, (response) ->
            resp = response
            console.log "Message response"
            console.log response 
            if typeof(response) is "undefined"
                loadEyes(tabid)
            else if response.status is "success"
                console.log "Successfully performed: #{response.action}"
        )
    catch error
        console.log err
    
loadEyes = (tabid = null) ->
    chrome.tabs.insertCSS(
        tabid
        {file:"css/googly.css"}
        )
    chrome.tabs.executeScript(
        tabid, 
        {file: "js/lib/jquery-1.8.3.js"},
        () ->
          chrome.tabs.executeScript(
            tabid,
            {file:"js/lib/jquery-ui-1.9.2.custom.min.js"},
            () ->
              chrome.tabs.executeScript(
                tabid,
                {file:"js/lib/json2.js"},
                () ->
                  chrome.tabs.executeScript(
                    tabid,
                    {file:"js/lib/underscore-min.js"},
                    () ->
                      chrome.tabs.executeScript(
                        tabid,
                        {file:"js/lib/backbone-min.js"},
                        () ->
                          chrome.tabs.executeScript(
                            tabid,
                            {file: "js/googly.js"},
                            () ->
                              console.log "Sending test message to #{tabid}"
                              return true
                          )
                      )
                  )
              )
          )
    )

#Called when the user clicks on the browser action.
chrome.browserAction.onClicked.addListener( (tab) ->
    #Find current tab id
    chrome.tabs.query({active:true,currentWindow:true}, (tabs) ->
        for tab in tabs
            callScriptOrLoad(tab.id, "add")
    )
)
    
#Watch for sites that have eyes
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) ->
    #Check if data exists for url
    chrome.storage.local.get(tab.url, (data) ->
        if typeof(data[tab.url]) isnt "undefined" and data[tab.url].length isnt 0
            console.log "There's data for #{tab.url}!"
            ## Either Alert with page action...
            ## ...
            ## Or auto-load
            callScriptOrLoad(tab.id)
        )
    return true
)

#Listen for messages from pages
chrome.extension.onMessage.addListener( (request, sender, sendResponse) ->
    if request.task is "save"
        save_input = {}
        save_input[sender.tab.url] = request.data
        console.log "Save request from #{sender.tab.url}"
        chrome.storage.local.set(
            save_input, 
            () ->
                sendResponse({status:"success"})
                return true
        )
    if request.task is "load"
        key = sender.tab.url
        console.log "Load request from #{key}"
        chrome.storage.local.get(
            key, 
            (data) ->
                resp = data[key]
                console.log 'Loading...'
                sendResponse({status:"success", data:resp})
                return true
        )
    return true
  )
