
local QBCore = exports['qb-core']:GetCoreObject()

local JUMP_INTERVAL = 5000 -- Her 5 saniyede bir tuşa basılması gerekiyor
local JUMP_KEY = 38 -- E tuşu

local BACKGROUND_MUSIC = "https://cdn.discordapp.com/attachments/1272619050069131437/1356990653917171722/ZIPLA.mp3?ex=67ee9387&is=67ed4207&hm=45d572848a19f5a320ea49e7a3d3e3de76a4a45ac4772494bcf3865cf7fb80d6&"
local PUNISHMENT_VIDEO = "okan.mp4"
local isGameActive = false
local lastJumpTime = 0
local backgroundMusicSound = nil

function PlayBackgroundMusic()
    if exports.xsound then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        if backgroundMusicSound then
            exports.xsound:Destroy(backgroundMusicSound)
        end
        
        -- Benzersiz müzik ismi
        backgroundMusicSound = "zipla"

        exports.xsound:PlayUrlPos(backgroundMusicSound, BACKGROUND_MUSIC, 1.0, playerCoords, {
            volume = 0.5,
            loop = true,
            distance = 500.0
        })
    else
        print("Ses sistemi bulunamadı!")
    end
end

function StopBackgroundMusic()
    if exports.xsound and backgroundMusicSound then
        exports.xsound:Destroy(backgroundMusicSound)
        backgroundMusicSound = nil
    end
end

local function StartGame()
    isGameActive = true
    lastJumpTime = GetGameTimer()
    
    QBCore.Functions.Notify('Teypçi oyunu başladı! E tuşuna bas!', 'primary', 3000)

    PlayBackgroundMusic()
    
    SendNUIMessage({
        type = 'startTimer'
    })
    
    local ped = PlayerPedId()
    RequestAnimDict("timetable@reunited@ig_2")
    while not HasAnimDictLoaded("timetable@reunited@ig_2") do
        Citizen.Wait(10)
    end
    TaskPlayAnim(ped, "timetable@reunited@ig_2", "jimmy_getknocked", 8.0, -8.0, -1, 0, 0, false, false, false)
    
    Citizen.CreateThread(function()
        while isGameActive do
            Citizen.Wait(100)
            
            local currentTime = GetGameTimer()
            if currentTime - lastJumpTime >= JUMP_INTERVAL then
                EndGame(false)
                break
            end
            
            if IsControlJustPressed(0, JUMP_KEY) then
                lastJumpTime = currentTime
                
                SendNUIMessage({
                    type = 'resetTimer'
                })
                
                ClearPedTasks(PlayerPedId())
                TaskPlayAnim(PlayerPedId(), "timetable@reunited@ig_2", "jimmy_getknocked", 8.0, -8.0, -1, 0, 0, false, false, false)
            end
        end
    end)
end

function EndGame(won)
    isGameActive = false

    StopBackgroundMusic()
    
    if won then
        QBCore.Functions.Notify('Oyunu kazandı! Dua ve himmetler üzerinde olsun!', 'success', 3000)
    else
        QBCore.Functions.Notify('Kaybettin! Sen artık bir TEYİPÇİSİN!', 'error', 5000)
        
        SendNUIMessage({
            type = 'showVideo',
            videoSrc = PUNISHMENT_VIDEO
        })
    end
    
    ClearPedTasks(PlayerPedId())
end

RegisterCommand('zıpla', function()
    if isGameActive then
        QBCore.Functions.Notify('Oyun zaten devam ediyor!', 'error')
        return
    end
    
    StartGame()
end)

RegisterCommand('oyunudurdur', function()
    if isGameActive then
        EndGame(true)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if(GetCurrentResourceName() == resourceName) then
        print("[Teypçi Mini Oyun] İstemci scripti başlatıldı!")
    end
end)

RegisterNUICallback('videoEnded', function(data, cb)
    cb('ok')
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    if not exports.xsound then
        print("^1UYARI: XSound bulunamadı! Ses özellikleri çalışmayacak.^7")
        QBCore.Functions.Notify('XSound bulunamadı!', 'error')
    end
end)