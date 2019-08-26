
local composer = require( "composer" )
local mime = require("mime") --Base 64
local json = require("json")
local widget = require( "widget" )
local scene = composer.newScene()



local uid = "Mike"
--scrollView = ""
local password = "your_password"
local userID = mime.b64(uid) --Base 64 enco
local passW  = mime.b64(password)
--local URL = "http://localhost:8081/index.php"
--local URL = "http://localhost:44368/Default.aspx"
--local URL  = "https://localhost:44330/api/values"
local URL  = "https://localhost:44315/"
defaultField = display.newGroup()
sceneGroup = display.newGroup()

print ( "Remote URL: " .. URL )-- DEBUG: Show constructed url
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Function for Go Back button
--------------------------------------------------------------------------------

local function gotoNew()
	--system.vibrate()
	--audio.play( soundTable["soundBack"] )
	
	defaultField:removeSelf()
	composer.removeScene("menu")
	composer.gotoScene( "SignIn", { time=800, effect="crossFade" } )	
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function handleRowButton (event,self)
	print("Row Button: "..event.target.id)
end




---------------------
--Populate Job List
---------------------
local function functFunc(SomeJson)
	local t = {}
	for k, v in pairs(SomeJson) do
		print(k, v[0])
		for j in pairs(v) do
			print(v[j])
			table.insert( t, v[j] )
		end
	end
	table.sort(t)
	for i = 0, table.maxn(t),2 do
		print(t[i])
	end
	
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
			 --backgroundColor = { 0, 0, 0 }
		}
	)
	local counter = 1
	for i = 0, (table.maxn(t) - 1),2 do

		
		local rankstring = "flag"
		rankstring = rankstring..i
		--_G[rankstring] = display.newImageRect( ("backButtonDefault.png"), 50, 50) --backButtonDefault.png
		_G[rankstring] = display.newImageRect( ("cwImage.png"), 50, 50) --backButtonDefault.png
		_G[rankstring].x = display.contentCenterX + flagX
		_G[rankstring].y = display.contentCenterY + y		
		_G[rankstring].id = i
		
		_G[rankstring]:addEventListener("touch",handleRowButton)
		rankstring = nil
		
		local rankstring = "name"
		rankstring = rankstring..i
		_G[rankstring] = display.newEmbossedText(t[counter], 0, 0, 180,0, native.systemFont, 15 )
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
		
		scrollView:insert ( _G['flag'..i] )
		scrollView:insert ( _G['name'..i] )
		scrollView:insert ( _G['rowLine'..i] )
		counter = counter + 2
	end
	
		-- thin blue border lines at top and bottom of scroll view window
	borderTop = display.newLine( display.contentCenterX - 200, display.contentCenterY - 166, display.contentCenterX + 200, display.contentCenterY - 166 )
	borderTop:setStrokeColor( 0.05, 0.23, 0.53 )
	borderTop.strokeWidth = 1
	
	borderBottom = display.newLine( display.contentCenterX - 200, display.contentCenterY + 215, display.contentCenterX + 200, display.contentCenterY + 215 )
	borderBottom:setStrokeColor( 0.05, 0.23, 0.53 )
	borderBottom.strokeWidth = 1
	

end

--------------------------
--Login, Call back Event
--------------------------
local function loginCallback(event)
    -- perform basic error handling
    if ( event.isError ) then
        print( "Network error!")
		local rowTitle = display.newEmbossedText("Damn, Network Error!", display.contentCenterX + 15, display.contentCenterY - 190,270,0,native.systemFontBold, 18 )
		rowTitle:setFillColor( 0.95, 0.95, 0 )
    else
        -- return a response code
        local data = json.decode(event.response)
		if (data ~= nil) then
			print ( "RESPONSE: " .. event.response.."\r\n" )
			--print( "t: " .. json.prettify( data ) )
			print(data.name)
			if(data.Data1 ~= nil) then
				
		       --print(json.decode(data));
				print( "t: " .. json.prettify( data ) )
				local rowTitle = display.newEmbossedText("Connected. Select: Job Type", display.contentCenterX + 15, display.contentCenterY - 190,270,0,native.systemFontBold, 18 )
				rowTitle:setFillColor( 0.95, 0.95, 0 ) 
				functFunc(data)
				local coded = data.name
				local decoder = mime.unb64(coded)
				print(decoder)
				local coded = data.age
				local decoder = mime.unb64(coded)
				print(decoder)
				local coded = data.city
				local decoder = mime.unb64(coded)
				print(decoder)
			else
				local rowTitle = display.newEmbossedText("Damn, Something went wrong!", display.contentCenterX + 15, display.contentCenterY - 190,270,0,native.systemFontBold, 18 )
				rowTitle:setFillColor( 0.95, 0.95, 0 )
			end
		else
			print("Damn, Login Error!")
			local rowTitle = display.newEmbossedText("Damn, Login Error!", display.contentCenterX + 15, display.contentCenterY - 190,270,0,native.systemFontBold, 18 )
			rowTitle:setFillColor( 0.95, 0.95, 0 )
		end
		
    end
    return true
end




-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	local titleString = "JOBS"
	-- Set up display groups
	uiGroup = display.newGroup()    -- Display group for UI objects
	backLayer = display.newGroup()
	scrollView = display.newGroup()
	local rowTitle = ""
	print("hello")
	local bg2X,bg2Y = display.contentCenterX, display.contentCenterY
	local bg2 = display.newRect( uiGroup, bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
	bg2.fill = { type="image", filename="bg_blue.jpg" }
	
	--rowTitle = display.newEmbossedText(backLayer,titleString, display.contentCenterX + 15, display.contentCenterY - 190,270,0,native.systemFontBold, 18 )
	--rowTitle:setFillColor( 0.95, 0.95, 0 ) 
	--backLayer:insert(rowTitle)
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
	uiGroup:insert ( backButton )
	sceneGroup:insert( uiGroup )
	
	local storedDeviceID = system.getInfo( "deviceID" )
	local paramaz =  {}
	local body = "userID="..userID.."&password=".. passW .. "&devID=" .. storedDeviceID--base 64
	paramaz.body = body

	-- make JSON call to the remote server
	network.request( URL, "POST", loginCallback, paramaz)
	
	
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		--defaultField = native.newTextField( 160, 15, 180, 30 )
		--defaultField.placeholder = "Search"
		--defaultField:addEventListener( "userInput", textListener )
		backButton:addEventListener("tap", gotoNew)

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
			--display.remove( debugGroup )
			--dubugGroup = nil
			backButton:removeEventListener("tap", gotoNew)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
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
