-- zones.lua
-- by theKatzinator 🐾
-- Zonenverwaltung für MOOSinator: Dropzonen, Triggerbereiche, etc.

Debug("zones.lua geladen")

-- === Dropzone definieren ===
local dropZoneName = "DZ_1"
local dropZone = ZONE:FindByName(dropZoneName)

if dropZone ~= nil then
    Debug("Dropzone gefunden: " .. dropZoneName)
    Debug("Zonenradius: " .. dropZone:GetRadius())
else
    Debug("FEHLER: Dropzone '" .. dropZoneName .. "' nicht gefunden!")
end

-- Beispiel: Funktion zum Prüfen, ob ein Punkt innerhalb der Dropzone liegt
function IsInsideDropZone(coord)
    if not dropZone then return false end
    return dropZone:IsPointVec2InZone(coord)
end
