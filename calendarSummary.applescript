# A simple applescript program that gives general statistics regarding 
# specific events in the macOS calendar application

tell application "Finder"
    activate
    set eventname to the text returned of Â
        (display dialog "Calendar" default answer "" buttons {"Search"})

end tell

tell application "Calendar"
    tell calendar "Class"
        show(first event where its summary = eventname)
    end tell
end 

