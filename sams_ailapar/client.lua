local QBCore = exports['qb-core']:GetCoreObject()
local ox_inventory = exports.ox_inventory
local spawnedPed = nil

local function CreatePedAtCoords(pedModel, coords, scenario)
    pedModel = type(pedModel) == "string" and joaat(pedModel) or pedModel
    lib.requestModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z - 0.98, coords.w, false, false)
    TaskStartScenarioInPlace(ped, scenario, true)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    return ped
end

local function initStarterpack()
    spawnedPed = CreatePedAtCoords(Config.PedModels, Config.Position, Config.Scenario)
    exports.ox_target:addLocalEntity(spawnedPed, {
        {
            name = 'sams-food',
            icon = 'fab fa-box',
            label = "Order Food",
            distance = 1.6,
            event = "order:makan",
        },

    })
end

RegisterNetEvent('order:makan', function()
    exports['qb-menu']:openMenu({
        {
            header = 'MENU ORDERAN',
            icon = 'fas fa-gear',
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = 'BURGER AND COLA',
            txt = 'Price: 1000',
            icon = '',--- input url ficture
            params = {
                event = 'cek:makan',
                args = {
		        message = 'This was called by clicking a button'
                }
            }
        },
    })
end)

RegisterNetEvent('cek:makan', function(source, args, raw)
    local src = source
    local plyCoords = GetEntityCoords(PlayerPedId())
    QBCore.Functions.TriggerCallback('sulsul:pedOnline', function(PEDOnline, hasEnoughMoney)
        if PEDOnline <= Config.Pedagang and hasEnoughMoney then
            BuyFoods()
            Notify("Processing Cooking")
        else
            if PEDOnline > Config.Pedagang then
                Notify("There are too many pedagang online", "error")
            elseif not hasEnoughMoney then
                Notify("Not Enough Money", "error")
            else
                Notify("Wait pedagang is on its Way", "primary")
            end
        end
    end)
end)

function BuyFoods()
    ExecuteCommand('e clipboard')
    QBCore.Functions.Progressbar("order_npc", "you are ordering", 10000, false, false, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('sulsul:item')
        TriggerServerEvent('sulsul:payment')
        ExecuteCommand('e c')
    end)
end

function Notify(msg, state)
    QBCore.Functions.Notify(msg, state)
end

AddEventHandler('onResourceStart', function(resource)
    if not cache.resource then return end
    initStarterpack()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    initStarterpack()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DeleteEntity(spawnedPed)
end)

AddEventHandler('onResourceStop', function(resource)
    if not cache.resource then return end
    DeleteEntity(spawnedPed)
end)
