
	-- So basically, we should store a scrollIndex of where they are.  Display items from that index down, I guess like 5 or whatever.  
	-- Though the scrollIndex itself would be a large number, equal to arrayIndex*buttonHeight, so it could scroll smoothly.
	-- Not sure if we can get mouse wheel events though.  We might need up/down buttons, which would need to be pageup/pagedwn to not be annoying

	-- Anyway that's the left side of the screen, a list of items with a scrollbar.  Maybe later we can categorize them.  
	-- And on the right side we just have a simple number selector to pick how many batches you need
	-- And a button that when pressed, shows you a new screen that just lists all the ores you should input to build it
	-- With an OK button to go back.

	-- When one of the options is selected it would turn like yellow, and its name will go on the right side above the quantity selector

	ButtonX = 10
	ButtonY = 0
	ButtonHeight = 80 --export: Height of buttons on the screen
	ButtonPadding = 5 --export: How much vertical padding there is between buttons

	-- I guess let's prepare the buttons.  They get the left 3/4 of the screen I'd say
	ButtonWidth = 1000

	local defaultFill = "rgb(0,0,255)"
	local selectedFill = "rgb(255,255,0)"
	local defaultFontColor = "white"
	local selectedFontColor = "black"
	local content = "<svg width='100vw' height='100vh' style='position:absolute; top:0; left:0' viewbox='0 0 1920 1080'>"
	local recipeIndex = ScrollIndex
	recipesPerPage = math.floor((1080/(ButtonHeight+ButtonPadding)))

	-- I'd like to use sgui but it's not really great for scrolling like this
	-- We can find the button that was clicked purely by using this same math
	-- And don't need to store anything about these positions etc

	for i=recipeIndex,recipeIndex + recipesPerPage,1 do
		local buttonX = ButtonX
		local buttonY = ButtonY + (i-recipeIndex)*(ButtonHeight+ButtonPadding)
		local craftablei = i+1
		if craftablei <= 0 then
			craftablei = RecipeCount
		elseif craftablei > RecipeCount then
			craftablei = 1 + craftablei%RecipeCount
		end

		-- Draw a rectangle for the 'button'
		content = content .. '<rect width="' .. ButtonWidth .. '" height="' .. ButtonHeight .. '" rx="10" ry="10" x="' .. buttonX .. '" y="' .. buttonY .. '" style="fill:'
		if SelectedIndex == i then
			content = content .. selectedFill
		else
			content = content.. defaultFill
		end
		content = content .. ';stroke-width:4;stroke:white;" />'
		-- And draw the text
		content = content .. "<text x='" .. buttonX + ButtonWidth/2 .. "' y='" .. buttonY + ButtonHeight/2 + 5 .. "' font-size='28' fill='"
		if SelectedIndex == i then
			content = content .. selectedFontColor
		else
			content = content.. defaultFontColor
		end -- Used to be Recipes[i] but... why... 
		content = content .. "' text-anchor='middle' font-family='Montserrat'>" .. CraftableItems[craftablei] .. "</text>"
	end

	-- Now we need scroll buttons.  No scroll wheel access, so, pageup and pagedown buttons
	-- They should be the same height as these buttons, not very wide, and at the top and bottom beside them on the right
	-- Our other stuff can go in the rest of that blank space between them

	-- We do need these for detection purposes
	scrollUpButtonX = ButtonX + ButtonWidth + ButtonPadding
	scrollUpButtonY = 0
	scrollUpButtonWidth = 100
	scrollUpButtonHeight = ButtonHeight
	-- Draw a rectangle for the 'button'
	content = content .. '<rect width="' .. scrollUpButtonWidth .. '" height="' .. scrollUpButtonHeight .. '" rx="10" ry="10" x="' .. scrollUpButtonX .. '" y="' .. scrollUpButtonY .. '" style="fill:rgb(0,0,255);stroke-width:4;stroke:white;" />'
	-- And draw the text
	content = content .. "<text x='" .. scrollUpButtonX + scrollUpButtonWidth/2 .. "' y='" .. scrollUpButtonY + scrollUpButtonHeight/2 + 5 .. "' font-size='28' fill='white' text-anchor='middle' font-family='Montserrat'>^</text>"

	scrollDownButtonX = ButtonX + ButtonWidth + ButtonPadding
	scrollDownButtonY = 1080 - ButtonHeight -- This is weird and doesn't work quite right but ok
	-- Like really fucking weird.
	-- It draws wrong, but everything detects as if it were drawn right.
	scrollDownButtonWidth = 100
	scrollDownButtonHeight = ButtonHeight
	-- Draw a rectangle for the 'button'

	-- As mentioned, inexplicably this one draws wrong apparently, so... add 20 and it's perfect, wtf... 
	content = content .. '<rect width="' .. scrollDownButtonWidth .. '" height="' .. scrollDownButtonHeight .. '" rx="10" ry="10" x="' .. scrollDownButtonX .. '" y="' .. scrollDownButtonY + 20 .. '" style="fill:rgb(0,0,255);stroke-width:4;stroke:white;" />'
	-- And draw the text
	content = content .. "<text x='" .. scrollDownButtonX + scrollDownButtonWidth/2 .. "' y='" .. scrollDownButtonY + 20 + scrollDownButtonHeight/2 + 5 .. "' font-size='28' fill='white' text-anchor='middle' font-family='Montserrat'>v</text>"

	-- Alright, and now a selector for quantity
	-- Which would go under header text showing the name of the thing if one is selected
	local headerTextX = (ButtonX + ButtonWidth) + (1920-(ButtonX + ButtonWidth))/2
	local headerTextY = (ButtonHeight + ButtonPadding)/2
	if SelectedIndex > -1 then
		content = content .. "<text x='" .. headerTextX .. "' y='" .. headerTextY .. "' font-size='32' fill='orange' text-anchor='middle' font-family='Montserrat'>" .. Recipes[SelectedIndex].name .. "</text>"
	end
	quantityLessButtonX = scrollUpButtonX + scrollUpButtonWidth + ButtonPadding + 40
	quantityLessButtonY = headerTextY*2
	quantityLessButtonWidth = 200
	quantityLessButtonHeight = ButtonHeight

	content = content .. '<rect width="' .. quantityLessButtonWidth .. '" height="' .. quantityLessButtonHeight .. '" rx="10" ry="10" x="' .. quantityLessButtonX .. '" y="' .. quantityLessButtonY .. '" style="fill:rgb(255,255,255);stroke-width:4;stroke:black;" />'
	-- And draw the text
	content = content .. "<text x='" .. quantityLessButtonX + quantityLessButtonWidth/2 .. "' y='" .. quantityLessButtonY + quantityLessButtonHeight/2 + 5 .. "' font-size='28' fill='black' text-anchor='middle' font-family='Montserrat'>&lt;</text>"

	quantityTextX = quantityLessButtonX + quantityLessButtonWidth + ButtonPadding + quantityLessButtonWidth/2
	quantityTextY = quantityLessButtonY + quantityLessButtonHeight/2 + 5
	quantityTextWidth = quantityLessButtonWidth -- Just for reference
	quantityTextHeight = ButtonHeight

	content = content .. "<text x='" .. quantityTextX .. "' y='" .. quantityTextY .. "' font-size='36' fill='white' text-anchor='middle' font-family='Montserrat'>" .. Quantity .. "</text>"

	quantityMoreButtonX = quantityLessButtonX + quantityLessButtonWidth + ButtonPadding + quantityTextWidth + ButtonPadding
	quantityMoreButtonY = quantityLessButtonY
	quantityMoreButtonWidth = quantityLessButtonWidth
	quantityMoreButtonHeight = ButtonHeight

	content = content .. '<rect width="' .. quantityMoreButtonWidth .. '" height="' .. quantityMoreButtonHeight .. '" rx="10" ry="10" x="' .. quantityMoreButtonX .. '" y="' .. quantityMoreButtonY .. '" style="fill:rgb(255,255,255);stroke-width:4;stroke:black;" />'
	-- And draw the text
	content = content .. "<text x='" .. quantityMoreButtonX + quantityMoreButtonWidth/2 .. "' y='" .. quantityMoreButtonY + quantityMoreButtonHeight/2 + 5 .. "' font-size='28' fill='black' text-anchor='middle' font-family='Montserrat'>&gt;</text>"

	-- And lastly, use the OreCost table to display our costs.
	local costColWidth = (1920-ButtonWidth-ButtonPadding)/2-ButtonPadding
	local costNameX = ButtonWidth + ButtonPadding + costColWidth/2
	local costValueX = ButtonWidth + ButtonPadding*2 + costColWidth*1.5

	local costY = quantityMoreButtonY + quantityMoreButtonHeight*2 + ButtonPadding
	local costOffsetY = 25
	if SelectedIndex > -1 and Quantity > 0 then
		for k,v in pairs(OreCost) do
        	--system.print(k .. "," .. v)
			content = content .. "<text x='" .. costNameX .. "' y='" .. costY .. "' font-size='32' fill='orange' text-anchor='right' font-family='Montserrat'>" .. k .. "</text>"
			content = content .. "<text x='" .. costValueX .. "' y='" .. costY .. "' font-size='32' fill='white' text-anchor='middle' font-family='Montserrat'>" .. math.ceil(v) .. "</text>"
			-- " .. math.ceil(v) .. "
			costY = costY + costOffsetY
		end
	end

	craftButtonX = scrollDownButtonX + scrollDownButtonWidth + ButtonPadding
	craftButtonY = 1080 - scrollDownButtonHeight - ButtonPadding - ButtonHeight
	craftButtonWidth = quantityLessButtonWidth + quantityTextWidth + quantityMoreButtonWidth
	craftButtonHeight = ButtonHeight

	if IsSelectedCraftable then
		-- Add a 'Craft' button that queues it.  
		content = content .. '<rect width="' .. craftButtonWidth .. '" height="' .. craftButtonHeight .. '" rx="10" ry="10" x="' .. craftButtonX .. '" y="' .. craftButtonY .. '" style="fill:rgb(255,166,0);stroke-width:4;stroke:black;" />'
		-- And draw the text
		content = content .. "<text x='" .. craftButtonX + craftButtonWidth/2 .. "' y='" .. craftButtonY + craftButtonHeight/2 + 5 .. "' font-size='28' fill='black' text-anchor='middle' font-family='Montserrat'>CRAFT</text>"
	end

	content = content .. "</svg>"
	screen.setHTML(content)

