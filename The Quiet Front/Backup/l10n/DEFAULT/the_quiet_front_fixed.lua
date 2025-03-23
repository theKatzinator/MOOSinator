--[[
    The Quiet Front – Phase 1: Ankunft & Aufbau (CTLD-Version)
    Autor:The Magic Gerdsche + Katze Blacky und Schwester Flecki 😎
    Datum: 2025-03-22

    📖 Missionshintergrund:
    Afghanistan, Vorstoß 05:15 Uhr – eine kalte Front liegt über dem Tal.
    Eine C-130 schneidet durch die Dämmerung – an Bord: Echo Eins.
    Ihr Auftrag: Sicherung des Absprungpunkts und Aufbau eines Vorpostens hinter feindlichen Linien.

    Nur ein Funkruf durchbricht die Stille:

    "🛬 Achtung Echo 1 – Abwurf in 5... 4... 3... 2... 1... GO!"

    Mit CTLD, Fallschirmjägern, eigenem Funkspruch und Flares – 
    das Skript sorgt für dramatische Landung in feindlichem Gebiet.
]]
-- Prüfen ob Script tatsächlich neu geladen wurde
trigger.action.outText("Fixed Version 1.0", 5)

--Überprpfen ob Moose geladen wird
if SCHEDULER and BASE then
    trigger.action.outText("✅ MOOSE funktioniert einwandfrei!", 10)
else
    trigger.action.outText("❌ MOOSE fehlt oder fehlerhaft!", 10)
end

-- CTLD Konfiguration
-- ✅ Truppenabwurf freigeben: Unsere C130 darf jetzt offiziell Fallschirmjäger rauswerfen!
ctld.transportPilotNames = { "C130_1" }
ctld.enableParatrooperDrop = true
ctld.paratrooperUnits = {"Fallschirm_Gruppe"} -- Deine Vorlage im Editor
ctld.dropAltitude = 1000
ctld.minimumDropAltitude = 100

-- Debug-Modus
local DEBUG = true
function DebugMsg(msg)
    if DEBUG then
        trigger.action.outText("[DEBUG] " .. msg, 10)
    end
end

-- 🔥 Flare-Kreis Funktion
function SpawnFlaresAroundPoint(center, radius, count)
    for i = 1, count do
        local angle = (2 * math.pi / count) * i
        local x = center.x + radius * math.cos(angle)
        local z = center.z + radius * math.sin(angle)
        local flarePoint = {x = x, y = center.y, z = z}
        trigger.action.signalFlare(flarePoint, trigger.flareColor.Red, 0)
    end
end

-- 📡 Automatischer Drop-Trigger
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

        DebugMsg(" C130 in Zone - CTLD-Drop wird ausgelöst")

        -- CTLD Abwurf
        ctld.dropTroops(plane)

        -- Funkspruch + Text
        trigger.action.soundToAll("Abwurf_Fallschirmgruppe.ogg", 10)
        trigger.action.outText("  Echo Eins: Abwurf läuft - gute Jagd!", 10)

        -- Flares
        SpawnFlaresAroundPoint(planePos, 100, 6)

        DebugMsg(" Fallschirmjäger-Drop abgeschlossen")
    end
end, {}, 1, 1)

-- ✈️ Späte Aktivierung der C130
timer.scheduleFunction(function()
    local group = Group.getByName("C130_1")
    if group then
        group:activate()
        trigger.action.outText(" Echo Eins ist unterwegs!", 5)
    else
        trigger.action.outText(" C130_1 nicht gefunden!", 10)
    end
end, {}, timer.getTime() + 30)

-- Initialmeldung
trigger.action.outText("  CTLD-Fallschirm-Drop Script geladen _ Echo Eins wartet.", 5)
