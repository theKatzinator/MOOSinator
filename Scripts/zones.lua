-- zones.lua
-- by theKatzinator 🐾
-- Zonenverwaltung für MOOSinator: Dropzonen, Triggerbereiche, etc.

Debug("zones.lua geladen")

MOOSINATOR.dropZoneName = "DZ_1"
MOOSINATOR.dropZone = ZONE:FindByName(MOOSINATOR.dropZoneName)

if MOOSINATOR.dropZone then
    Debug("Dropzone gefunden: " .. MOOSINATOR.dropZoneName)
    Debug("Zonenradius: " .. MOOSINATOR.dropZone:GetRadius())
else
    Debug("FEHLER: Dropzone '" .. MOOSINATOR.dropZoneName .. "' nicht gefunden!")
end
