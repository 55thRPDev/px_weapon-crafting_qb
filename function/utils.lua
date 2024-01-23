QBCore = exports['qb-core']:GetCoreObject()


function debug(...)
    if Crafting.EnableDebug then
        local args = { ... }

        for i = 1, #args do
            local arg = args[i]
            args[i] = type(arg) == 'table' and json.encode(arg, { sort_keys = true, indent = true }) or tostring(arg)
        end

        print('^1[DEBUG] ^7', table.concat(args, '\t'))
    end
end

function GetJobPlayer()
    local playerInfo = QBCore.Functions.GetPlayerData()
    local name = playerInfo.job.name
    return name
end


function GetGangPlayer()
    local playerInfo = QBCore.Functions.GetPlayerData()
    local name = playerInfo.gang.name
    return name
end

function GetPlayerXp()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local player_xp = MySQL.scalar.await('SELECT `crafting_level` FROM `players` WHERE `citizenid` = ?', {
        xPlayer.PlayerData.citizenid
    })
    return player_xp
end