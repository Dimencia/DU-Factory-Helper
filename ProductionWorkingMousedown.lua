-- Screen mouseDown(*,*)
-- x and y already assigned, with values from 0 to 1, origin top left
local convertedX = x * 100
local convertedY = y * 100

if convertedX > scrollUpButtonX and convertedX < scrollUpButtonX + scrollUpButtonWidth and convertedY > scrollUpButtonY and convertedY < scrollUpButtonY + scrollUpButtonHeight then
    -- Scroll up
    ScrollIndex = ScrollIndex - recipesPerPage
    if ScrollIndex < 0 then
        ScrollIndex = 0
    end
elseif convertedX > scrollDownButtonX and convertedX < scrollDownButtonX + scrollDownButtonWidth and convertedY > scrollDownButtonY and convertedY < scrollDownButtonY + scrollDownButtonHeight then
    -- Scroll down
    ScrollIndex = ScrollIndex + recipesPerPage
    if ScrollIndex > RecipeCount - recipesPerPage then
        ScrollIndex = RecipeCount - recipesPerPage
    end
elseif convertedX > quantityMoreButtonX and convertedX < quantityMoreButtonX + quantityMoreButtonWidth and convertedY > quantityMoreButtonY and convertedY < quantityMoreButtonY + quantityMoreButtonHeight then
    Quantity = Quantity + 1
    OreCost = getOreCosts(SelectedIndex,Quantity*Recipes[SelectedIndex].outputQuantity)
elseif convertedX > quantityLessButtonX and convertedX < quantityLessButtonX + quantityLessButtonWidth and convertedY > quantityLessButtonY and convertedY < quantityLessButtonY + quantityLessButtonHeight and Quantity > 1 then
    Quantity = Quantity - 1
    OreCost = getOreCosts(SelectedIndex,Quantity*Recipes[SelectedIndex].outputQuantity)
elseif convertedX > craftButtonX and convertedX < craftButtonX + craftButtonWidth and convertedY > craftButtonY and convertedY < craftButtonY + craftButtonHeight then
    -- Queue the craft and reset everything
    local recipe = Recipes[SelectedIndex].name

    if databank.hasKey(recipe) then
        local amount = databank.getIntValue(recipe)
        amount = amount + Quantity
        databank.setIntValue(recipe, amount)
    else
        databank.setIntValue(recipe, Quantity)
    end
	
	-- Store who crafted it and the time at which it should complete
	-- We would do this in a "users" field on the databank, which we decode and append to, and re-encode
	local users = {}
	if databank.hasKey("users") then
		users = json.decode(databank.getStringValue("users"))
		if users == nil then
			users = {}
		end
	end
	local user = { name=system.getPlayerName(unit.getMasterPlayerId()), recipe=recipe, starttime=system.getTime(), duration=Recipes[SelectedIndex].time, amount=Quantity, outputQuantity=Recipes[SelectedIndex].outputQuantity }
	table.insert(users,user)
	databank.setStringValue("users", json.encode(users))
    Quantity = 1
    ScrollIndex = 0
    SelectedIndex = -1
end
    -- Check if it was a recipe button
    
for i=ScrollIndex,ScrollIndex + recipesPerPage,1 do
    local buttonX = ButtonX
    local buttonY = ButtonY + (i-ScrollIndex)*(ButtonHeight+ButtonPadding)
    local craftablei = math.floor(i+1.5)
    if craftablei <= 0 then
        craftablei = RecipeCount
    elseif craftablei > RecipeCount then
        craftablei = 1 + craftablei%RecipeCount
    end
    if convertedX > buttonX and convertedX < buttonX + ButtonWidth and convertedY > buttonY and convertedY < buttonY + ButtonHeight then
        SelectedIndex = getIndexForRecipe(CraftableItems[craftablei])
        OreCost = getOreCosts(SelectedIndex,Quantity*Recipes[SelectedIndex].outputQuantity)
        --IsSelectedCraftable = false
        --for k,v in pairs(CraftableItems) do
        --    if v == Recipes[SelectedIndex].name then
                IsSelectedCraftable = true
        --        break
        --    end
        --end
        --break
    end
end