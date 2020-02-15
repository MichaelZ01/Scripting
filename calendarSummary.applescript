# A simple applescript program that gives general statistics regarding 
# specific events in the macOS calendar application

# Get event that user it searching for
tell application "Finder"

    activate
    set eventName to the text returned of Â
        (display dialog "Calendar" default answer "")
end tell

# Copy event data from calendar into applescript
tell application "Calendar"

    set {summaries, UIDs, startTime, endTime} to Â
        {summary, uid, start date, end date} of events of calendar "Class"
end tell

set totalTime to 0

repeat with i from 1 to (count summaries)
    if (item i of summaries contains eventName) then
        set duration to item i of endTime - item i of startTime
        set totalTime to totalTime + duration
    end if
end repeat

tell application "Finder"
    if (totalTime = 0) then
        display dialog ("Event does not exist")
    else
        display dialog("Total time: " & (totalTime as string))
    end if
end tell 



