tell application "Calendar"
    tell calendar "Class"
        show(first event where its summary = "COMP1531 Lecture")
    end tell
end tell