function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

RegisterCommand("giveweapon", function(source, args, rawCommand)
	local playerPed = GetPlayerPed(-1)
	local weaponHash = GetHashKey(args[1])
	local ammoCount = 9999

	GiveWeaponToPed(playerPed, weaponHash, ammoCount, false)
end)

RegisterCommand("setmodel", function(source, args, rawCommand)
	local model = args[1]
	local myPed = GetPlayerPed(-1)
	local modelhashed = GetHashKey(model)
	RequestModel(modelhashed)

    Citizen.CreateThread(function() 
		local waiting = 0
		while not HasModelLoaded(modelhashed) do 
			waiting = waiting + 100
			RequestModel(modelhashed)
			Citizen.Wait(100)
			if waiting > 5000 then
				ShowNotification("~r~Model not found.")
                return
			end
		end
		SetPlayerModel(PlayerId(), modelhashed)
		SetModelAsNoLongerNeeded(modelhashed)
		ShowNotification("~g~Your model has been changed.")
	end)
end)

RegisterCommand('spawncar', function(source, args, rawCommand)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local veh = args[1]
    if veh == nil then veh = "adder" end
    vehiclehash = GetHashKey(veh)
    RequestModel(vehiclehash)
    
    Citizen.CreateThread(function() 
        local waiting = 0
        while not HasModelLoaded(vehiclehash) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                ShowNotification("~r~Vehicle not found.")
                return
            end
        end
        CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 0)
    end)
end)

TriggerEvent('chat:addSuggestion', '/giveweapon', 'Give weapon command.', {
    { name="weapon_key", help="Example: weapon_pistol" }
})

TriggerEvent('chat:addSuggestion', '/setmodel', 'Set model command.', {
    { name="ped_key", help="Example: csb_ballasog" }
})

TriggerEvent('chat:addSuggestion', '/spawncar', 'Spawn car command.', {
    { name="car_key", help="Example: buzzard2" }
})