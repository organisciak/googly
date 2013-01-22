#Called when the user clicks on the browser action.
console.log "test"
chrome.browserAction.onClicked.addListener( (tab) ->
	console.log "button pushed"
	chrome.tabs.insertCSS(
		null
		{file:"css/googly.css"}
		)
	chrome.tabs.executeScript(
		null, 
		{file: "js/inject.js"}
		#{code: "alert('success')"}
		)
	console.log "after execute script"
	)
#chrome.browserAction.setBadgeBackgroundColor({color:[0, 200, 0, 100]});
#chrome.browserAction.setBadgeText({text:"Eyes"});