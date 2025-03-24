-- logic.lua
-- Steuerlogik für den MOOSinator 🐾
-- by theKatzinator

Debug("logic.lua geladen")

local function CheckDropTrigger()
    local c130Group = MOOSINATOR.c130Group
    local dropZone = MOOSINATOR.dropZone

    if not c130Group or not dropZone then
        Debug("DropCheck: Voraussetzungen nicht erfüllt")
        return
    end

    local c130Unit = c130Group:GetUnit(1)
    local c130Coord = c130Unit and c130Unit:GetCoordinate()

    if c130Coord and dropZone:IsVec3InZone(c130Coord:GetVec3()) then
        Debug("✅ C130 befindet sich in der Dropzone!")
        trigger.action.outText("Fallschirmjäger springen!", 10)
        dropZone:SmokeZone(1, 5)
    else
        Debug("❌ C130 ist noch nicht in der Dropzone")
    end
end

-- Debug-Ausgabe
Debug("Check: c130Group = " .. tostring(MOOSINATOR.c130Group))
Debug("Check: dropZone = " .. tostring(MOOSINATOR.dropZone))

-- Scheduler starten
SCHEDULER:New(nil, CheckDropTrigger, {}, 5, 10)
