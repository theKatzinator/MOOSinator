--[[
  Ablauf:
  1. Infanterie wird vom Heli abgeholt (Einsteigen in Heli)
  2. Flug zur Umschlagstelle (Vor dem Einsatzgebiet)
  3. Infanterie steigt aus dem Heli aus
  4. Infanterie steigt in bereitstehenden LKW ein
  5. LKW fährt zur eigentlichen Einsatzzone
]]

-- GRUPPENNAMEN ANPASSEN!
local InfantryGroup = GROUP:FindByName("Infantry")
local Helicopter = UNIT:FindByName("Heli")
local Truck = UNIT:FindByName("Truck")

-- 1. Boarding-Handler: Infanterie steigt in Heli ein (per Trigger im Editor gesteuert)
-- Heli fliegt zur Zwischenstation (Waypoint)
-- Dort landet der Heli, und Infanterie steigt aus

-- 2. Event-Handler für Heli-Landung an Umschlagstelle
HeliLandingHandler = EVENT:New()

function HeliLandingHandler:OnEventLand(EventData)
  if EventData.IniUnitName == Helicopter:GetName() then
    MESSAGE:ToAll("Heli gelandet. Infanterie steigt aus...", 10)
    -- Optional: Flagge setzen, Zone aktivieren, etc.

    -- Verzögerung, damit KI wirklich "aussteigt"
    SCHEDULER:New(nil, function()
      MESSAGE:ToAll("Infanterie bereitet sich auf Boarding des LKW vor...", 10)

      -- Befehl: Infanterie soll in Truck einsteigen
      InfantryGroup:TaskEmbark(Truck, 10)

      -- Optional: Wenn sie drin sind, Truck fortsetzen lassen
      -- Das kann man später über einen weiteren Trigger machen (z.B. Zone leer)
    end, {}, 10) -- 10 Sek. warten nach Landung
  end
end

HeliLandingHandler:HandleEvent(EVENTS.Land)

--