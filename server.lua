QBCore = exports['qb-core']:GetCoreObject()

lib.callback.register('px_crafting:getItemCount', function(source, item)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local hasEnoughItems = true
    for k, v in pairs(item) do
        local c = exports.ox_inventory:GetItem(src, v.itemName, nil, false)
        debug(c.label .. " " .. c.count)

        if c.count < v.quantity then
            hasEnoughItems = false
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                title = 'You do not have: ' .. c.label.." Required "..v.quantity,
                position = 'top',
                description = '',
                5000
            })
        end
    end

    if hasEnoughItems then
        local info = {}
        info.value = true
        info.xp = GetPlayerXp()
        debug(info)
        return info
    else
        local info = {}
        info.value = false
        return info
    end
end)

RegisterNetEvent('px_crafting:removeItem')
AddEventHandler('px_crafting:removeItem', function(item, weapon)
    for k,v in pairs(item) do
        exports.ox_inventory:RemoveItem(source, v.itemName, v.quantity, nil, nil)
    end
    if Crafting.XpSystem then
        exports.ox_inventory:AddItem(source, weapon, 1, nil, nil)
        exports["px_weapon-crafting"]:addPlayerXp(source, Crafting.ExperiancePerCraft)
    else
        exports.ox_inventory:AddItem(source, weapon, 1, nil, nil)
    end
end)

RegisterNetEvent('px_crafting:SaveTable')
AddEventHandler('px_crafting:SaveTable', function(name, coordsx, coordsy, coordsz, heading)
    local loadFile= LoadResourceFile(GetCurrentResourceName(), "./positionTable.json")
    if loadFile ~= nil then
        local extract = json.decode(loadFile)
        if type(extract) == "table" then
            debug(extract)
            table.insert(extract, {name = name, coords = vector3(coordsx, coordsy, coordsz), heading = heading})
            SaveResourceFile(GetCurrentResourceName(), "positionTable.json",  json.encode(extract, { indent = true }), -1)
        else
            local Table = {}
            table.insert(Table, {name = name, coords = vector3(coordsx, coordsy, coordsz), heading = heading})
            SaveResourceFile(GetCurrentResourceName(), "positionTable.json",  json.encode(Table, { indent = true }), -1)
        end
    end
end)

RegisterNetEvent('px_weapon_crafting:DeleteEntity')
AddEventHandler('px_weapon_crafting:DeleteEntity', function(coords, name)
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./positionTable.json ")
    if loadFile ~= nil then
        local extract = json.decode(loadFile)
        if type(extract) == "table" then
            for k,v in ipairs(extract) do
                if v.name == name then
                    debug(v.coords)
                    debug(k)
                    table.remove(extract, k)
                    SaveResourceFile(GetCurrentResourceName(), "positionTable.json",  json.encode(extract, { indent = true }), -1)
                end
            end
        end
    end
end)

lib.callback.register('px_crafting:getTablePosition', function(source)
    local loadFile= LoadResourceFile(GetCurrentResourceName(), "./positionTable.json")
    if loadFile ~= nil then
        local extract = json.decode(loadFile)
        return extract
    end
end)

lib.addCommand({Crafting.CommandGive}, {
	help = 'Gives player crafting XP',
	params = {
		{ name = 'target', type = 'playerId', help = 'The player to receive the XP' },
        { name = 'amount', type = 'number', help = 'Amount of XP to give' },
	},
	restricted = 'group.admin',
}, function(source, args)
    exports["px_weapon-crafting"]:addPlayerXp(args.target, args.amount)
end)

lib.addCommand({Crafting.Command}, {
	help = 'Place down a crafting table',
	params = {},
	restricted = 'group.admin',
}, function(source, args)

    TriggerClientEvent('px_crafting:placeProp', source, Crafting.PropBench)

end)

lib.addCommand({Crafting.CommandShow}, {
	help = 'Place down a crafting table',
	params = {},
	restricted = 'group.admin',
}, function(source, args)
    TriggerClientEvent('px_crafting:showCrafting', source)
end)


exports("addPlayerXp", function(source, xp)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local player_xp = MySQL.scalar.await('SELECT `crafting_level` FROM `players` WHERE `citizenid` = ?', {
        xPlayer.PlayerData.citizenid
    })
    local givexp = player_xp + tonumber(xp)
    local affectedRows = MySQL.update.await('UPDATE players SET `crafting_level` = ? WHERE citizenid = ?', {
        givexp, xPlayer.PlayerData.citizenid
    })

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        title = lang.notify_earned_xp.." "..xp.."xp",
        position = 'top',
        description = '',
        5000
    })
end)
