Start:


Assemblies = {  {recipe="Container S",machine=slot1},
    {recipe="Assembly Line M",machine=slot10},
    {recipe="Chemical Industry M",machine=slot9},
    {recipe="3D Printer M",machine=slot8},
    {recipe="Glass Furnace M",machine=slot7},
    {recipe="Metalwork Industry M",machine=slot6},
    {recipe="Refiner M",machine=slot5},
    {recipe="Electronics Industry M",machine=slot4},
    {recipe="Smelter M",machine=slot3}
    
			}

function GetAvailableMachines(recipe)
	local machines = {}
	for k,v in pairs(Assemblies) do
		if v.recipe == recipe then
			local status = v.machine.getStatus()
			if status == "STOPPED" then
				table.insert(machines,v.machine);
			end
		end
	end
	return machines
end
unit.setTimer("asTick", 1)



Tick "asTick":

-- Check databank for all our recipes
local users = json.decode(databank.getStringValue("users"))
if users == nil then
	users = {}
end

for k,v in pairs(Assemblies) do
	if databank.hasKey(v.recipe) then
		local amount = databank.getIntValue(v.recipe)
		local machines = GetAvailableMachines(v.recipe)
		if amount > 0 and #machines > 0 then
			local amountPerMachine = math.floor(amount/#machines)
			local leftover = amount%#machines
			-- Have the first one add leftover
			local first = true
			for _,machine in pairs(machines) do
				if first then
					first = false
					machine.batchStart(amountPerMachine+leftover)
				else
					machine.batchStart(amountPerMachine)
				end
			end
			
			databank.setIntValue(v.recipe,0)
			local amountQueued = 0
			local additionalDuration = 0
			local numBatches = 0
			for key,val in pairs(users) do
				if val.recipe == v and databank.getStringValue(val.name .. val.starttime) == nil or databank.getStringValue(val.name .. val.starttime) == "" then
					-- Fine.  We'll do it the dumb way.  I can't figure out the math
					local duration = val.duration
					local durationPerPiece = val.duration/val.amount
					
					for i=0,i<val.amount,1 do
						amountQueued = amountQueued + 1
						if amountQueued%#machines == 0 then
							additionalDuration = additionalDuration + durationPerPiece
						end
					end
					if amountQueued%#machines == 0 then
						-- They don't actually need this last one we gave them...
						additionalDuration = additionalDuration - durationPerPiece
					end
					databank.setStringValue(val.name .. val.starttime,system.getTime() + durationPerPiece + additionalDuration)
					-- But the next person will
					if amountQueued%#machines == 0 then
						additionalDuration = additionalDuration + durationPerPiece
					end
				end 
			end
		end
	end
end