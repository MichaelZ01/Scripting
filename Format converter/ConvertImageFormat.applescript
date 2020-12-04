property formats : {"JPEG", "PDF"}

-- Get Images
set theImageFile to choose file of type "public.image" with prompt "Select image" with multiple selections allowed without invisibles

convertImages(theImageFile)

-- Convert images to chosen format
on convertImages(theImageFile)
	set newType to choose from list formats with prompt "Choose format" without multiple selections allowed
	set newType to newType as text
	repeat with anItem in theImageFile
		tell application "Finder"
			set theType to file type of anItem
			set theExt to name extension of anItem
			set theName to displayed name of anItem
		end tell
		display dialog (theType as text) & (theExt as text) & (theName as text)
		convertImage(anItem, newType)
	end repeat
end convertImages

on convertImage(theItem, theType)
	-- Set output folder, default is desktop
	set theOutputFolder to (path to desktop folder as string)
	
	tell application "Image Events"
		launch
		
		set theImage to open theItem
		tell theImage
			if theType is "JPEG" then
				save as JPEG in (theOutputFolder & "temp-conversion-output.jpg")
			else if theType is "PDF" then
				-- save as PDF in (theOutputFolder & "temp-conversion-output.pdf")
				display dialog "PDF created"
			end if
		end tell
	end tell
end convertImage
