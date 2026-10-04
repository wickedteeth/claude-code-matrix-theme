-- Usage: osascript set-terminal-profile.applescript <tty> <profile> [only-if-current]
-- Switches the Terminal.app tab on <tty> to <profile> (or to the default profile when
-- <profile> is "default"); prints the previous profile name. With [only-if-current],
-- switches only when the tab is currently on that profile.
on run argv
	set ttyName to item 1 of argv
	set profileName to item 2 of argv
	set onlyIf to ""
	if (count of argv) > 2 then set onlyIf to item 3 of argv
	tell application "Terminal"
		repeat with w in windows
			repeat with t in tabs of w
				if tty of t is ttyName then
					set prevName to name of current settings of t
					if onlyIf is not "" and prevName is not onlyIf then return prevName
					if profileName is "default" then
						set current settings of t to default settings
					else
						set current settings of t to settings set profileName
					end if
					return prevName
				end if
			end repeat
		end repeat
	end tell
	return ""
end run
