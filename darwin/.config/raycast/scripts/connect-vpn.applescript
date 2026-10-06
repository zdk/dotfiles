#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Connect AnyConnect VPN
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🔐

set profileName to "Otter-General"
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
		set value of combo box 1 of window 2 to profileName
		click button 1 of window 2
	end tell
end tell
