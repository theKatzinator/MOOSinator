-- air_units.lua
-- Modul für die Aktivierung von Einheiten
-- Erstellt von theKatzinator 🐾

Debug("air_units.lua geladen")

-- === Gruppennamen ===
local c130GroupName = "C130_1"               -- Name der C130-Gruppe im Mission Editor
local paratrooperGroupName = "Fallschirm_Gruppe" -- Name der Fallschirmtruppe

-- === C130 aktivieren ===
local c130Group = GROUP:FindByName(c130GroupName)

if c130Group ~= nil then
    Debug("C130 gefunden: " .. c130GroupName)
    c130Group:Activate()
    Debug("C130 aktiviert")
else
    Debug("FEHLER: Gruppe '" .. c130GroupName .. "' nicht gefunden!")
end

-- === Fallschirmgruppe vorbereiten ===
local paraGroup = GROUP:FindByName(paratrooperGroupName)

if paraGroup ~= nil then
    Debug("Fallschirmtruppe gefunden: " .. paratrooperGroupName)
else
    Debug("WARNUNG: Fallschirmtruppe '" .. paratrooperGroupName .. "' nicht gefunden!")
end
