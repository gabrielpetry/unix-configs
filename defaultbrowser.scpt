on run argv
	do shell script "defaultbrowser " & item 1 of argv
	try
		tell application "System Events"
			tell application process "CoreServicesUIAgent"
				tell window 1
					tell (first button whose name starts with "Use")
						perform action "AXPress"
					end tell
				end tell
			end tell
		end tell
	on error errMsg
	    display dialog "ERROR: " & errMsg
	end try
end run
