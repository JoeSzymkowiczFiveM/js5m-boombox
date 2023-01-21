local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("boombox", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local sourcePed = GetPlayerPed(src)
    local sourceCoords = GetEntityCoords(sourcePed)
    local x, y, z = table.unpack(sourceCoords)
    local sourceCoordsPacked = vec3(x, y, z - 1.0)
    local sourceHeading = GetEntityHeading(sourcePed)
    if Player.Functions.RemoveItem('boombox', 1) then
        TriggerClientEvent('js5m-boombox:client:placeBoombox', src, item, src, sourceCoordsPacked, sourceHeading)
    end
end)

lib.callback.register('js5m-boombox:server:putAwayBoombox', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.AddItem('boombox', 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['boombox'], "add")
        return(true)
    else
        return(false)
    end
end)

RegisterServerEvent('js5m-boombox:server:playBoombox', function(data)
    local src = source
    local song = data.song
    local netId = data.netId
    local soundId = "boombox_"..tostring(netId)    
    TriggerEvent('chHyperSound:playOnEntity', netId, soundId, song, false, 15)
end)

RegisterServerEvent('js5m-boombox:server:decreaseVolume', function(data)
    local uniqueId = "boombox_"..tostring(data.netId)
    TriggerEvent('chHyperSound:decreaseVolume', uniqueId)
end)

RegisterServerEvent('js5m-boombox:server:increaseVolume', function(data)
    local uniqueId = "boombox_"..tostring(data.netId)
    TriggerEvent('chHyperSound:increaseVolume', uniqueId)
end)

RegisterServerEvent('js5m-boombox:server:stopBoombox', function(data)
    local object = data.netId
    local uniqueId = "boombox_"..tostring(object)
    TriggerEvent('chHyperSound:stop', uniqueId)
end)

RegisterServerEvent('js5m-boombox:server:filterSound', function(data)
    local object = data.netId
    local uniqueId = "boombox_"..tostring(object)
    TriggerEvent('chHyperSound:filterSound', uniqueId, 'muffled')
end)

RegisterServerEvent('js5m-boombox:server:removeFilter', function(data)
    local object = data.netId
    local uniqueId = "boombox_"..tostring(object)
    TriggerEvent('chHyperSound:removeFilter', uniqueId)
end)

RegisterServerEvent('js5m-boombox:server:updateCoords', function(object, coords)
    local uniqueId = "boombox_"..tostring(object)
    exports['xyz-3dsound']:UpdateCoords(uniqueId, coords)
end)