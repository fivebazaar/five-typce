local QBCore = exports['qb-core']:GetCoreObject()

local DIRENIS_MUSIC_1 = "https://cdn.discordapp.com/attachments/1272619050069131437/1356990671017345125/DIRENIS1.mp3?ex=67ee938b&is=67ed420b&hm=423ea438b12c603284ad0b586b1a6381af8fea2710351d3409b7a2408b86b79f&"
local DIRENIS_MUSIC_2 = "https://cdn.discordapp.com/attachments/1272619050069131437/1356991174174314586/direnis2.mp3?ex=67ee9403&is=67ed4283&hm=dc4af6a7de75d7f222f496dcdaf2614586ba2d771d62ecf51becad22df03c1a1&" -- Farklı bir müzik URL'si
local direnisSound = nil
local isDirenisModeActive = false
local currentDirenisMusicType = nil

function PlayDirenisMuzik(musicType)
    if not exports.xsound then
        QBCore.Functions.Notify('Müzik sistemi bulunamadı!', 'error')
        return false
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    if direnisSound then
        exports.xsound:Destroy(direnisSound)
    end
    
    local musicUrl = musicType == 1 and DIRENIS_MUSIC_1 or DIRENIS_MUSIC_2
    
    direnisSound = "direnis_muzik_" .. musicType
    
    exports.xsound:PlayUrlPos(direnisSound, musicUrl, 1.0, playerCoords, {
        volume = 0.5,
        loop = true,  
        distance = 500.0  -- 500 metre mesafe
    })
    
    currentDirenisMusicType = musicType
    
    QBCore.Functions.Notify('Direniş sesi başladı!', 'success')
    
    return true
end

function StopDirenisModu()
    ClearPedTasks(PlayerPedId())
    
    if exports.xsound and direnisSound then
        exports.xsound:Destroy(direnisSound)
        direnisSound = nil
    end
    
    isDirenisModeActive = false
    currentDirenisMusicType = nil
    
    QBCore.Functions.Notify('Protesto sona erdi.', 'inform')
end

RegisterCommand('direniş', function()
    if isDirenisModeActive then
        QBCore.Functions.Notify('Protesto zaten aktif!', 'error')
        return
    end
    
    isDirenisModeActive = true
    
    RequestAnimDict("anim@mp_player_intcelebrationmale@cut_throat")
    while not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@cut_throat") do
        Citizen.Wait(10)
    end
    
    local ped = PlayerPedId()
    TaskPlayAnim(ped, "anim@mp_player_intcelebrationmale@cut_throat", "cut_throat", 8.0, -8.0, -1, 49, 0, false, false, false)
    
    PlayDirenisMuzik(1)
    

    QBCore.Functions.Notify('POLİSE DİRENİŞ BAŞLADI!', 'error')
    
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        while isDirenisModeActive do
            Citizen.Wait(100)
            
            if not IsEntityPlayingAnim(ped, "anim@mp_player_intcelebrationmale@cut_throat", "cut_throat", 3) then
                TaskPlayAnim(ped, "anim@mp_player_intcelebrationmale@cut_throat", "cut_throat", 8.0, -8.0, -1, 49, 0, false, false, false)
            end
        end
    end)
end)


RegisterCommand('direniş2', function()
    if isDirenisModeActive then
        QBCore.Functions.Notify('Protesto zaten aktif!', 'error')
        return
    end
    
    isDirenisModeActive = true
    
    RequestAnimDict("anim@mp_player_intcelebrationmale@cut_throat")
    while not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@cut_throat") do
        Citizen.Wait(10)
    end
    
    local ped = PlayerPedId()
    TaskPlayAnim(ped, "anim@mp_player_intcelebrationmale@cut_throat", "cut_throat", 8.0, -8.0, -1, 49, 0, false, false, false)
    
    PlayDirenisMuzik(2)
    
    QBCore.Functions.Notify('POLİSE DİRENİŞ BAŞLADI! (2. Versiyon)', 'error')
    
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        while isDirenisModeActive do
            Citizen.Wait(100)
            
            if not IsEntityPlayingAnim(ped, "anim@mp_player_intcelebrationmale@cut_throat", "cut_throat", 3) then
                TaskPlayAnim(ped, "anim@mp_player_intcelebrationmale@cut_throat", "cut_throat", 8.0, -8.0, -1, 49, 0, false, false, false)
            end
        end
    end)
end)

RegisterCommand('direnişidurdur', function()
    if isDirenisModeActive then
        StopDirenisModu()
    else
        QBCore.Functions.Notify('Protesto aktif değil!', 'error')
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    if not exports.xsound then
        print("^1UYARI: XSound bulunamadı! Ses özellikleri çalışmayacak.^7")
        QBCore.Functions.Notify('XSound bulunamadı!', 'error')
    end
end)