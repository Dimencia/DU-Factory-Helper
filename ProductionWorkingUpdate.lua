
    -- So basically, we should store a scrollIndex of where they are.  Display items from that index down, I guess like 5 or whatever.  
    -- Though the scrollIndex itself would be a large number, equal to arrayIndex*buttonHeight, so it could scroll smoothly.
    -- Not sure if we can get mouse wheel events though.  We might need up/down buttons, which would need to be pageup/pagedwn to not be annoying

    -- Anyway that's the left side of the screen, a list of items with a scrollbar.  Maybe later we can categorize them.  
    -- And on the right side we just have a simple number selector to pick how many batches you need
    -- And a button that when pressed, shows you a new screen that just lists all the ores you should input to build it
    -- With an OK button to go back.

    -- When one of the options is selected it would turn like yellow, and its name will go on the right side above the quantity selector

    ButtonX = 1 -- In VW
    ButtonY = 12
    ButtonHeight = 10 --export: Height of buttons on the screen in vh
    ButtonPadding = 1 --export: How much vertical padding there is between buttons in vh

    -- I guess let's prepare the buttons.
    ButtonWidth = 50 -- in vw

    local defaultFill = "rgb(35,35,35)"
    local selectedFill = "rgb(200,200,200)"
    local defaultFontColor = "white"
    local selectedFontColor = "black"
    local content = "<svg width='100vw' height='100vh' style='position:absolute; top:0; left:0'>"
    local recipeIndex = ScrollIndex
    recipesPerPage = math.floor(((100-ButtonY)/(ButtonHeight+ButtonPadding)))-1

    -- I'd like to use sgui but it's not really great for scrolling like this
    -- We can find the button that was clicked purely by using this same math
    -- And don't need to store anything about these positions etc
	
	-- But first, a header
	content = content .. '<rect width="100vw" height="' .. ButtonY - ButtonPadding .. 'vh" x="0" y="0" style="fill:white;stroke-width:1;stroke:black;" />'
	content = content .. "<text x='50%' y='" .. ButtonHeight/2 + 3 .. "%' font-size='8vh' fill='black' text-anchor='middle' font-family='Montserrat'>" .. Description .. "</text>"

    for i=recipeIndex,recipeIndex + recipesPerPage,1 do
        local buttonX = ButtonX
        local buttonY = ButtonY + (i-recipeIndex)*(ButtonHeight+ButtonPadding)
        local craftablei = math.floor(i+1.5)
        if craftablei <= 0 then
            craftablei = RecipeCount
        elseif craftablei > RecipeCount then
            craftablei = 1 + craftablei%RecipeCount
        end
		
		local selected = (SelectedIndex > -1 and Recipes[SelectedIndex] ~= nil and Recipes[SelectedIndex].name == CraftableItems[craftablei])

        -- Draw a rectangle for the 'button'
        content = content .. '<rect width="' .. ButtonWidth .. 'vw" height="' .. ButtonHeight .. 'vh" x="' .. buttonX .. 'vw" y="' .. buttonY .. 'vh" style="fill:'
        if selected then
            content = content .. selectedFill
        else
            content = content.. defaultFill
        end
        content = content .. ';stroke-width:1;stroke:white;" />'
        -- And draw the text.  Text doesn't support vh/vw so we can try percent
        content = content .. "<text x='" .. buttonX + ButtonWidth/2 .. "%' y='" .. buttonY + ButtonHeight/2 + 2 .. "%' font-size='4vh' fill='"
        if selected then
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
    scrollUpButtonY = ButtonY
    scrollUpButtonWidth = 5
    scrollUpButtonHeight = ButtonHeight
    -- Draw a rectangle for the 'button'
    content = content .. '<rect width="' .. scrollUpButtonWidth .. 'vw" height="' .. scrollUpButtonHeight .. 'vh" x="' .. scrollUpButtonX .. 'vw" y="' .. scrollUpButtonY .. 'vh" style="fill:rgb(100,100,100);stroke-width:1;stroke:white;" />'
    -- And draw the text
    content = content .. "<text x='" .. scrollUpButtonX + scrollUpButtonWidth/2 .. "%' y='" .. scrollUpButtonY + scrollUpButtonHeight/2 + 2 .. "%' font-size='7vh' fill='white' text-anchor='middle' font-family='Montserrat'>^</text>"

    scrollDownButtonX = ButtonX + ButtonWidth + ButtonPadding
    scrollDownButtonY = 100 - ButtonHeight - ButtonPadding
    scrollDownButtonWidth = 5
    scrollDownButtonHeight = ButtonHeight
    -- Draw a rectangle for the 'button'

    content = content .. '<rect width="' .. scrollDownButtonWidth .. 'vw" height="' .. scrollDownButtonHeight .. 'vh" x="' .. scrollDownButtonX .. 'vw" y="' .. scrollDownButtonY .. 'vh" style="fill:rgb(100,100,100);stroke-width:1;stroke:white;" />'
    -- And draw the text
    content = content .. "<text x='" .. scrollDownButtonX + scrollDownButtonWidth/2 .. "%' y='" .. scrollDownButtonY + scrollDownButtonHeight/2 + 2 .. "%' font-size='7vh' fill='white' text-anchor='middle' font-family='Montserrat'>v</text>"
	
	-- A scroll bar is nice
	scrollareaHeight = scrollDownButtonY-(scrollUpButtonY + scrollUpButtonHeight)
	content = content .. '<rect width="' .. scrollUpButtonWidth .. 'vw" height="' .. scrollareaHeight .. 'vh" x="' .. scrollUpButtonX .. 'vw" y="' .. scrollUpButtonY + scrollUpButtonHeight .. 'vh" style="fill:rgb(80,80,80);stroke-width:1;stroke:black;" />'
	scrollbarHeight = (recipesPerPage/#CraftableItems)*scrollareaHeight
	local percentScroll = (ScrollIndex/#CraftableItems)
	local scrollbarY = scrollUpButtonY + scrollUpButtonHeight + percentScroll*(scrollareaHeight)
	content = content .. '<rect width="' .. scrollUpButtonWidth .. 'vw" height="' .. scrollbarHeight .. 'vh" x="' .. scrollUpButtonX .. 'vw" y="' .. scrollbarY .. 'vh" style="fill:rgb(110,110,110);stroke-width:1;stroke:white;" />'

    -- Alright, and now a selector for quantity
    -- Which would go under header text showing the name of the thing if one is selected
    local headerTextX = (ButtonX + ButtonWidth) + (100-(ButtonX + ButtonWidth))/2
    local headerTextY = (ButtonHeight + ButtonPadding)/2 + ButtonY
    if SelectedIndex > -1 then
        content = content .. "<text x='" .. headerTextX .. "%' y='" .. headerTextY .. "%' font-size='3.5vh' font-weight='bold' fill='orange' text-anchor='middle' font-family='Montserrat'>" .. Recipes[SelectedIndex].name .. "</text>"
    end
    quantityLessButtonX = scrollUpButtonX + scrollUpButtonWidth + ButtonPadding + 10
    quantityLessButtonY = headerTextY + ButtonHeight/2 + ButtonPadding
    quantityLessButtonWidth = 5
    quantityLessButtonHeight = ButtonHeight

    content = content .. '<rect width="' .. quantityLessButtonWidth .. 'vw" height="' .. quantityLessButtonHeight .. 'vh" x="' .. quantityLessButtonX .. 'vw" y="' .. quantityLessButtonY .. 'vh" style="fill:rgb(100,100,100);stroke-width:1;stroke:white;" />'
    -- And draw the text
    content = content .. "<text x='" .. quantityLessButtonX + quantityLessButtonWidth/2 .. "%' y='" .. quantityLessButtonY + quantityLessButtonHeight/2 + 2 .. "%' font-size='7vh' fill='white' text-anchor='middle' font-family='Montserrat'>&lt;</text>"

    quantityTextX = quantityLessButtonX + quantityLessButtonWidth + ButtonPadding + quantityLessButtonWidth/2
    quantityTextY = quantityLessButtonY + quantityLessButtonHeight/2 + 2
    quantityTextWidth = quantityLessButtonWidth -- Just for reference
    quantityTextHeight = ButtonHeight

    content = content .. "<text x='" .. quantityTextX .. "%' y='" .. quantityTextY .. "%' font-size='8vh' fill='white' text-anchor='middle' font-family='Montserrat'>" .. Quantity .. "</text>"

    quantityMoreButtonX = quantityLessButtonX + quantityLessButtonWidth + ButtonPadding + quantityTextWidth + ButtonPadding
    quantityMoreButtonY = quantityLessButtonY
    quantityMoreButtonWidth = quantityLessButtonWidth
    quantityMoreButtonHeight = ButtonHeight

    content = content .. '<rect width="' .. quantityMoreButtonWidth .. 'vw" height="' .. quantityMoreButtonHeight .. 'vh" x="' .. quantityMoreButtonX .. 'vw" y="' .. quantityMoreButtonY .. 'vh" style="fill:rgb(100,100,100);stroke-width:1;stroke:white;" />'
    -- And draw the text
    content = content .. "<text x='" .. quantityMoreButtonX + quantityMoreButtonWidth/2 .. "%' y='" .. quantityMoreButtonY + quantityMoreButtonHeight/2 + 2 .. "%' font-size='7vh' fill='white' text-anchor='middle' font-family='Montserrat'>&gt;</text>"

    -- And lastly, use the OreCost table to display our costs.
    local costColWidth = (100-ButtonWidth-ButtonPadding)/2-ButtonPadding
    local costNameX = ButtonWidth + ButtonPadding + costColWidth/2
    local costValueX = ButtonWidth + ButtonPadding*2 + costColWidth*1.5

    local costOffsetY = 3.3
	local costY = quantityMoreButtonY + quantityMoreButtonHeight + ButtonPadding + costOffsetY
    if SelectedIndex > -1 and Quantity > 0 then
        for k,v in pairs(OreCost) do
            --system.print(k .. "," .. v)
            content = content .. "<text x='" .. costNameX .. "%' y='" .. costY .. "%' font-size='4vh' fill='orange' text-anchor='right' font-family='Montserrat'>" .. k .. "</text>"
            content = content .. "<text x='" .. costValueX .. "%' y='" .. costY .. "%' font-size='4vh' fill='white' text-anchor='middle' font-family='Montserrat'>" .. math.ceil(v) .. "</text>"
            -- " .. math.ceil(v) .. "
            costY = costY + costOffsetY
        end
    end
	
	if SelectedIndex > -1 and Recipes[SelectedIndex].outputQuantity > 1 then
		local outputQX = quantityTextX
		local outputQY = 100 - scrollDownButtonHeight - ButtonPadding*2 - ButtonHeight*2
		content = content .. "<text x='" .. outputQX .. "%' y='" .. outputQY .. "%' font-size='4vh' fill='white' text-anchor='middle' font-family='Montserrat'>Makes " .. Recipes[SelectedIndex].outputQuantity*Quantity .. "</text>"
	end

    craftButtonX = quantityLessButtonX
    craftButtonY = 100 - ButtonHeight
    craftButtonWidth = quantityLessButtonWidth + quantityTextWidth + quantityMoreButtonWidth
    craftButtonHeight = ButtonHeight

    if IsSelectedCraftable then
        -- Add a 'Craft' button that queues it.  
        content = content .. '<rect width="' .. craftButtonWidth .. 'vw" height="' .. craftButtonHeight .. 'vh" x="' .. craftButtonX .. 'vw" y="' .. craftButtonY .. 'vh" style="fill:rgb(255,166,0);stroke-width:1;stroke:black;" />'
        -- And draw the text
        content = content .. "<text x='" .. craftButtonX + craftButtonWidth/2 .. "%' y='" .. craftButtonY + craftButtonHeight/2 + 2 .. "%' font-size='5vh' fill='black' text-anchor='middle' font-family='Montserrat'>CRAFT</text>"
    end

    content = content .. "</svg>"
    screen.setHTML(content)

-- Do any mouse hold stuff here
	local convertedX = screen.getMouseX()*100
	local convertedY = screen.getMouseY()*100
	if screen.getMouseState() == 1 and convertedX > scrollDownButtonX and convertedX < scrollDownButtonX + scrollDownButtonWidth and convertedY > scrollUpButtonY + scrollUpButtonHeight and convertedY < scrollDownButtonY then
		-- Scroll to position using   scrollareaHeight
		local scrollPercent = (convertedY - (scrollUpButtonY + scrollUpButtonHeight + scrollbarHeight/2))/scrollareaHeight
		ScrollIndex = RecipeCount*scrollPercent
		if ScrollIndex > RecipeCount - recipesPerPage then
			ScrollIndex = RecipeCount - recipesPerPage
		end
		if ScrollIndex < 0 then
			ScrollIndex = 0
		end
	end