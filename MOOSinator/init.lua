-- Projekt: Wir_benennen_die_Mission_wenns_funktioniert
-- Autor: Blacky
-- Zweck: Initialisierung & Debugbasis für MOOSE-Scripting

-- Debug-Modus
DEBUG = true
function Debug(msg)
    if DEBUG then
        trigger.action.outText("[DEBUG] " .. tostring(msg), 10)
    end
end

-- Projekt-Startmeldung
trigger.action.outText("[INIT] Mission Framework gestartet", 10)
Debug("Init.lua geladen")

-- MOOSE Check
if not SCHEDULER or not BASE then
    trigger.action.outText("[FEHLER] MOOSE fehlt oder wurde nicht korrekt geladen!", 15)
else
    Debug("MOOSE erkannt – SCHEDULER & BASE vorhanden")
end

-- Setup für zukünftige Datei-Includes (wenn nötig)
-- dofile("Scripts/units.lua")
-- dofile("Scripts/zones.lua")
-- dofile("Scripts/logic.lua")
-- dofile("Scripts/menus.lua")

-- Beispiel-Scheduler (Testlauf)
SCHEDULER:New(nil, function()
    Debug("Scheduler tickt – Grundstruktur aktiv")
end, {}, 5, 10)

-- Platzhalter für Projekt-Variablen
MISSION_READY = true
PLAYER_FACTION = "BLUE"

-- Ende der Init
Debug("Init abgeschlossen")
