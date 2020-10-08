	
	content = "<svg width='100vw' height='100vh' style='position:absolute; top:0; left:0'>"
	-- Let's draw a title bar
	local titleHeight = 15
	content = content .. '<rect width="100vw" height="' .. titleHeight .. 'vh" x="0" y="0" style="fill:rgb(255,255,255);stroke-width:1;stroke:black;" />'
	content = content .. "<text x='50%' y='" .. titleHeight/2 + 2 .. "%' font-size='8vh' fill='black' text-anchor='middle' font-family='Montserrat'>Production Queue</text>"
	-- Prepare some stuff
	local padding = 2
	local y = titleHeight + padding*2
	local yMovement = 6
	
	-- Column stuff
	local nameColWidth = 20
	local nameColX = 10
	local recipeColWidth = 40
	local recipeColX = nameColX + nameColWidth + recipeColWidth/2
	local timeColWidth = 20
	local timeColX = nameColX + nameColWidth + recipeColWidth + 10
	
	for key, databank in pairs(unit) do
		if type(databank) == "table" and type(databank.export) == "table" and databank.getStringValue then 
			local toRemove = {}
			local users = json.decode(databank.getStringValue("users"))
			if users == nil then
				users = {}
			end
			for k,v in pairs(users) do
				if v.hide == nil then
					-- Name
					local fill = "white"
					if v.name == system.getPlayerName(unit.getMasterPlayerId()) then
						fill = "green"
					end
					content = content .. "<text x='" .. nameColX .. "' y='" .. y .. "%' font-size='4vh' font-weight='bold' fill='" .. fill .. "' text-anchor='left' font-family='Montserrat'>" .. v.name .. "</text>"
					-- Recipe
					content = content .. "<text x='" .. recipeColX .. "%' y='" .. y .. "%' font-size='4vh' font-weight='bold' fill='orange' text-anchor='middle' font-family='Montserrat'>" .. v.amount * v.outputQuantity .. " " .. v.recipe .. "</text>"
					-- Time
					local timeRemaining = v.amount*v.duration
					local fillColor = "orange"
					
					local userStart = databank.getStringValue(v.name .. v.starttime)
					if userStart ~= nil and userStart ~= "" then
						timeRemaining = v.amount*v.duration+tonumber(userStart) - system.getTime()
						if timeRemaining <= 0 then
							-- Remove them from next iteration
							table.insert(toRemove,k)
						end
						fillColor = "green"
					else
						-- No start time.  Check if it's pending
						local queuedAmount = databank.getIntValue(v.recipe)
						if queuedAmount == 0 then -- If nothing pending, it must have started and we missed it
							-- Set their start
							databank.setStringValue(v.name .. v.starttime,system.getTime())
						end
					end
					
					content = content .. "<text x='" .. timeColX .. "%' y='" .. y .. "%' font-size='4vh' font-weight='bold' fill='" .. fillColor.. "' text-anchor='right' font-family='Montserrat'>" .. FormatTimeString(timeRemaining) .. "</text>"
					
					y = y + yMovement
				end
			end
			local removed = false
			for k,v in pairs(toRemove) do
				databank.setStringValue(users[v].name .. users[v].starttime,"")
				users[v] = nil
				removed = true
			end
		end
	end
	
	
	if removed then -- Race condition here.  Hope for the best.  
		databank.setStringValue("users",json.encode(users))
	end
	
	content = content .. "</svg>"
	screen.setHTML(content)