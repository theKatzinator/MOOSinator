--Script Anfang 
--***************************

-- Sicherstellen, dass AirbaseMonitor existiert

AirbaseMonitor = EVENTHANDLER:New()

-- Prüfen ob Script tatsächlich neu geladen wurde !!

trigger.action.outText("Skript wurde NEU geladen!", 5)

--Testen, ob MOOSE korrekt eingebunden ist
if not SPAWN then
    trigger.action.outText("MOOSE wurde nicht richtig geladen!", 10)
else
    trigger.action.outText("MOOSE funktioniert!", 10)
end

-- 1️⃣ MOOSE laden
env.info("MOOSE geladen!") 

-- 2️⃣ Timer starten, bevor das Skript ausgeführt wird (15 Sekunden Verzögerung)
SCHEDULER:New(nil, function()

  -- 3️⃣ Erstes KI-Patrouillen-Team mit 2 Flugzeugen (Leader + Wingman)
  local AirPatrol1 = SPAWN:New("AirbasePatrol") -- Name aus dem Missionseditor
    :InitGrouping(2) -- Immer 2 Flugzeuge als Gruppe
    :InitLimit(1, 1) -- Maximal 1 Team gleichzeitig (also 2 Flugzeuge)
    :SpawnScheduled(300, 0.5) -- Alle 5 Minuten ein neues Team

  -- 4️⃣ Zweites KI-Patrouillen-Team mit 2 Flugzeugen (Neues Team!)
  local AirPatrol2 = SPAWN:New("AirbasePatrol2") -- Name aus dem Missionseditor
    :InitGrouping(2) -- Immer 2 Flugzeuge als Gruppe
    :InitLimit(1, 1) -- Maximal 1 Team gleichzeitig (also 2 Flugzeuge)
    :SpawnScheduled(300, 0.5) -- Alle 5 Minuten ein neues Team

  -- 5️⃣ KI-Bodeneinheiten mit Straßenbewegung
  local GroundPatrol = SPAWN:New("GroundPatrol") -- Name der Bodeneinheit
    :InitLimit(10, 10) -- Maximal 10 Fahrzeuge gleichzeitig
    :SpawnScheduled(10, 0.5) -- Alle 10 Sekunden eine neue Einheit

end, {}, 15) -- Warte 15 Sekunden, bevor das Skript läuft

-- Block Ende Flugzeuge und Bodeneinheiten spawnen und starten !! Nicht ändern funktioniert einwandfrei !!

function AirbaseMonitor:OnEventLand(EventData)
    local msg = "Landungsevent ausgelöst für: " .. (EventData.IniUnit and EventData.IniUnit:GetName() or "Unbekannt")
env.info(msg)  -- Ins Log schreiben
trigger.action.outText(msg, 5)  -- Auf dem Monitor anzeigen
    
    
    if EventData.IniUnit then
        local flightUnit = EventData.IniUnit
        local unitName = flightUnit:GetName()
        trigger.action.outText(unitName .. " ist gelandet!", 5)

        -- Prüfen, welche Mechaniker-Gruppe zuständig ist
        local mechanicTruckName
        if string.find(unitName, "AirbasePatrol") then
            mechanicTruckName = "MechanicTruckA"
        elseif string.find(unitName, "AirbasePatrol2") then
            mechanicTruckName = "MechanicTruckB"
        else
            return -- Falls die Gruppe nicht erkannt wird, nichts tun
        end

        -- Funktion zum Checken, ob das Flugzeug geparkt ist
        local function CheckIfParked()
            SCHEDULER:New(nil, function()
                if flightUnit and flightUnit:IsAlive() then
                    local speed = flightUnit:GetVelocityKNOTS()
                    local rpm = flightUnit:GetRPM() or 0  -- Falls nil, setzen wir es auf 0
                    local enginesOff = rpm < 5

                    if speed < 1 and enginesOff then
                        trigger.action.outText(mechanicTruckName .. " fährt zur Wartung!", 5)

                        local MechanicTruck = SPAWN:New(mechanicTruckName)
                            :InitLimit(1, 1)
                            :Spawn()

                        if MechanicTruck then
                            local truckGroup = MechanicTruck:GetFirstGroup()
                            if truckGroup then
                                local parkingPos = flightUnit:GetCoordinate()
                                if parkingPos then
                                    truckGroup:TaskRouteToVec2(parkingPos:GetVec2(), 10)
                                    trigger.action.outText("Mechaniker ist auf dem Weg zu " .. unitName, 5)
                                end
                            end
                        end
                    else
                        trigger.action.outText(unitName .. " rollt noch oder Triebwerke laufen...", 2)
                    end
                end
            end, {}, 10, 10) -- Alle 10 Sekunden prüfen
        end

        -- Starte den Check für das Parken
        CheckIfParked()
    end
end

-- AirbaseMonitor als EventHandler registrieren
world.addEventHandler(AirbaseMonitor)


