#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Dock & Menu Bar
# @raycast.mode compact

# Documentation:
# @raycast.description Toggle Dock & Menu Bar (Hide/Unhide)
# @raycast.author zdk
# @raycast.authorURL https://raycast.com/codegangsta

tell application "System Events"
  # Dock
  tell dock preferences to set autohide to not autohide
  # Menu Bar
  tell dock preferences to set autohide menu bar to not autohide menu bar
end tell
