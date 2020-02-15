# A simple applescript program that gives general statistics regarding 
# specific events in the macOS calendar application

# Handler that converts time in seconds to hours/min/seconds
on convertTime(timeInSec)

    set num to timeInSec as integer
    set sec to 0
    set min to 0
    set hour to 0

    # If time was greater than a minute
    if (num > 59) then
        set sec to num mod 60
        # Removes second component of time
        set num to num / 60 
        set num to round of num rounding down
        # If time was greater than a hour
        if (num > 59) then
            set min to num mod 60
            # Remove minute component of time
            set hour to num / 60
            set hour to round of hour rounding down
        else
            set min to num
        end if
    else
        set sec to num
    end if

    return (hour as string) & " Hours " & (min as string) & " Minutes " & Â
        (sec as string) & " Seconds "
end convertTime

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

# Variable to store total time of events
set totalTime to 0

# Go through events looking for match
repeat with i from 1 to (count summaries)
    if (item i of summaries contains eventName) then
        # Add duration of event to total time
        set duration to item i of endTime - item i of startTime
        set totalTime to totalTime + duration
    end if
end repeat

# Display time
tell application "Finder"
    activate
    if (totalTime = 0) then
        display dialog ("Event does not exist")
    else
        # "my" is needed to access function due to scope
        display dialog("Total time:\n" & (my convertTime(totalTime)))
    end if
end tell 



