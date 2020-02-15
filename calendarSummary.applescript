# A simple applescript program that gives general statistics regarding 
# specific events in the macOS calendar application

# Get event that user it searching for
tell application "Finder"
    activate
    set eventname to the text returned of Â
        (display dialog "Calendar" default answer "")

end tell

# Locate event in calendar
tell application "Calendar"
    activate
    tell calendar "Class"
        try
            show(first event where its summary = eventname)
        on error
            display dialog ("Event missing")
        end try
        
    end tell
end 

