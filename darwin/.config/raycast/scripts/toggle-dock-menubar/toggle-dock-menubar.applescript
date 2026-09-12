#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Dock & Menu Bar (Hide/Unhide)
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName ToggleDockMenuBar

# Documentation:
# @raycast.description Toggle Dock & Menu Bar (Hide/Unhide)
# @raycast.author Warachet Samtalee
# @raycast.authorURL https://github.com/zdk

log "Toggle Dock & Menu Bar"

tell application "System Events"
    # Toggle Dock
    tell dock preferences
        set autohide to not autohide
    end tell

    # Toggle Menu Bar
    tell menu bar preferences
        set autohide to not autohide
    end tell
end tell
