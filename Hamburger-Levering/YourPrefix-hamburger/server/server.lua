YourCore = nil
TriggerEvent('YourCore:GetObject', function(obj) YourCore = obj end)

local PaymentTax = 21

local Bail = {}

RegisterServerEvent('YourPrefix-hamburger:server:Waarborg')
AddEventHandler('YourPrefix-hamburger:server:Waarborg', function(bool, vehInfo)
    local src = source
    local Player = YourCore.Functions.GetPlayer(src)

    if bool then
        if Player.PlayerData.money.cash >= Config.WaarBorg then
            Bail[Player.PlayerData.citizenid] = Config.WaarBorg
            Player.Functions.RemoveMoney('cash', Config.WaarBorg, "waarborg-afgenomen-cash")
            TriggerClientEvent('YourCore:Notify', src, 'Borg van €500 betaald, - (Contant) betaald', 'success')
            TriggerClientEvent('YourPrefix-hamburger:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.WaarBorg then
            Bail[Player.PlayerData.citizenid] = Config.WaarBorg
            Player.Functions.RemoveMoney('bank', Config.WaarBorg, "waarborg-afgenomen-bank")
            TriggerClientEvent('YourCore:Notify', src, 'Borg van €500 betaald, - (Bank) betaald', 'success')
            TriggerClientEvent('YourPrefix-hamburger:client:SpawnVehicle', src, vehInfo)
        else
            TriggerClientEvent('YourCore:Notify', src, 'U heeft niet genoeg contant geld, de borg is 500,-', 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('cash', Bail[Player.PlayerData.citizenid], "waarborg-terug")
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('YourCore:Notify', src, 'U heeft de borg van €500, - terug ontvangen', 'success')
        end
    end
end)

RegisterNetEvent('YourPrefix-hamburger:server:loonBerekening')
AddEventHandler('YourPrefix-hamburger:server:loonBerekening', function(drops)
    local src = source 
    local Player = YourCore.Functions.GetPlayer(src)
    local drops = tonumber(drops)
    local bonus = 0
    local DropPrice = math.random(150, 300)
    if drops > 5 then 
        bonus = math.ceil((DropPrice / 100) * 5) + 100
    elseif drops > 10 then
        bonus = math.ceil((DropPrice / 100) * 7) + 300
    elseif drops > 15 then
        bonus = math.ceil((DropPrice / 100) * 10) + 400
    elseif drops > 20 then
        bonus = math.ceil((DropPrice / 100) * 12) + 500
    end
    local price = (DropPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount
    Player.Functions.AddMoney("bank", payment, "hamburger-loon")
    TriggerClientEvent('chatMessage', source, "BAAN", "warning", "U heeft uw salaris ontvangen van: €"..payment..", bruto: €"..price.." (bonus €"..bonus.." bonus) en €"..taxAmount.." btw ("..PaymentTax.."%)")
end)

