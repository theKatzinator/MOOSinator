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
  if EventData.IniUnit then
    local unit = EventData.IniUnit
    local unitName = unit:GetName()

    -- Funktion, um zu prüfen, ob das Flugzeug wirklich geparkt ist
    local function CheckIfParked(flightUnit, mechanicName, mechanicTruckName)
      SCHEDULER:New(nil, function()
        if flightUnit and flightUnit:IsAlive() then
          local speed = flightUnit:GetVelocityKNOTS() -- Geschwindigkeit in Knoten
          local enginesOff = flightUnit:GetRPM() < 5 -- Prüft, ob die Triebwerke aus sind

          if speed < 1 and enginesOff then
            trigger.action.outText(mechanicName .. " fährt jetzt zur Wartung!", 5)

            local MechanicTruck = SPAWN:New(mechanicTruckName)
              :InitLimit(1, 1)
              :Spawn()

            if MechanicTruck then
              local truckGroup = MechanicTruck:GetFirstGroup()
              if truckGroup then
                local parkingPos = flightUnit:GetCoordinate()
                truckGroup:TaskRouteToVec2(parkingPos:GetVec2(), 10) -- Mechaniker fährt mit 10 km/h
              end
            end
          else
            trigger.action.outText(flightUnit:GetName() .. " rollt noch oder hat Triebwerke an...", 2)
          end
        end
      end, {}, 10, 10) -- Alle 10 Sekunden prüfen
    end

    -- Prüfen, welche Gruppe gelandet ist und den Mechaniker passend rufen
    if unitName:find("AirbasePatrol2") then
      env.info("Flugzeug AirbasePatrol2 ist gelandet!")
      MESSAGE:New("Gruppe 2 ist gelandet!", 15):ToAll()
      CheckIfParked(unit,"MechanicTruckB")

    elseif unitName:find("AirbasePatrol") then
      env.info("Flugzeug AirbasePatrol ist gelandet!")
      MESSAGE:New("Gruppe 1 ist gelandet!", 15):ToAll()
      CheckIfParked(unit,"MechanicTruckA")
    end
  end
end
