local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('zıpla', function(source, args, rawCommand)
    TriggerClientEvent('teypci:startGame', source)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if(GetCurrentResourceName() == resourceName) then
        print("[Teypçi Mini Oyun] Sunucu scripti başlatıldı!")
    end
end)
