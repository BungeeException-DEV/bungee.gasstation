local ESX = exports['es_extended']:getSharedObject()

local isFueling = false
local currentFuelPrice = 0
local currentFuelingVehicle = nil
local progressBarActive = false

-- Blips und Tankstellen
Citizen.CreateThread(function()
    for i, gasStation in ipairs(Config.GasStations) do
        local blip = AddBlipForCoord(gasStation.x, gasStation.y, gasStation.z)
        SetBlipSprite(blip, 361)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Tankstelle")
        EndTextCommandSetBlipName(blip)
    end
end)

-- Spielerinteraktionen
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if not IsPedInAnyVehicle(ped, false) and not isFueling then
            local vehicle = GetClosestVehicle(coords, 2.5, 0, 71)

            if DoesEntityExist(vehicle) then
                ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um zu tanken")
                if IsControlJustReleased(0, 38) then
                    isFueling = true
                    currentFuelingVehicle = vehicle
                    currentFuelPrice = GetRandomFuelPrice()

                    -- HUD öffnen
                    SendNUIMessage({
                        action = "openFuelHUD",
                        fuelPrice = currentFuelPrice
                    })
                    SetNuiFocus(true, true)
                end
            end
        end

        if isFueling and progressBarActive then
            local vehicleCoords = GetEntityCoords(currentFuelingVehicle)
            DrawText3D(vehicleCoords, "Tanken...", 0.0)
            DrawText3D(vehicleCoords, "Fortschritt: " .. math.floor(fuelingProgress) .. "%", 0.2)
        end
    end
end)

-- Zufälliger Kraftstoffpreis
function GetRandomFuelPrice()
    return math.random(Config.FuelPrice.min * 100, Config.FuelPrice.max * 100) / 100
end

-- NUI-Callbacks
RegisterNUICallback('fuelConfirm', function(data, cb)
    local method = data.method
    local vehicle = currentFuelingVehicle
    local amount = 100.0 - GetVehicleFuelLevel(vehicle)  -- Volltanken bedeutet, auf 100% zu füllen

    StartFueling(vehicle, amount, method)

    cb('ok')
end)

RegisterNUICallback('cancelFuel', function(data, cb)
    StopFueling()
    cb('ok')
end)

-- Tankvorgang starten
function StartFueling(vehicle, amount, paymentMethod)
    local totalCost = amount * currentFuelPrice
    local fuelIncreaseRate = amount / 10

    -- Tank-Animation starten
    StartFuelingAnimation()

    ESX.TriggerServerCallback('bungee.gasstation:pay', function(success)
        if success then
            fuelingProgress = 0
            progressBarActive = true
            Citizen.CreateThread(function()
                while fuelingProgress < amount and isFueling do
                    Citizen.Wait(1000)
                    local newFuelLevel = math.min(GetVehicleFuelLevel(vehicle) + fuelIncreaseRate, 100.0)
                    SetVehicleFuelLevel(vehicle, newFuelLevel)
                    fuelingProgress = fuelingProgress + fuelIncreaseRate

                    if newFuelLevel >= 100.0 then
                        break
                    end
                end
                StopFueling()
                ESX.ShowNotification("Tankvorgang abgeschlossen. Du hast $" .. totalCost .. " bezahlt.")
            end)
        else
            ESX.ShowNotification("Du hast nicht genug Geld")
            StopFueling()
        end
    end, totalCost, paymentMethod)
end

-- Tank-Animation stoppen
function StopFueling()
    isFueling = false
    progressBarActive = false
    currentFuelingVehicle = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeFuelHUD" })
    StopFuelingAnimation()
end

-- Tank-Animation starten
function StartFuelingAnimation()
    local ped = PlayerPedId()
    RequestAnimDict("timetable@gardener@filling_can")
    while not HasAnimDictLoaded("timetable@gardener@filling_can") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 8.0, -8.0, -1, 49, 0, false, false, false)
end

-- Tank-Animation stoppen
function StopFuelingAnimation()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
end

-- Text über dem Fahrzeug anzeigen
function DrawText3D(coords, text, offsetZ)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z + offsetZ)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

-- Exportierte Funktionen
function SetFuel(vehicle, value)
    if DoesEntityExist(vehicle) and type(value) == "number" then
        SetVehicleFuelLevel(vehicle, value)
    end
end

function GetFuel(vehicle)
    if DoesEntityExist(vehicle) then
        return GetVehicleFuelLevel(vehicle)
    end
    return 0
end

exports('SetFuel', SetFuel)
exports('GetFuel', GetFuel)
