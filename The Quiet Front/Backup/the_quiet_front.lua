--[[
    The Quiet Front – Phase 1: Ankunft & Aufbau (CTLD-Version)
    Autor: Gerd + ChatGPT 😎
    Datum: 2025-03-21

    📖 Missionshintergrund:
    Afghanistan, Vorstoß 05:15 Uhr – eine kalte Front liegt über dem Tal.
    Eine C-130 schneidet durch die Dämmerung – an Bord: Echo Eins.
    Ihr Auftrag: Sicherung des Absprungpunkts und Aufbau eines Vorpostens hinter feindlichen Linien.

    Nur ein Funkruf durchbricht die Stille:

    "🛬 Achtung Echo 1 – Abwurf in 5... 4... 3... 2... 1... GO!"

    Mit CTLD, Fallschirmjägern, eigenem Funkspruch, Flares und F10 Menü – 
    das Skript sorgt für dramatische Landung in feindlichem Gebiet.
]]

--***************************************************************************************************************************************************
-- DEBUG Nachrichten                DEBUG Nachrichten               DEBUG Nachrichten               DEBUG Nachrichten               DEBUG Nachrichten


-- Prüfen ob Script tatsächlich neu geladen wurde
trigger.action.outText("Schon wieder testen", 5)

-- Test auf MOOSE
if not SPAWN then
    trigger.action.outText("MOOSE wurde nicht richtig geladen!", 10)
else
    trigger.action.outText("MOOSE funktioniert!", 10)
end
-- DEBUG Nachrichten                DEBUG Nachrichten               DEBUG Nachrichten               DEBUG Nachrichten               DEBUG Nachrichten

--*****************************************************************************************************************************************************


--*****************************************************************************************************************************************************

--     Script Anfang !!!                        Script Anfang !!!                       Script Anfang !!!               


--******************************************************************************************************************************************************

--🧰 CTLD-Konfig
ctld.enableParatrooperDrop = true
ctld.paratrooperUnits = {"Fallschirm_Gruppe"}  -- Editor-Template
ctld.dropAltitude = 1000
ctld.minimumDropAltitude = 600

--🔧 Debug-Funktion
local DEBUG = true
function DebugMsg(msg)
    if DEBUG then
        trigger.action.outText("[DEBUG] " .. msg, 10)
    end
end

-- 🎆 Flares im Kreis platzieren
function SpawnFlaresAroundPoint(center, radius, count)
    for i = 1, count do
        local angle = (2 * math.pi / count) * i
        local x = center.x + radius * math.cos(angle)
        local z = center.z + radius * math.sin(angle)
        local flarePoint = {x = x, y = center.y, z = z}
        trigger.action.signalFlare(flarePoint, trigger.flareColor.Red, 0)
    end
end

-- 🔄 Automatischer Abwurf bei Zone-Eintritt
local dropZoneName = "DZ_1"
local alreadyDropped = false

SCHEDULER:New(nil, function()
    local group = Group.getByName("C130_1")
    if not group or alreadyDropped then return end

    local plane = group:getUnit(1)
    if not plane then return end

    local zone = trigger.misc.getZone(dropZoneName)
    if not zone then
        trigger.action.outText(" Drop-Zone '" .. dropZoneName .. "' nicht gefunden!", 10)
        return
    end

    local planePos = plane:getPoint()
    local dx = planePos.x - zone.point.x
    local dz = planePos.z - zone.point.z
    local distance = math.sqrt(dx * dx + dz * dz)

    if distance < zone.radius then
        alreadyDropped = true

        -- CTLD-Abwurf
        ctld.dropTroops(plane)

        -- Funkspruch
        trigger.action.soundToAll("Abwurf_Fallschirmgruppe.ogg", 10)
        trigger.action.outText("  Echo Eins: Abwurf läuft - gute Jagd!", 10)

        -- Roter Flare-Kreis
        SpawnFlaresAroundPoint(planePos, 100, 6)

        DebugMsg("🪂 Automatischer Abwurf über DZ_1 ausgeführt.")
    end
end, {}, 1, 1)

-- 🛫 Späte Aktivierung der C130
trigger.action.outText("Aktiviere C130...", 5)
timer.scheduleFunction(function()
    local group = Group.getByName("C130_1")
    if group then
        group:activate()
        trigger.action.outText("C130 aktiviert!", 5)
        DebugMsg("C130 Gruppe aktiviert")
    else
        trigger.action.outText(" Gruppe 'C130_1' nicht gefunden!", 10)
    end
end, {}, timer.getTime() + 25)

-- 🟢 Script-Startmeldung
trigger.action.outText(" Fallschirmsprung-Script (CTLD) erfolgreich geladen!", 5)
