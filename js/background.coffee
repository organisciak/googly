#Called when the user clicks on the browser action.
chrome.browserAction.onClicked.addListener( (tab) ->
    chrome.tabs.insertCSS(
        null
        {file:"css/googly.css"}
        )
    chrome.tabs.executeScript(
        null, 
        {file: "js/inject.js"}
        )
    )

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
  );