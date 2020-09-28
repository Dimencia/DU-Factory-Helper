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

function GetAvailableMachine(recipe)
	for k,v in pairs(Assemblies) do
		if v.recipe == recipe then
			local status = v.machine.getStatus()
			if status == "STOPPED" then
				return v.machine;
			end
		end
	end
	return nil
end
unit.setTimer("asTick", 1/10)



Tick "asTick":

-- Check databank for all our recipes
for k,v in pairs(Assemblies) do
	if databank.hasKey(v.recipe) then
		local amount = databank.getIntValue(v.recipe)
		local machine = GetAvailableMachine(v.recipe)
		if amount > 0 and machine ~= nil then
			machine.batchStart(amount)
			databank.setIntValue(v.recipe,0)
		end
	end
end