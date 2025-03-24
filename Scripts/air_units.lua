-- air_units.lua
-- Modul für die Aktivierung von Einheiten
-- Erstellt von theKatzinator 🐾

Debug("air_units.lua geladen")

-- === Gruppennamen ===
MOOSINATOR.c130GroupName = "C130_1"
MOOSINATOR.paratrooperGroupName = "Fallschirm_Gruppe"

-- === C130 aktivieren ===
MOOSINATOR.c130Group = GROUP:FindByName(MOOSINATOR.c130GroupName)

if MOOSINATOR.c130Group then
    Debug("C130 gefunden: " .. MOOSINATOR.c130GroupName)
    MOOSINATOR.c130Group:Activate()
    Debug("C130 aktiviert")
else
    Debug("FEHLER: Gruppe '" .. MOOSINATOR.c130GroupName .. "' nicht gefunden!")
end

-- === Fallschirmgruppe vorbereiten ===
MOOSINATOR.paraGroup = GROUP:FindByName(MOOSINATOR.paratrooperGroupName)

if MOOSINATOR.paraGroup then
    Debug("Fallschirmtruppe gefunden: " .. MOOSINATOR.paratrooperGroupName)
else
    Debug("WARNUNG: Fallschirmtruppe '" .. MOOSINATOR.paratrooperGroupName .. "' nicht gefunden!")
end
