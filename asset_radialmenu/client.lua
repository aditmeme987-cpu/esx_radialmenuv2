local ESX = nil
local menuOpen = false
local currentMenu = 'main'
local previousMenu = 'main'

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Wait(200)
    end

    if ESX then
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob', function(job)
    if ESX then ESX.PlayerData.job = job end
end)

local function notify(msg)
    if Config.Notifications and ESX then
        ESX.ShowNotification(msg)
    end
end

local function isInVehicle()
    return IsPedInAnyVehicle(PlayerPedId(), false)
end

local function getItems(menu)
    if menu == 'vehicle' then return Config.VehicleItems end
    if menu == 'player' then return Config.PlayerItems end
    if menu == 'settings' then return Config.SettingsItems end

    local result = {}
    for _, item in ipairs(Config.MainItems) do
        if not item.vehicleOnly or isInVehicle() then
            result[#result + 1] = item
        end
    end
    return result
end

local function sendMenu()
    SendNUIMessage({
        type = 'open',
        title = Config.Title,
        subtitle = currentMenu == 'main' and Config.Subtitle or string.upper(currentMenu),
        menu = currentMenu,
        items = getItems(currentMenu)
    })
end

local function openMenu()
    if menuOpen then return end

    menuOpen = true
    currentMenu = 'main'
    previousMenu = 'main'

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    sendMenu()
end

local function closeMenu()
    menuOpen = false
    currentMenu = 'main'
    previousMenu = 'main'

    SetNuiFocus(false, false)

    SendNUIMessage({
        type = 'close'
    })
end

local function openSubMenu(name)
    previousMenu = currentMenu
    currentMenu = name
    sendMenu()
end

local function runCommand(command)
    if command and command ~= '' then
        ExecuteCommand(command)
        return true
    end
    return false
end

local function openInventory()
    closeMenu()

    -- ox_inventory
    if GetResourceState('ox_inventory') == 'started' then
        exports.ox_inventory:openInventory('player')
        return
    end

    -- Configured command
    if runCommand(Config.InventoryCommand) then return end

    -- Common ESX inventory command
    if GetResourceState('esx_inventoryhud') == 'started' then
        ExecuteCommand('openinventory')
        return
    end

    notify('Inventory belum dikonfigurasi di config.lua')
end

local function openPhone()
    closeMenu()

    if runCommand(Config.PhoneCommand) then return end

    -- Common phone commands can be enabled in config.
    notify('Phone belum dikonfigurasi di config.lua')
end

local function vehicleAction(action)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh == 0 then
        notify('Kamu harus berada di dalam kendaraan')
        return
    end

    if action == 'engine' then
        local state = GetIsVehicleEngineRunning(veh)
        SetVehicleEngineOn(veh, not state, false, true)
        notify(state and 'Engine OFF' or 'Engine ON')

    elseif action == 'hood' then
        if GetVehicleDoorAngleRatio(veh, 4) > 0.1 then
            SetVehicleDoorShut(veh, 4, false)
        else
            SetVehicleDoorOpen(veh, 4, false, false)
        end

    elseif action == 'trunk' then
        if GetVehicleDoorAngleRatio(veh, 5) > 0.1 then
            SetVehicleDoorShut(veh, 5, false)
        else
            SetVehicleDoorOpen(veh, 5, false, false)
        end

    elseif action == 'doors' then
        -- Toggle all doors.
        for door = 0, 5 do
            if GetVehicleDoorLockStatus(veh) ~= 2 then
                if GetVehicleDoorAngleRatio(veh, door) > 0.1 then
                    SetVehicleDoorShut(veh, door, false)
                else
                    SetVehicleDoorOpen(veh, door, false, false)
                end
            end
        end
    end

    closeMenu()
end

RegisterCommand('esxradial', function()
    if menuOpen then
        closeMenu()
    else
        openMenu()
    end
end, false)

RegisterKeyMapping('esxradial', 'Open ESX Radial Menu', 'keyboard', Config.OpenKey)

RegisterNUICallback('close', function(_, cb)
    closeMenu()
    cb('ok')
end)

RegisterNUICallback('select', function(data, cb)
    local action = data.action

    if action == 'back' then
        currentMenu = 'main'
        sendMenu()
        cb('ok')
        return
    end

    -- Main menu -> submenu.
    if currentMenu == 'main' then
        if action == 'vehicle' then
            if isInVehicle() then
                openSubMenu('vehicle')
            else
                notify('Kamu tidak berada di kendaraan')
            end
        elseif action == 'player' then
            openSubMenu('player')
        elseif action == 'settings' then
            openSubMenu('settings')
        elseif action == 'inventory' then
            openInventory()
        elseif action == 'phone' then
            openPhone()
        elseif action == 'job' then
            if ESX and ESX.PlayerData and ESX.PlayerData.job then
                notify(('Job: %s | Grade: %s'):format(
                    ESX.PlayerData.job.label or 'Unknown',
                    ESX.PlayerData.job.grade_label or ESX.PlayerData.job.grade or 'Unknown'
                ))
            end
            closeMenu()
        end

    elseif currentMenu == 'vehicle' then
        vehicleAction(action)

    elseif currentMenu == 'player' then
        if action == 'id' then
            local playerId = GetPlayerServerId(PlayerId())
            notify(('ID kamu: %s'):format(playerId))
            closeMenu()
        elseif action == 'job' then
            if ESX and ESX.PlayerData and ESX.PlayerData.job then
                notify(('Job: %s | Grade: %s'):format(
                    ESX.PlayerData.job.label or 'Unknown',
                    ESX.PlayerData.job.grade_label or ESX.PlayerData.job.grade or 'Unknown'
                ))
            end
            closeMenu()
        end

    elseif currentMenu == 'settings' then
        if action == 'hud' then
            if not runCommand(Config.HudCommand) then
                notify('Hud command belum dikonfigurasi')
            end
            closeMenu()
        elseif action == 'cursor' then
            if not runCommand(Config.CursorCommand) then
                notify('Cursor command belum dikonfigurasi')
            end
            closeMenu()
        end
    end

    cb('ok')
end)

CreateThread(function()
    while true do
        if menuOpen then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 200, true)

            if IsControlJustReleased(0, 322) then
                closeMenu()
            end

            Wait(0)
        else
            Wait(250)
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)
