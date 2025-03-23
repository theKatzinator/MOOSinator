--[[
     Phase 1: Ankunft & Aufbau (CTLD-Version)
    Autor: The Magic Gerdsche + Katze Blacky und Schwester Flecki !
    Datum: 2025-03-22

    #Missionshintergrund:#
    
    Afghanistan, VorstoÃŸ 05:15 Uhr â€“ eine kalte Front liegt Ã¼ber dem Tal.
    Eine C-130 schneidet durch die DÃ¤mmerung â€“ an Bord: Echo Eins.
    Ihr Auftrag: Sicherung des Absprungpunkts und Aufbau eines Vorpostens hinter feindlichen Linien.

    Nur ein Funkruf durchbricht die Stille:

    "Achtung Echo 1 Abwurf in 5... 4... 3... 2... 1... GO!"

    Mit CTLD, Fallschirmjägern, eigenem Funkspruch, Flares und F10 Menü 
    das Skript sorgt für dramatische Landung in feindlichem Gebiet.
--]]

trigger.action.outText("Skript gestartet!", 10)

--Überprüfen ob Moose geladen wird
if SCHEDULER and BASE then
    trigger.action.outText(" MOOSE funktioniert einwandfrei!", 10)
else
    trigger.action.outText("MOOSE fehlt oder fehlerhaft!", 10)
end

-- Einheit mit Late Activation im Editor
local fallschirmGruppeName = "Fallschirm_Gruppe"
local c130Name = "C130_1"
local dropZoneName = "DZ_1"

local alreadyDropped = false

-- Flares
function SpawnFlaresAroundPoint(center, radius, count)
    for i = 1, count do
        local angle = (2 * math.pi / count) * i
        local x = center.x + radius * math.cos(angle)
        local z = center.z + radius * math.sin(angle)
        local flarePoint = {x = x, y = center.y, z = z}
        trigger.action.signalFlare(flarePoint, trigger.flareColor.Red, 0)
    end
end

SCHEDULER:New(nil, function()

    local status, err = pcall(function()

        trigger.action.outText("Scheduler tickt!", 2)

        local group = Group.getByName("C130_1")
        if not group then
            trigger.action.outText("DEBUG: C130_1 Gruppe nicht gefunden", 5)
            return
        end

        if alreadyDropped then
            trigger.action.outText("DEBUG: Bereits abgeworfen, Skip", 5)
            return
        end

        local plane = group:getUnit(1)
        if not plane then
            trigger.action.outText("DEBUG: C130 Einheit nicht gefunden", 5)
            return
        end

        local zone = trigger.misc.getZone("DZ_1")
        if not zone then
            trigger.action.outText("DEBUG: Dropzone 'DZ_1' nicht vorhanden", 10)
            return
        end

        local pos = plane:getPoint()
        local dx = pos.x - zone.point.x
        local dz = pos.z - zone.point.z
        local distance = math.sqrt(dx * dx + dz * dz)

        trigger.action.outText(string.format("DEBUG: Abstand zur Zone: %.2f (Radius: %.2f)", distance, zone.radius), 5)

        if distance < zone.radius then
            alreadyDropped = true
            trigger.action.outText("Echo Eins: Absprung läuft!", 10)
            trigger.action.soundToAll("Abwurf_Fallschirmgruppe.ogg", 10)
            SpawnFlaresAroundPoint(pos, 100, 6)

            local gruppe = Group.getByName("Fallschirm_Gruppe")
            if gruppe then
                gruppe:activate()
            else
                trigger.action.outText("DEBUG: Fallschirmgruppe nicht gefunden", 10)
            end
        end

    end)

    if not status then
        trigger.action.outText("FEHLER im Scheduler:\n" .. tostring(err), 15)
    end

end, {}, 1, 2)
