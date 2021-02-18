-- Applescript that gives a summary of the events of a range of days.
-- Inspired by post on macscripter.net


on getDateRange()
	set today to (current date)
	
	-- Default date is today
	set d1 to today's short date string
	set d2 to today's short date string
	
	-- Prompt user to choose range
	set dateRange to text returned of (display dialog "Enter the range:" default answer d1 & " - " & d2)
	
	-- Extracts start and end time from prompt input
	set startDate to date (text from word 1 to word 3 of dateRange)
	set endDate to date (text from word -3 to word -1 of dateRange)
	
	-- Sets the last date's time to the last second of the range
	set endDate's time to days - 1
	
	return {startDate, endDate}
end getDateRange

-- Returns the events that are in the given date range
on filterToDateRange(eventDates, eventSummaries, calendarNames, startDate, endDate)
	
	script o
		property sDates : eventDates
		property summaries : eventSummaries
		property cNames : calendarNames
		property filteredData : {}
	end script
	
	repeat with i from 1 to (count calendarNames)
		set o's sDates to item i of eventDates
		set o's summaries to item i of eventSummaries
		set thisCalendarName to item i of calendarNames
		repeat with j from 1 to (count o's sDates)
			set thisStartDate to item j of o's sDates
			if (not ((thisStartDate comes before startDate) or (thisStartDate comes after endDate))) then
				set thisSummary to item j of o's summaries
				set end of o's filteredData to {thisStartDate, thisSummary, thisCalendarName}
			end if
		end repeat
	end repeat
	
	return o's filteredData
end filterToDateRange

-- Sort the events by date
on sortByDate(filteredData)
	
	script custom
		on isGreater(a, b)
			return (beginning of a > beginning of b)
		end isGreater
	end script
	
	CustomShellSort(filteredData, 1, -1, {comparer:custom})
end sortByDate

-- Implementation of shell sort. Found on macscripter by Nigel Garvey
on CustomShellSort(theList, l, r, customiser)
	script o
		property comparer : me
		property slave : me
		property lst : theList
		
		on shsrt(l, r)
			set step to (r - l + 1) div 2
			repeat while (step > 0)
				slave's setStep(step)
				repeat with j from (l + step) to r
					set v to item j of o's lst
					repeat with i from (j - step) to l by -step
						tell item i of o's lst
							if (comparer's isGreater(it, v)) then
								set item (i + step) of o's lst to it
							else
								set i to i + step
								exit repeat
							end if
						end tell
					end repeat
					set item i of o's lst to v
					slave's rotate(i, j)
				end repeat
				set step to (step / 2.2) as integer
			end repeat
		end shsrt
		
		-- Default comparison and slave handlers for an ordinary sort.
		on isGreater(a, b)
			(a > b)
		end isGreater
		
		on rotate(a, b)
		end rotate
		
		on setStep(a)
		end setStep
	end script
	
	-- Process the input parameters.
	set listLen to (count theList)
	if (listLen > 1) then
		-- Negative and/or transposed range indices.
		if (l < 0) then set l to listLen + l + 1
		if (r < 0) then set r to listLen + r + 1
		if (l > r) then set {l, r} to {r, l}
		
		-- Supplied or default customisation scripts.
		if (customiser's class is record) then set {comparer:o's comparer, slave:o's slave} to (customiser & {comparer:o, slave:o})
		
		-- Do the sort.
		o's shsrt(l, r)
	end if
	
	return -- nothing.
end CustomShellSort

on composeText(filteredData)
	tell application "TextEdit"
		set newDoc to (make new document with properties {text:" "})
		set baseFont to font of newDoc's text
		set boldFont to baseFont & " bold"
		set newDoc's text to ""
		activate
	end tell
	
	-- No events found
	if (filteredData is {}) then
		tell application "TextEdit" to make new paragraph at end of newDoc's text with data "No events found in this period." with properties {font:boldFont}
		
	else
		-- Print the events
		set currentCalendarDate to ""
		repeat with i from 1 to (count filteredData)
			set {{date string:thisCalendarDate, hours:thisStartTimeH, minutes:thisStartTimeM}, thisSummary, thisCalendar} to item i of filteredData
			if (thisCalendarDate is not currentCalendarDate) then
				tell application "TextEdit"
					make new paragraph at end of newDoc's text with data linefeed with properties {font:baseFont}
					make new paragraph at end of newDoc's text with data (thisCalendarDate & linefeed) with properties {font:boldFont}
				end tell
				set currentCalendarDate to thisCalendarDate
			end if
			tell (10000 + thisStartTimeH * 100 + thisStartTimeM) as text to set thisStartTime to text 2 thru 3 & ":" & text 4 thru 5
			tell application "TextEdit" to make new paragraph at end of newDoc's text with data ("\"" & thisCalendar & "\" calendar: " & thisStartTime & " " & thisSummary & linefeed) with properties {font:baseFont}
		end repeat
	end if
end composeText

on main()
	display notification "Will take some time" with title "daySummary"
	
	tell application "Calendar" to set {{eventDates, eventSummarys}, calendarNames} to {{start date, summary} of events, name} of calendars
	set {startDate, endDate} to getDateRange()
	
	set filteredData to filterToDateRange(eventDates, eventSummarys, calendarNames, startDate, endDate)
	
	sortByDate(filteredData)
	composeText(filteredData)
end main

main()