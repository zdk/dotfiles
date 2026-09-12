#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Disconnect AnyConnect VPN
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🔓

set processName to "Cisco Secure Client"

tell application processName
	activate
end tell

repeat until application processName is running
	delay 0.2
end repeat

tell application "System Events"
	repeat until (window 2 of process processName exists)
		delay 0.2
	end repeat

	tell process processName
		click button 1 of window 2
	end tell
end tell
