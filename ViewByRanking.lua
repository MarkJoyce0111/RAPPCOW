-----------------------------------------------------------------------------------------
--
-- ViewByRanking.lua -- SCENE
--
-- This is the scene in which rankings for each country are shown for chosen category
-- that was selected on previous Category Menu screen
--
-- Once the user picks a country from the rankings list, they will be taken to 
-- the Country Info scene to view that country.

-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

CountryArray = {}
displayArray = {}
CountryToDisplay = {}
newArray = {}
indexArray = {}
scrollView = ""
defaultField = display.newGroup()
sceneGroup = display.newGroup()
local bg2
local backButton
local searchTitle

local uiGroup
local backLayer
--debugGroup = sceneGroup = display.newGroup()display.newGroup()

-----------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Goto Country Data Scene
--------------------------------------------------------------------------------
local function gotoViewByCountryData()
	system.vibrate()
	audio.play( soundTable["soundSelect"] )
	defaultField:removeSelf()
	composer.gotoScene( "ViewByCountryInfo", { time=800, effect="crossFade" } )	
end

--------------------------------------------------------------------------------
-- Function for Go Back button
--------------------------------------------------------------------------------
local function goBack()
	system.vibrate()
	audio.play( soundTable["soundBack"] )
	composer.gotoScene( "categoryMenuScene", { time=800, effect="crossFade" } )
	defaultField:removeSelf()
	composer.removeScene("ViewByRanking")	
end


--------------------------------------------------------------------------------
-- Get Rating Line From File
--------------------------------------------------------------------------------
function getRatingLine(line)

	local path = system.pathForFile( "wjp.csv", system.ResourceDirectory )
	local file = io.open(path, "r")
	local data
	if file then
	print("File Found")
	for i = 1, line + 1 do
		data = file:read("*l")
			
	end	
		io.close (file)
		print("File Loaded Ok")
		return(data)
		else
			print("Not working") --No file/Error/file Open
	end
end

----------------------------------------------------------------------------------
-- Sort an Array; Highest to lowest.
----------------------------------------------------------------------------------
function sortArray(arr,arr2,arr3,arr4)
	for i = 1, #arr do
		local k = 1
		for k = k + i, #arr do

			if(arr[i] < arr[k])then
				local temp1 = arr[i]
				local temp2 = arr2[i]
				local temp3 = arr3[i]
				local temp4 = arr4[i]
				arr[i] = arr[k]
				arr2[i] = arr2[k]
				arr3[i] = arr3[k]
				arr4[i] = arr4[k]
				arr[k] = temp1	
				arr2[k] = temp2
				arr3[k] = temp3
				arr4[k] = temp4
			end
		end
				
	end
	--return arr
end	

---------------------------------------------------------------------------------
-- ScrollView listener.
---------------------------------------------------------------------------------
local function scrollListener( event )
 
	local phase = event.phase
	if ( phase == "began" ) then --print( "Scroll view was touched" )
	elseif ( phase == "moved" ) then-- print( "Scroll view was moved" )
	elseif ( phase == "ended" ) then --print( "Scroll view was released" )
	end
 
	-- In the event a scroll limit is reached...
	if ( event.limitReached ) then
		if ( event.direction == "up" ) then --print( "Reached bottom limit" )
		elseif ( event.direction == "down" ) then --print( "Reached top limit" )
		elseif ( event.direction == "left" ) then --print( "Reached right limit" )
		elseif ( event.direction == "right" ) then --print( "Reached left limit" )
		end
	end
 
	return true
end

------------------------------------------------------------------------------------
-- Render a Row.
------------------------------------------------------------------------------------
local function onRowRender( event )
	local temp = ""
	
    -- Get reference to the row group
    row = event.row
	
    -- TODO******** Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = 100
    --local rowWidth = 3000
	temp = row.id
    local rowTitle = display.newText(row,row.id, 0, 0,270,0,native.systemFont, 15 )
    --rowTitle:setFillColor( 0,0,8 )
	
	if (string.find(temp,"Factor")~=1)then
		rowTitle:setFillColor( 0,0,0 ) --Is not a FACTOR (flat file) heading text colour blue.
		else
		rowTitle:setFillColor( 0,8,0 )	--Is a heading Colour X (green) 
	end
 
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 20      --Where inside the ROW
    rowTitle.y = 20
	rowHeight = rowHeight * 0.5
	isBounceEnabled = false

end

----------------------------------------------------------------------------------------
-- Flag Button handler.
-- Set composer vars for use in next scene
-- Goto ViewByCountryData SCENE
----------------------------------------------------------------------------------------
function handleRowButton (event,self)
	print("Row Button: "..event.target.id)
	composer.setVariable( "countryID", indexArray[event.target.id] )
	composer.setVariable( "countryString", CountryArray[event.target.id] )
	composer.setVariable( "countryDisplayString", displayArray[event.target.id] )
	gotoViewByCountryData()	
end

---------------------------------------------------------------------------------------
--Make a Country Array
--Ignors commas, "
--Convers Case to lower
---------------------------------------------------------------------------------------
function makeArray (aString)
	local constring = ""
	local array = {}
	for i = 0, #aString + 1 do
		local c = aString:sub(i,i)
		if (c~= "," and c ~= "\"") then --CSV separator and errors in Flat File
			constring = string.lower(constring..c)
		else
			if(constring ~= "")then -- I am leaving this but it does nothing
				array[#array + 1] = constring
				constring = ""
			else
				constring = ""
			end
		end
	end
	array[#array + 1] = constring --One left in the array
	return array
end

----------------------------------------------------------------------------------------
--Make an Array - contains capitals
--Ignors commas, "
----------------------------------------------------------------------------------------
function rawArray (aString)
	local constring = ""
	local array = {}
	for i = 0, #aString + 1 do
		local c = aString:sub(i,i)
		if (c~= "," and c ~= "\"") then --CSV separator and errors in Flat File
			constring = (constring..c)
		else
			if(constring ~= "")then -- I am leaving this but it does nothing
				array[#array + 1] = constring
				constring = ""
			else
				constring = ""
			end
		end
	end
	array[#array + 1] = constring --One left in the array
	return array
end

----------------------------------------------------------------------------------------
-- Text Box Listener
--
----------------------------------------------------------------------------------------
local function textListener( event )
	Runtime:removeEventListener( "touch", touchListener )
	-- Clear Debug Group Remove form display
	display.remove( debugGroup )
	dubugGroup = nil
	debugGroup = display.newGroup()
	--Clear Button Group Remove form display
	display.remove( ButtonGroup )
	ButtonGroup = nil
	ButtonGroup = display.newGroup()
		
		-- If there is a tableView on the screen at the moment. 
		--Kill It/Remove it
	if (FirstTimeFlag == 1) then
		tableView:deleteAllRows()
	end
	-- Enter letter is entered on the phone keyboard.
	if (  event.phase == "submitted" ) then

		--Remove ButtonGroup and start another. Clears the results text. 
		display.remove( ButtonGroup )
		ButtonGroup = nil
		ButtonGroup = display.newGroup()
		
		-- Get text string from text box
		local someString = event.target.text
		if someString ~= "" then
			anotherString = string.lower(someString)
			--Search Chars
			findChars(CountryArray, anotherString)
			defaultField.text = ""
	
			else -- Text box is empty
				counter = 2
				--displayFlags()
				searchTitle = display.newEmbossedText( debugGroup,"Please Enter a search term",display.contentCenterX,60, 0, 0, native.systemFont, 14)
				debugGroup:insert(searchTitle)
		end	

	end
end

----------------------------------------------------------------------------------------
--Search partial string, not case sensitive. ie "A" or "Aust" etc
--Display results as Buttons
--
----------------------------------------------------------------------------------------
function findChars(array,search) 
	
	local someString = ""
	local startpos = 200
	Poscounter = 0 
	local flag = 0
	local foundArray= {}
	k = 1

	--Comapare each charater in the string, count the matches
	for i = 1, #array  do --Start at index 2 to disclude the headers ie Country, Country Code etc.**WALK AROUND!!
		local success = 0
		someString = array[i]
		for k = 1, #someString do
			local c = someString:sub(k,k)--Get the chars to compare
			local d = search:sub(k,k)
			if (c == d) then --If chars the same increment match count
				success = success + 1
			else 
				success = success + 0	
			end
		end
		--If the matches are the lenght of the string
		--Create a Country button.

		if (success == #search)then		
			Poscounter = Poscounter + 1 -- For button Spacing on Y axis.See var 'top' below
			print("Found "..array[i].. " at index position "..i) --Debug	
			if (array[i] ~= CountryArray[1]) then -- ~= "country"
				foundArray[k] = i
				k = k +1
				flag = 1 -- Found search term Flag
			end
		end	
	end

	if(#foundArray < 1) then
		searchTitle = display.newEmbossedText( debugGroup,"No results found.",display.contentCenterX,60, 0, 0, native.systemFont, 14)
		debugGroup:insert(searchTitle)
		return
	end
	
	--[[ --Debug
	for i = 1, #foundArray do
		print(foundArray[i])
	end
	]]--
	
	--New scroll view
	display.remove( scrollView )
	scrollView = nil
	scrollView = display.newGroup()
	
	rankX = -142
	flagX = -100
	nameX = 26
	y = -210
	
	scrollView = widget.newScrollView(
		{
			top = 75,
			left = 12,
			width = 296,
			height = 380,
			--scrollWidth = 0,
			scrollHeight = 380,
			listener = scrollListener,
			horizontalScrollDisabled = true,
			isBounceEnabled = true,
			hideBackground = true
			-- backgroundColor = { 0, 0, 0 }
		}
	)
	
	for i = 1, #foundArray do	-- we have 113 countries to populate in ranking chart everytime

		-- Create text and image content for a row in the scroll area
	
		local rankstring = "rank"
		rankstring = rankstring..i
		_G[rankstring] = display.newEmbossedText( foundArray[i] - 1, 0, 0, native.systemFont, 15 )
		_G[rankstring]:setFillColor( 1, 0.8, 0 )
		_G[rankstring].x = display.contentCenterX + rankX
		_G[rankstring].y = display.contentCenterY + y
		rankstring = nil
		
		local rankstring = "flag"
		rankstring = rankstring..i
		_G[rankstring] = display.newImageRect( ("flags/"..CountryArray[foundArray[i]]..".png"), 50, 50)
		_G[rankstring].x = display.contentCenterX + flagX
		_G[rankstring].y = display.contentCenterY + y		
		_G[rankstring].id = foundArray[i]
		
		_G[rankstring]:addEventListener("touch",handleRowButton)
		rankstring = nil
		
		local rankstring = "name"
		rankstring = rankstring..i
		_G[rankstring] = display.newEmbossedText( displayArray[foundArray[i]], 0, 0,180,0, native.systemFont, 15 )
		_G[rankstring]:setFillColor( 1, 1, 1 )
		_G[rankstring].x = display.contentCenterX + nameX
		_G[rankstring].y = display.contentCenterY + y	
		rankstring = nil

		-- thin line to separate each row in the scroll view area
		local rankstring = "rowLine"
		rankstring = rankstring..i	
		_G[rankstring] = display.newLine( display.contentCenterX - 155, display.contentCenterY + (y + 25), display.contentCenterX + 130, display.contentCenterY + (y + 25) )
		_G[rankstring]:setStrokeColor( 1, 1, 1, 0.5 )
		_G[rankstring].strokeWidth = 1
		rankstring = nil
		
		-- increment the row height
		y = y + 50	
		
		-- add to the scrollView display group
		scrollView:insert ( _G['rank'..i] )
		scrollView:insert ( _G['flag'..i] )
		scrollView:insert ( _G['name'..i] )
		scrollView:insert ( _G['rowLine'..i] )
		
	end
    sceneGroup:insert(scrollView)
end


------------------------------------------------------Functions End---------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- READ DATABASE
-------------------------------------------------------------------------------------
-- Open File
local path = system.pathForFile( "wjp.csv", system.ResourceDirectory )
local file = io.open(path, "r")
if file then
	print("File Found")
	country = file:read("*l")
	io.close (file)
	print("File Loaded Ok")
	else
		print("Not working") --No file/Error/file Open
end


--------------------------------------------------------------------------------------
-- user interface stuff
--------------------------------------------------------------------------------------
local bg2
local backButton
local searchTitle

local uiGroup
local backLayer


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    sceneGroup = self.view
    
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Set up display groups
	uiGroup = display.newGroup()    -- Display group for UI objects
	backLayer = display.newGroup()
	scrollView = display.newGroup()
	local rowTitle = ""
	-- Display blue background image
	bg2X,bg2Y = display.contentCenterX, display.contentCenterY
	bg2 = display.newRect( uiGroup, bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
	bg2.fill = { type="image", filename="bg_blue.jpg" }

	titleString = composer.getVariable("LineString")
	print(titleString.."LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL")
	rowTitle = display.newEmbossedText(backLayer,titleString, display.contentCenterX + 15, display.contentCenterY - 190,270,0,native.systemFontBold, 18 )
	rowTitle:setFillColor( 0.95, 0.95, 0 ) 
	backLayer:insert(rowTitle)
	
	

	----------------------------------------------------------------------------------------
	-- Display textfield
	--defaultField = native.newTextField( 160, 25, 180, 30 )
	--defaultField:addEventListener( "userInput", textListener )
	--searchTitle = display.newText( "Search",display.contentCenterX,0, 0, 0, native.systemFont, 14)
	--searchTitle:setFillColor( 1, 1, 1 )		
	----------------------------------------------------------------------------------------

	-- Create the widget for ScrollView
	scrollView = widget.newScrollView(
		{
			top = 75,
			left = 12,
			width = 296,
			height = 380,
			--scrollWidth = 0,
			scrollHeight = 380,
			listener = scrollListener,
			horizontalScrollDisabled = true,
			isBounceEnabled = true,
			hideBackground = true
			-- backgroundColor = { 0, 0, 0 }
		}
	)

	------------------------------------------------------------------------------
	-- Create the content to populate the ScrollView
	------------------------------------------------------------------------------
	-- starting co-ordinates for displaying stuff in scroll area
	rankX = -142
	flagX = -100
	nameX = 26
	y = -210
	
	-- create country list arrays, based on data read from db
	CountryArray = makeArray(country)
	displayArray = rawArray(country)
	newString = getRatingLine(composer.getVariable("LineNumber") - 1) -- Get line from file.
	LineArray = makeArray(newString)
	
	-- Make an Index Array, dont delete.
	for i = 1, #LineArray do
		indexArray[i] = i
	end

	sortArray(LineArray,CountryArray,displayArray,indexArray)-- Sort Arrays
	--[[
	for i = 2, #LineArray do --Debug
		print(LineArray[i])
		print(CountryArray[i])
	end--]]
	
	for i = 2, 114 do	-- we have 113 countries to populate in ranking chart everytime, count starts at column 2 in db

		-- Create text and image content for a row in the scroll area
	
		local rankstring = "rank"
		rankstring = rankstring..i
		_G[rankstring] = display.newEmbossedText( i - 1, 0, 0, native.systemFont, 15 )
		_G[rankstring]:setFillColor( 1, 0.8, 0 )
		_G[rankstring].x = display.contentCenterX + rankX
		_G[rankstring].y = display.contentCenterY + y
		rankstring = nil
		
		local rankstring = "flag"
		rankstring = rankstring..i
		_G[rankstring] = display.newImageRect( ("flags/"..CountryArray[i]..".png"), 50, 50)
		_G[rankstring].x = display.contentCenterX + flagX
		_G[rankstring].y = display.contentCenterY + y		
		_G[rankstring].id = i
		
		_G[rankstring]:addEventListener("touch",handleRowButton)
		rankstring = nil
		
		local rankstring = "name"
		rankstring = rankstring..i
		_G[rankstring] = display.newEmbossedText( displayArray[i], 0, 0, 180,0, native.systemFont, 15 )
		_G[rankstring]:setFillColor( 1, 1, 1 )
		_G[rankstring].x = display.contentCenterX + nameX
		_G[rankstring].y = display.contentCenterY + y	
		rankstring = nil
		
		-- thin line to separate each row in the scroll view area
		local rankstring = "rowLine"
		rankstring = rankstring..i	
		_G[rankstring] = display.newLine( display.contentCenterX - 155, display.contentCenterY + (y + 25), display.contentCenterX + 130, display.contentCenterY + (y + 25) )
		_G[rankstring]:setStrokeColor( 1, 1, 1, 0.5 )
		_G[rankstring].strokeWidth = 1
		rankstring = nil
		
		-- increment the row height
		y = y + 50	
		
		-- add to the scrollView display group
		scrollView:insert ( _G['rank'..i] )
		scrollView:insert ( _G['flag'..i] )
		scrollView:insert ( _G['name'..i] )
		scrollView:insert ( _G['rowLine'..i] )

	end
	
	-- thin blue border lines at top and bottom of scroll view window
	borderTop = display.newLine( display.contentCenterX - 200, display.contentCenterY - 166, display.contentCenterX + 200, display.contentCenterY - 166 )
	borderTop:setStrokeColor( 0.05, 0.23, 0.53 )
	borderTop.strokeWidth = 1
	
	borderBottom = display.newLine( display.contentCenterX - 200, display.contentCenterY + 215, display.contentCenterX + 200, display.contentCenterY + 215 )
	borderBottom:setStrokeColor( 0.05, 0.23, 0.53 )
	borderBottom.strokeWidth = 1
	
	-- Button widget for the Go Back button
	backButton = widget.newButton(
		{
			--onRelease = goBack,
			x = 29,
			y = 496,
			width = 40,
			height = 40,
			defaultFile = "backButtonDefault.png",
			overFile = "backButtonPressed.png"
		}
	)
	
	
	-- insert the widget buttons into the display group "uiGroup", as there is no way to directly insert them while creating them, unlike other display objects.
	--uiGroup:insert ( searchTitle )
	uiGroup:insert ( borderTop )
	uiGroup:insert ( borderBottom )
	uiGroup:insert ( backButton )

	-- insert my display objects (grouped as "uiGroup") into the "sceneGroup"
	sceneGroup:insert( uiGroup )
	sceneGroup:insert( scrollView )
	sceneGroup:insert( backLayer )	
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
	
--[	
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		defaultField = native.newTextField( 160, 15, 180, 30 )
		defaultField.placeholder = "Search"
		defaultField:addEventListener( "userInput", textListener )
		backButton:addEventListener("tap", goBack)
		

    end
--]
end

-- hide()
function scene:hide( event )

    local sceneGroup = self.view
	
--[	
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)	
			display.remove( debugGroup )
			dubugGroup = nil
			backButton:removeEventListener("tap", goBack)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
			
    end
--]	

end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
	
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene