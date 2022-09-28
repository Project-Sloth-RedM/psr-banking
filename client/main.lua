local PSRCore = exports['psr-core']:GetCoreObject()
local blips = {}
local peds = {}
local banks

-- Citizen.CreateThread(function()
--     for banks, v in pairs(Config.BankLocations) do
--         exports['psr-core']:createPrompt(v.bankname, v.coords, 0xF3830D8E, 'Open ' .. v.name, {
--             type = 'client',
--             event = 'psr-banking:openBankScreen',
--             args = { },
--         })
--         if v.showblip == true then
--             local BankBlip = N_0x554d9d53f696d002(1664425300, v.coords)
--             SetBlipSprite(BankBlip, Config.Blip.blipType, 1)
--             SetBlipScale(BankBlip, Config.Blip.blipScale)
--         end
--     end
-- end)

CreateThread(function()
    for k,v in pairs(Config.BankDoors) do
        --for v, door in pairs(k) do
        Citizen.InvokeNative(0xD99229FE93B46286,v,1,1,0,0,0,0)
        Citizen.InvokeNative(0x6BAB9442830C7F53,v,0)
    end
end)

-- Functions

local function openAccountScreen()
    PSRCore.Functions.TriggerCallback('psr-banking:getBankingInformation', function(banking)
        if banking ~= nil then
            SetNuiFocus(true, true)
            SendNUIMessage({
                status = "openbank",
                information = banking
            })
        end
    end)
end

-- Events

RegisterNetEvent('psr-banking:transferError', function(msg)
    SendNUIMessage({
        status = "transferError",
        error = msg
    })
end)

RegisterNetEvent('psr-banking:successAlert', function(msg)
    SendNUIMessage({
        status = "successMessage",
        message = msg
    })
end)

RegisterNetEvent('psr-banking:openBankScreen', function()
    openAccountScreen()
end)

local BankControlPress = false
 local function BankControl()
    CreateThread(function()
        BankControlPress = true
        while BankControlPress do
            if IsControlPressed(0, 38) then
                exports['psr-core']:KeyPressed()
                TriggerEvent('psr-banking:openBankScreen')
            end
            Wait(0)
        end
    end)
end

-- NUI

RegisterNetEvent("hidemenu", function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        status = "closebank"
    })
end)

RegisterNetEvent('psr-banking:client:newCardSuccess', function(cardno, ctype)
    SendNUIMessage({
        status = "updateCard",
        number = cardno,
        cardtype = ctype
    })
end)

-- NUI Callbacks

RegisterNUICallback("NUIFocusOff", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        status = "closebank"
    })
    cb("ok")
end)

RegisterNUICallback("createSavingsAccount", function(_, cb)
    TriggerServerEvent('psr-banking:createSavingsAccount')
    cb("ok")
end)

RegisterNUICallback("doDeposit", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('psr-banking:doQuickDeposit', data.amount)
        openAccountScreen()
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("doWithdraw", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('psr-banking:doQuickWithdraw', data.amount, true)
        openAccountScreen()
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("doATMWithdraw", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('psr-banking:doQuickWithdraw', data.amount, false)
        openAccountScreen()
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("savingsDeposit", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('psr-banking:savingsDeposit', data.amount)
        openAccountScreen()
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("savingsWithdraw", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('psr-banking:savingsWithdraw', data.amount)
        openAccountScreen()
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("doTransfer", function(data, cb)
    if data ~= nil then
        TriggerServerEvent('psr-banking:initiateTransfer', data)
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("createDebitCard", function(data, cb)
    if data.pin ~= nil then
        TriggerServerEvent('psr-banking:createBankCard', data.pin)
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("lockCard", function(_, cb)
    TriggerServerEvent('psr-banking:toggleCard', true)
    cb("ok")
end)

RegisterNUICallback("unLockCard", function(_, cb)
    TriggerServerEvent('psr-banking:toggleCard', false)
    cb("ok")
end)

RegisterNUICallback("updatePin", function(data, cb)
    if data.pin and data.currentBankCard then
        TriggerServerEvent('psr-banking:updatePin', data.currentBankCard, data.pin)
        cb("ok")
    end
    cb(nil)
end)

---------------------------------------------------
-------------- TARGET ZONES & BLIPS ---------------
---------------------------------------------------
RegisterNetEvent('psr-banking:StartUp', function()
    for k, v in pairs(Config.BankLocations) do

        -- BLIPS --
        if v.showblip == true then
            StoreBlip = N_0x554d9d53f696d002(1664425300, v.coords)
            SetBlipSprite(StoreBlip, -2128054417, 52)
            SetBlipScale(StoreBlip, 0.2)
        end
        table.insert(blips, StoreBlip)

        while not HasModelLoaded( GetHashKey(Config.BankLocations[k].model) ) do
            Wait(500)
            RequestModel( GetHashKey(Config.BankLocations[k].model) )
        end
        local npc = CreatePed(GetHashKey(Config.BankLocations[k].model), Config.BankLocations[k].coords.x, Config.BankLocations[k].coords.y, Config.BankLocations[k].coords.z - 1, Config.BankLocations[k].heading, false, false, 0, 0)
        while not DoesEntityExist(npc) do
            Wait(300)
        end
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        FreezeEntityPosition(npc, false)
        SetEntityInvincible(npc, true)
        TaskStandStill(npc, -1)
        Wait(100)
        SetPedRelationshipGroupHash(npc, GetHashKey(Config.BankLocations[k].model))
        SetEntityCanBeDamagedByRelationshipGroup(npc, false, `PLAYER`)
        SetEntityAsMissionEntity(npc, true, true)
        SetModelAsNoLongerNeeded(GetHashKey(Config.BankLocations[k].model))

        -- TARGET LOCATIONS --
        exports['psr-target']:AddCircleZone(v.name, v.coords, 1.0, { -- The name has to be unique, the coords a vector3 as shown and the 1.5 is the radius which has to be a float value
            name = v.name, -- This is the name of the zone recognized by PolyZone, this has to be unique so it doesn't mess up with other zones
            debugPoly = Config.Debug, -- This is for enabling/disabling the drawing of the box, it accepts only a boolean value (true or false), when true it will draw the polyzone in green
        }, {
            options = { -- This is your options table, in this table all the options will be specified for the target to accept
                {
                    type = "client",
                    event = "psr-banking:openBankScreen",
                    icon = 'fas fa-money-bill',
                    label = 'Banking'
                }
            },
            distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
        })

        table.insert(peds, npc)
    end
end)

-------------------------------------------
---------- RESOURCE START / STOP ----------
-------------------------------------------
AddEventHandler('PSRCore:Client:OnPlayerLoaded', function()
    TriggerEvent('psr-banking:StartUp') -- Zones and Blips
end)

AddEventHandler('PSRCore:Client:OnPlayerUnloaded', function()
    for k, v in pairs(Config.BankLocations) do
        exports['psr-target']:RemoveZone(v.name) -- Remove Zones for script restarts
    end
    for k,v in pairs(blips) do
        RemoveBlip(blips[k]) -- Remove Blips for script restarts
    end
    for _,v in pairs(peds) do
        DeletePed(v)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerEvent('psr-banking:StartUp') -- Zones and Blips
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k, v in pairs(Config.BankLocations) do
            exports['psr-target']:RemoveZone(v.name) -- Remove Zones for script restarts
        end
        for k,v in pairs(blips) do
            RemoveBlip(blips[k]) -- Remove Blips for script restarts
        end
        for _,v in pairs(peds) do
            DeletePed(v)
        end
    end
end)