-- logic.lua
-- Steuerlogik für den MOOSinator 🐾
-- by theKatzinator

Debug("logic.lua geladen")

-- Voraussetzungen:
-- - C130 (c130Group) ist bereits aktiv
-- - Dropzone (dropZone) ist in zones.lua definiert
-- - Fallschirmgruppe (paraGroup) ist in air_units.lua bekannt

-- Funktion zur Zonenprüfung und Abwurf
local function CheckDropTrigger()
    if not c130Group or not dropZone then
        Debug("DropCheck: Voraussetzungen nicht erfüllt")
        return
    end

    local c130Unit = c130Group:GetUnit(1)
    local c130Coord = c130Unit and c130Unit:GetCoordinate()

    if c130Coord and dropZone:IsVec3InZone(c130Coord:GetVec3()) then
        Debug("✅ C130 befindet sich in der Dropzone!")

        -- Hier könnte der Abwurfcode folgen (Spawn von Infanterie, Effekt etc.)
        trigger.action.outText("Fallschirmjäger springen!", 10)

        -- Beispiel: Smoke
        dropZone:SmokeZone(1, 5)

    else
        Debug("❌ C130 ist noch nicht in der Dropzone")
    end
end

-- Scheduler startet alle 10 Sekunden
SCHEDULER:New(nil, CheckDropTrigger, {}, 5, 10)
