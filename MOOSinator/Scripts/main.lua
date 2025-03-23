-- main.lua (Startpunkt)

DEBUG = true
function Debug(msg)
    if DEBUG then
        trigger.action.outText("[DEBUG] " .. tostring(msg), 10)
    end
end

Debug("main.lua geladen")

if not SCHEDULER or not BASE then
    trigger.action.outText("[FEHLER] MOOSE fehlt oder wurde nicht korrekt geladen!", 15)
else
    Debug("MOOSE erkannt – SCHEDULER & BASE vorhanden")
end

-- === Module laden ===
dofile("Scripts/air_units.lua")

Debug("main.lua abgeschlossen")
