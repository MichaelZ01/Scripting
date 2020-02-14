# A simple applescript program gives general statistics regarding events in
# the macOS calendar application
tell application "Calendar"
    tell calendar "Class"
        show(first event where its summary = "COMP1531 Lecture")
    end tell
end 

display dialog "Hello, world!"