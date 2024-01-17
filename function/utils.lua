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
    local Player = QBCore.Functions.GetPlayer(src)
    local player_xp = MySQL.scalar.await('SELECT `crafting_level` FROM `players` WHERE `citizenid` = ?', {
        Player.PlayerData.citizenid
    })
    return player_xp
end

function GivePlayerXp(source, xp)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local getPlayerXp = GetPlayerXp()
    local total_xp = getPlayerXp + xp
    local affectedRows = MySQL.update.await('UPDATE players SET `crafting_level` = ? WHERE citizenid = ?', {
        total_xp, Player.PlayerData.citizenid
    })
    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        title = lang.notify_earned_xp.." "..Crafting.ExperiancePerCraft.."xp",
        position = 'top',
        description = '',
        5000
    })
end