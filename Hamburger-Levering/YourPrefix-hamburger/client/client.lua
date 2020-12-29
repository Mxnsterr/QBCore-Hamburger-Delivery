YourCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if YourCore == nil then
            TriggerEvent('YourCore:GetObject', function(obj) YourCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

isLoggedIn = true
local PlayerJob = {}
local JobsDone = 0
local LocationsDone = {}
local CurrentLocation = nil
local CurrentBlip = nil
local hasBurger = false
local isWorking = false
local currentCount = 0
local CurrentPlate = nil
local CurrentTow = nil

local selectedVeh = nil
local AutoBlip = nil

RegisterNetEvent('YourCore:Client:OnPlayerLoaded')
AddEventHandler('YourCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = YourCore.Functions.GetPlayerData().job
    CurrentLocation = nil
    CurrentBlip = nil
    hasBurger = false
    isWorking = false
    JobsDone = 0

    if PlayerJob.name == "hamburger" then
        AutoBlip = AddBlipForCoord(Config.Locaties["auto"].coords.x, Config.Locaties["auto"].coords.y, Config.Locaties["auto"].coords.z)
        SetBlipSprite(AutoBlip, 225)
        SetBlipDisplay(AutoBlip, 4)
        SetBlipScale(AutoBlip, 0.6)
        SetBlipAsShortRange(AutoBlip, true)
        SetBlipColour(AutoBlip, 30)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locaties["auto"].label)
        EndTextCommandSetBlipName(AutoBlip)
    end
end)

RegisterNetEvent('YourCore:Client:OnPlayerUnload')
AddEventHandler('YourCore:Client:OnPlayerUnload', function()
    RemoveKlantBlips()
    CurrentLocation = nil
    CurrentBlip = nil
    hasBurger = false
    isWorking = false
    JobsDone = 0
end)

RegisterNetEvent('YourCore:Client:OnJobUpdate')
AddEventHandler('YourCore:Client:OnJobUpdate', function(JobInfo)
    local OldlayerJob = PlayerJob.name
    PlayerJob = JobInfo

    if PlayerJob.name == "hamburger" then
        AutoBlip = AddBlipForCoord(Config.Locaties["auto"].coords.x, Config.Locaties["auto"].coords.y, Config.Locaties["auto"].coords.z)
        SetBlipSprite(AutoBlip, 225)
        SetBlipDisplay(AutoBlip, 4)
        SetBlipScale(AutoBlip, 0.6)
        SetBlipAsShortRange(AutoBlip, true)
        SetBlipColour(AutoBlip, 30)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locaties["auto"].label)
        EndTextCommandSetBlipName(AutoBlip)
    elseif OldlayerJob == "hamburger" then
        RemoveKlantBlips()
    end
end)

Citizen.CreateThread(function()
    local HamburgerBlip = AddBlipForCoord(Config.Locaties["blip"].coords.x, Config.Locaties["blip"].coords.y, Config.Locaties["blip"].coords.z)
    SetBlipSprite(HamburgerBlip, 276)
    SetBlipDisplay(HamburgerBlip, 4)
    SetBlipScale(HamburgerBlip, 0.6)
    SetBlipAsShortRange(HamburgerBlip, true)
    SetBlipColour(HamburgerBlip, 30)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locaties["blip"].label)
    EndTextCommandSetBlipName(HamburgerBlip)
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and YourCore ~= nil then
            if PlayerJob.name == "hamburger" then
                if IsControlJustReleased(0, Keys["DEL"]) then
                    if IsPedInAnyVehicle(GetPlayerPed(-1)) and isHamburgerVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
                        getNewLocation()
                        CurrentPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                    end
                end
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locaties["auto"].coords.x, Config.Locaties["auto"].coords.y, Config.Locaties["auto"].coords.z, true) < 10.0) then
                    DrawMarker(36, Config.Locaties["auto"].coords.x, Config.Locaties["auto"].coords.y, Config.Locaties["auto"].coords.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 54, 149, 140, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locaties["auto"].coords.x, Config.Locaties["auto"].coords.y, Config.Locaties["auto"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            DrawText3D(Config.Locaties["auto"].coords.x, Config.Locaties["auto"].coords.y, Config.Locaties["auto"].coords.z, "~g~E~w~ - Zet voertuig weg")
                        else
                            DrawText3D(Config.Locaties["auto"].coords.x, Config.Locaties["auto"].coords.y, Config.Locaties["auto"].coords.z + 0.5, "~g~E~w~ - Voertuig nemen")
                        end
                        if IsControlJustReleased(0, Keys["E"]) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1) then
                                    if isHamburgerVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
                                        DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                        TriggerServerEvent('YourPrefix-hamburger:server:Waarborg', false)
                                    else
                                        YourCore.Functions.Notify('Dit is niet het bedrijfsvoertuig!', 'error')
                                    end
                                else
                                    YourCore.Functions.Notify('Je moet de chauffeur zijn..')
                                end
                            else
                                MenuGarage()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                end
    
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locaties["blip"].coords.x, Config.Locaties["blip"].coords.y, Config.Locaties["blip"].coords.z, true) < 4.5) then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locaties["blip"].coords.x, Config.Locaties["blip"].coords.y, Config.Locaties["blip"].coords.z, true) < 1.5) then
                        DrawText3D(Config.Locaties["blip"].coords.x, Config.Locaties["blip"].coords.y, Config.Locaties["blip"].coords.z, "~g~E~w~ - Loon nemen")
                        if IsControlJustReleased(0, Keys["E"]) then
                            RemoveBlip(bedrijfBlip)
                            print("Goed gewerkt - made by Mxnsterr")
                            if JobsDone > 0 then
                                TriggerServerEvent("YourPrefix-hamburger:server:loonBerekening", JobsDone)
                                JobsDone = 0
                                if #LocationsDone == #Config.Locaties["klanten"] then
                                    LocationsDone = {}
                                end
                                if CurrentBlip ~= nil then
                                    RemoveBlip(CurrentBlip)
                                    CurrentBlip = nil
                                end
                            else
                                YourCore.Functions.Notify("Je hebt nog geen werk gedaan..", "error")
                            end
                        end
                    elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locaties["blip"].coords.x, Config.Locaties["blip"].coords.y, Config.Locaties["blip"].coords.z, true) < 2.5) then
                        DrawText3D(Config.Locaties["blip"].coords.x, Config.Locaties["blip"].coords.y, Config.Locaties["blip"].coords.z, "Loon")
                    end  
                end
    
                if CurrentLocation ~= nil  and currentCount < CurrentLocation.dropcount then
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, true) < 40.0 then
                        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                            if not hasBurger then
                                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
                                if isHamburgerVehicle(vehicle) and CurrentPlate == GetVehicleNumberPlateText(vehicle) then
                                    local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -1.5, 0.5)
                                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos.x, trunkpos.y, trunkpos.z, true) < 1.5 and not isWorking then
                                        DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z, "~g~E~w~ - Burgers nemen")
                                        if IsControlJustReleased(0, Keys["E"]) then
                                            isWorking = true
                                            YourCore.Functions.Progressbar("hamburger_nemen", "Burgers uithalen..", 2000, false, true, {
                                                disableMovement = true,
                                                disableCarMovement = true,
                                                disableMouse = false,
                                                disableCombat = true,
                                                TriggerServerEvent("police:server:SetHandcuffStatus", true)
                                            }, {
                                                animDict = "anim@gangops@facility@servers@",
                                                anim = "hotwire",
                                                flags = 16,
                                            }, {}, {}, function()
                                                TriggerServerEvent("police:server:SetHandcuffStatus", false)
                                                isWorking = false
                                                StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                                TriggerEvent('animations:client:EmoteCommandStart', {"box"})
                                                hasBurger = true
                                            end, function()
                                                isWorking = false
                                                StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                                YourCore.Functions.Notify("Canceled..", "error")
                                            end)
                                        end
                                    else
                                        DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z, "Haal burgers uit laadbak")
                                    end
                                end
                            elseif hasBurger then
                                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, true) < 1.5 and not isWorking then
                                    DrawText3D(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, "~g~E~w~ - Burgers afleveren")
                                    if IsControlJustReleased(0, Keys["E"]) then
                                        isWorking = true
                                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                        Citizen.Wait(500)
                                        TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
                                        YourCore.Functions.Progressbar("work_dropbox", "Burgers afleveren..", 4500, false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                            TriggerServerEvent("police:server:SetHandcuffStatus", true)
                                        }, {}, {}, {}, function() -- Done
                                            print("Goed geleverd - made by Mxnsterr")
                                            TriggerServerEvent("police:server:SetHandcuffStatus", false)
                                            isWorking = false
                                            ClearPedTasks(GetPlayerPed(-1))
                                            hasBurger = false
                                            currentCount = currentCount + 1
                                            if currentCount == CurrentLocation.dropcount then
                                                table.insert(LocationsDone, CurrentLocation.id)
                                                YourCore.Functions.Notify("U heeft alle burgers geleverd ga naar het volgende punt")
                                                if CurrentBlip ~= nil then
                                                    RemoveBlip(CurrentBlip)
                                                    CurrentBlip = nil
                                                end
                                                CurrentLocation = nil
                                                currentCount = 0
                                                JobsDone = JobsDone + 1
                                                getNewLocation()
                                            end
                                        end, function() -- Cancel
                                            isWorking = false
                                            ClearPedTasks(GetPlayerPed(-1))
                                            YourCore.Functions.Notify("Geannuleerd..", "error")
                                        end)
                                    end
                                else
                                    DrawText3D(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, "Burgers afleveren")
                                end
                            end
                        end
                    end
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

function getNewLocation()
    local location = getNextClosestLocation()
    
    local bedrijf = {}
    bedrijf.x = Config.Locaties["auto"].coords.x
    bedrijf.y = Config.Locaties["auto"].coords.y
    bedrijf.z = Config.Locaties["auto"].coords.z
    if location ~= 0 then
        CurrentLocation = {}
        CurrentLocation.id = location
        CurrentLocation.dropcount = math.random(1, 3)
        CurrentLocation.store = Config.Locaties["klanten"][location].name
        CurrentLocation.x = Config.Locaties["klanten"][location].coords.x
        CurrentLocation.y = Config.Locaties["klanten"][location].coords.y
        CurrentLocation.z = Config.Locaties["klanten"][location].coords.z

        CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
        SetBlipColour(CurrentBlip, 43)
        SetBlipRoute(CurrentBlip, true)
        SetBlipRouteColour(CurrentBlip, 43)
    else
        YourCore.Functions.Notify("Je bent naar alle klanten geweest. Tijd voor je loon!")
        if CurrentBlip ~= nil then
            RemoveBlip(CurrentBlip)
            CurrentBlip = nil

        end

        bedrijfBlip = AddBlipForCoord(bedrijf.x, bedrijf.y, bedrijf.z)
          SetBlipColour(bedrijfBlip, 17)
          SetBlipRoute(bedrijfBlip, true)
          SetBlipRouteColour(bedrijfBlip, 17)
        end
    end

function getNextClosestLocation()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = 0
    local dist = nil

    for k, _ in pairs(Config.Locaties["klanten"]) do
        if current ~= 0 then
            if(GetDistanceBetweenCoords(pos, Config.Locaties["klanten"][k].coords.x, Config.Locaties["klanten"][k].coords.y, Config.Locaties["klanten"][k].coords.z, true) < dist)then
                if not hasDoneLocation(k) then
                    current = k
                    dist = GetDistanceBetweenCoords(pos, Config.Locaties["klanten"][k].coords.x, Config.Locaties["klanten"][k].coords.y, Config.Locaties["klanten"][k].coords.z, true)    
                end
            end
        else
            if not hasDoneLocation(k) then
                current = k
                dist = GetDistanceBetweenCoords(pos, Config.Locaties["klanten"][k].coords.x, Config.Locaties["klanten"][k].coords.y, Config.Locaties["klanten"][k].coords.z, true)    
            end
        end
    end

    return current
end

function hasDoneLocation(locationId)
    local retval = false
    if LocationsDone ~= nil and next(LocationsDone) ~= nil then 
        for k, v in pairs(LocationsDone) do
            if v == locationId then
                retval = true
            end
        end
    end
    return retval
end

function isHamburgerVehicle(vehicle)
    local retval = false
    for k, v in pairs(Config.Wagen) do
        if GetEntityModel(vehicle) == GetHashKey(k) then
            retval = true
        end
    end
    return retval
end

function MenuGarage()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Voertuigen", "VehicleList", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Vehicles:"
    ClearMenu()
    for k, v in pairs(Config.Wagen) do
        Menu.addButton(Config.Wagen[k], "TakeOutVehicle", k, "Garage", " Motor: 100%", " Body: 100%", " Brandstof: 100%")
    end
        
    Menu.addButton("Back", "MenuGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
    TriggerServerEvent('YourPrefix-hamburger:server:Waarborg', true, vehicleInfo)
    selectedVeh = vehicleInfo
end

function RemoveKlantBlips()
    if AutoBlip ~= nil then
        RemoveBlip(AutoBlip)
        AutoBlip = nil
    end

    if CurrentBlip ~= nil then
        RemoveBlip(CurrentBlip)
        CurrentBlip = nil
    end
end

RegisterNetEvent('YourPrefix-hamburger:client:SpawnVehicle')
AddEventHandler('YourPrefix-hamburger:client:SpawnVehicle', function()
    local vehicleInfo = selectedVeh
    local coords = Config.Locaties["auto"].coords
    YourCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "HAMB"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
        getNewLocation()
    end, coords, true)
end)

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end