-- Screen mouseDown(*,*)
-- x and y already assigned, with values from 0 to 1, origin top left
local convertedX = x * 1920
local convertedY = y * 1080

if convertedX > scrollUpButtonX and convertedX < scrollUpButtonX + scrollUpButtonWidth and convertedY > scrollUpButtonY and convertedY < scrollUpButtonY + scrollUpButtonHeight then
	-- Scroll up
	ScrollIndex = ScrollIndex - recipesPerPage
	if ScrollIndex < 0 then
		ScrollIndex = RecipeCount + ScrollIndex
	end
elseif convertedX > scrollDownButtonX and convertedX < scrollDownButtonX + scrollDownButtonWidth and convertedY > scrollDownButtonY and convertedY < scrollDownButtonY + scrollDownButtonHeight then
	-- Scroll down
	ScrollIndex = ScrollIndex + recipesPerPage
	if ScrollIndex >= RecipeCount then
		ScrollIndex = ScrollIndex - RecipeCount
	end
elseif convertedX > quantityMoreButtonX and convertedX < quantityMoreButtonX + quantityMoreButtonWidth and convertedY > quantityMoreButtonY and convertedY < quantityMoreButtonY + quantityMoreButtonHeight then
	Quantity = Quantity + 1
	OreCost = getOreCosts(SelectedIndex,Quantity)
elseif convertedX > quantityLessButtonX and convertedX < quantityLessButtonX + quantityLessButtonWidth and convertedY > quantityLessButtonY and convertedY < quantityLessButtonY + quantityLessButtonHeight and Quantity > 1 then
	Quantity = Quantity - 1
	OreCost = getOreCosts(SelectedIndex,Quantity)
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
	Quantity = 1
	ScrollIndex = 0
	SelectedIndex = -1
end
	-- Check if it was a recipe button
	
for i=ScrollIndex,ScrollIndex + recipesPerPage,1 do
	local buttonX = ButtonX
	local buttonY = ButtonY + (i-ScrollIndex)*(ButtonHeight+ButtonPadding)
	local craftablei = i+1
	if craftablei <= 0 then
		craftablei = RecipeCount
	elseif craftablei > RecipeCount then
		craftablei = 1 + craftablei%RecipeCount
	end
	if convertedX > buttonX and convertedX < buttonX + ButtonWidth and convertedY > buttonY and convertedY < buttonY + ButtonHeight then
		SelectedIndex = getIndexForRecipe(CraftableItems[craftablei])
		OreCost = getOreCosts(SelectedIndex,Quantity)
		--IsSelectedCraftable = false
		--for k,v in pairs(CraftableItems) do
		--	if v == Recipes[SelectedIndex].name then
				IsSelectedCraftable = true
		--		break
		--	end
		--end
		--break
	end
end