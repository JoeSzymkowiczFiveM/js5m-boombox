local QBCore = exports['qb-core']:GetCoreObject()

local boombox = nil
local holdingBoombox = false

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        NetworkRequestControlOfEntity(boombox)
        while not NetworkHasControlOfEntity(boombox) do
            NetworkRequestControlOfEntity(boombox)
            Wait(1)
        end

        DeleteEntity(boombox)
        local net = NetworkGetNetworkIdFromEntity(boombox)
        TriggerServerEvent("js5m-boombox:server:stopBoombox", {netId = net})
    end
end)

--Functions
local function HoldBoombox(net)
	CreateThread(function()
        local object = NetworkGetEntityFromNetworkId(net)

        NetworkRequestControlOfNetworkId(net)
        while not NetworkHasControlOfNetworkId(net) do
            NetworkRequestControlOfNetworkId(net)
            Wait(1)
        end
        
        local alreadyEnteredZone = false
		while holdingBoombox do
			inZone  = true

            if IsControlJustReleased(0, 38) then
                holdingBoombox = false
                inZone  = false
                lib.requestAnimDict("pickup_object", 100)
                TaskPlayAnim(cache.ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
                Wait(1300)
                ClearPedTasks(cache.ped)
                DetachEntity(object, true, true)
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
            end

			if inZone and not alreadyEnteredZone then
                lib.showTextUI('[E] - Put Down Boombox')
				alreadyEnteredZone = true
			end

			if not inZone and alreadyEnteredZone then
                lib.hideTextUI()
				alreadyEnteredZone = false
			end
			Wait(0)
		end
	end)
end

--Events
RegisterNetEvent('js5m-boombox:client:attach', function(data)
    local netId = data.netId
    local object = NetworkGetEntityFromNetworkId(netId)

    NetworkRequestControlOfNetworkId(netId)
    while not NetworkHasControlOfNetworkId(netId) do
        NetworkRequestControlOfNetworkId(netId)
        Wait(1)
    end

    lib.requestAnimDict("pickup_object", 100)
    TaskPlayAnim(cache.ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(1300)
    ClearPedTasks(cache.ped)
    AttachEntityToEntity(object, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.30, 0, 0, 0, 260.0, 60.0, true, true, false, true, 1, true)
    holdingBoombox = true
    --TriggerEvent("carryBoombox", net)
    HoldBoombox(netId)
end)

RegisterNetEvent("js5m-boombox:client:putAwayBoombox", function(data)
    local netId = data.netId
    local object = NetworkGetEntityFromNetworkId(netId)
    lib.callback('js5m-boombox:server:putAwayBoombox', false, function(result)
        if not result then return end
        NetworkRequestControlOfEntity(object)
        while not NetworkHasControlOfEntity(object) do
            NetworkRequestControlOfEntity(object)
            Wait(10)
        end

        lib.requestAnimDict("pickup_object", 100)
        TaskPlayAnim(cache.ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
        Wait(1300)
        ClearPedTasks(cache.ped)
        DeleteEntity(object)
        boombox = nil
        TriggerServerEvent("js5m-boombox:server:stopBoombox", {netId = netId})

        exports.ox_target:removeEntity(netId, { 'boombox:standard' })

    end)
end)

RegisterNetEvent("js5m-boombox:client:placeBoombox", function(item, player, sourceCoords, sourceHeading)
    if not boombox then
        local ped = GetPlayerPed(GetPlayerFromServerId(player))
        local coords = sourceCoords
        local heading = sourceHeading
        local forward = GetEntityForwardVector(ped)
        local x, y, z = table.unpack(coords + forward * 0.5)
        lib.requestAnimDict("pickup_object", 100)
        TaskPlayAnim(ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
        Wait(1300)
        ClearPedTasks(ped)
        boombox = CreateObject(`prop_boombox_01`, x, y, z, true, false, false)
        Wait(50)
        local netId = NetworkGetNetworkIdFromEntity(boombox)
        SetEntityHeading(boombox, heading + 180.0)
        --SetModelAsNoLongerNeeded(object)
        PlaceObjectOnGroundProperly(boombox)
        FreezeEntityPosition(boombox, true)

        exports.ox_target:addEntity(netId, {
            {
                name = 'boombox:standard',
                event = "js5m-boombox:client:boomBoxMenu2",
                icon = "fa-solid fa-radio",
                label = "Boombox",
                netId = netId,
            },
        })
    else
        lib.notify({
            title = 'Boombox',
            description = 'Boombox already put down',
            type = 'error'
        })
    end
end)

RegisterNetEvent("js5m-boombox:client:boomBoxMenu2", function(data)
    local netId = data.netId
    local isSoundIdPlaying = exports['chHyperSound']:IsSoundIdPlaying("boombox_"..tostring(netId))
    local registeredMenu = {
        id = 'js5m-boombox_menu',
        title = 'Boombox Menu',
        options = {}
    }
    local options = {}
    local tapeOptions = {}

    if not isSoundIdPlaying and boombox then
        options[#options+1] = {
            title = 'Tape Selection',
            menu = 'js5m-boombox_tape_menu',
            description = 'Select the map to play on',
        }
    elseif isSoundIdPlaying then
        options[#options+1] = {
            title = 'Stop Boombox',
            description = "Put boombox in your pocket",
            serverEvent = 'js5m-boombox:server:stopBoombox',
            args = {netId = netId},
        }

        options[#options+1] = {
            title = 'Increase Volume',
            description = "Increase boombox volume",
            serverEvent = 'js5m-boombox:server:increaseVolume',
            args = {netId = netId},
        }
        options[#options+1] = {
            title = 'Decrease Volume',
            description = "Decrease boombox volume",
            serverEvent = 'js5m-boombox:server:decreaseVolume',
            args = {netId = netId},
        }        
    end

    for k, v in pairs(QBCore.Functions.GetPlayerData().items) do
        if Config.SongsList[v.name] ~= nil then
            tapeOptions[#tapeOptions+1] = {
                title = Config.SongsList[v.name]["song"],
                description = "By " .. Config.SongsList[v.name]["artist"],
                serverEvent = 'js5m-boombox:server:playBoombox',
                args = {song = Config.SongsList[v.name]["file"], netId = netId},
            }
        end
    end

    registeredMenu[#registeredMenu+1] = {
        id = 'js5m-boombox_tape_menu',
        title = 'Song Selection',
        menu = 'js5m-boombox_menu',
        options = tapeOptions
    }

    options[#options+1] = {
        title = 'Putaway Boombox',
        description = "Put boombox in your pocket",
        event = 'js5m-boombox:client:putAwayBoombox',
        args = {netId = netId},
    }

    options[#options+1] = {
        title = 'Pickup Boombox',
        description = "Carry the boombox",
        event = 'js5m-boombox:client:attach',
        args = {netId = netId},
    }

    registeredMenu["options"] = options
    
    lib.registerContext(registeredMenu)
    lib.showContext('js5m-boombox_menu')
end)

--Boombox Control Events
RegisterNetEvent("js5m-boombox:client:playBoombox", function(data)
    local song = data.song
    local object = data.netId
    TriggerServerEvent("js5m-boombox:server:playBoombox", song, object)
end)

RegisterNetEvent("qb-boombox:client:decreaseVolume", function(object)
    TriggerServerEvent("qb-boombox:server:decreaseVolume", object)
end)

RegisterNetEvent("qb-boombox:client:increaseVolume", function(object)
    TriggerServerEvent("qb-boombox:server:increaseVolume", object)
end)

RegisterNetEvent("qb-boombox:client:increaseVolume", function(object)
    TriggerServerEvent("qb-boombox:server:increaseVolume", object)
end)

