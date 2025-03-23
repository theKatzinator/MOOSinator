-- Testen, ob MOOSE korrekt eingebunden ist
if not SPAWN then
    trigger.action.outText("MOOSE wurde nicht richtig geladen!", 10)
else
    trigger.action.outText("MOOSE funktioniert!", 10)
end
