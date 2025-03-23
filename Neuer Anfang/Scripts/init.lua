-- Projektstart: Wir_benennen_die_Mission_wenns_funktioniert

DEBUG = true
function Debug(msg)
    if DEBUG then
        trigger.action.outText("[DEBUG] " .. tostring(msg), 10)
    end
end

trigger.action.outText("[INIT] Mission Framework gestartet", 10)
Debug("Init.lua geladen")

if not SCHEDULER or not BASE then
    trigger.action.outText("[FEHLER] MOOSE fehlt oder wurde nicht korrekt geladen!", 15)
else
    Debug("MOOSE erkannt – SCHEDULER & BASE vorhanden")
end
