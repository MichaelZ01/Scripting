# A simple applescript program that gives general statistics regarding 
# specific events in the macOS calendar application

to convertTime(time)

    #set num to time
    #set sec to 0
    #set min to 0
    #set hour to 0

(*
    if (num > 59) then
        set sec to num mod 60
        set num to num / 60
        if (num > 59) then
            set min to num mod 60
            set hour to num / 60
        else
            set min to num
        end if
    else
        set sec to num
    end if
*)
    #return (hour as string) & ":" & (min as string) & ":" & (sec as string)

    return time

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
    if (totalTime = 0) then
        display dialog ("Event does not exist")
    else
        #set hmsTime to convertTime(totalTime)
        display dialog("Total time: " & totalTime)
    end if
end tell 



