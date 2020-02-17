# A simple applescript program that gives the total time of events contining
# a specific phrase in a calendar

# Handler that converts time in seconds to hours/min/seconds
on convertTime(timeInSec)

    set sec to 0
    set min to 0
    set hour to 0

    # If time was greater than a minute
    if (timeInSec > 59) then
        set sec to timeInSec mod 60
        # Removes second component of time
        set timeInSec to timeInSec / 60 
        set timeInSec to round of timeInSec rounding down
        # If time was greater than a hour
        if (timeInSec > 59) then
            set min to timeInSec mod 60
            # Remove minute component of time
            set hour to timeInSec / 60
            set hour to round of hour rounding down
        else
            set min to timeInSec
        end if
    else
        set sec to timeInSec
    end if

    return (hour as string) & " Hours " & (min as string) & " Minutes " & Â
        (sec as string) & " Seconds "
end convertTime

# Get key phrase from user
tell application "Finder"

    activate
    set eventName to the text returned of Â
        (display dialog "Enter event:" default answer "" Â
        with title "calendarSummary" Â
        with icon note Â
        buttons {"Search"} Â
        default button 1)
end tell

# Copy event data from calendar into applescript
tell application "Calendar"

    # "Class" is the name of the calendar you are searching through, change to
    # what ever your calendar is called
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
        display dialog("Total time:\n" & my convertTime(totalTime))
    end if
end tell 



