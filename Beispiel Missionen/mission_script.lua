---@diagnostic disable: duplicate-set-field, redundant-parameter
--Script Anfang 
--***************************
--***************************
-- 🔍 DEBUG-Modus aktivieren (auf `false` setzen, wenn ihr keine Debug-Nachrichten mehr braucht)
local DEBUG = true  

-- 🔧 Debugging-Funktion, um Nachrichten ins Log & auf den Bildschirm zu schicken
function DebugMessage(msg)
    if DEBUG then
        MESSAGE:New(msg, 10):ToAll()
        env.info("[DEBUG] " .. msg)
    end
end


-- Sicherstellen, dass AirbaseMonitor existiert
if not AirbaseMonitor then
    trigger.action.outText("AirbaseMonitor ist NIL, erstelle ihn neu", 5)
    AirbaseMonitor = EVENTHANDLER:New() or {}
end

if AirbaseMonitor then
    trigger.action.outText("AirbaseMonitor existiert jetzt", 5)
else
    trigger.action.outText("Fehler: AirbaseMonitor bleibt NIL", 5)
end

-- Prüfen ob Script tatsächlich neu geladen wurde
trigger.action.outText("Hallo gehts jetzt ?", 5)

-- Testen, ob MOOSE korrekt eingebunden ist
if not SPAWN then
    trigger.action.outText("MOOSE wurde nicht richtig geladen!", 10)
else
    trigger.action.outText("MOOSE funktioniert!", 10)
end

-- MOOSE laden
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
    :SpawnScheduled(15, 0.5) -- Alle 10 Sekunden eine neue Einheit

end, {}, 15) -- Warte 15 Sekunden, bevor das Skript läuft

-- Block Ende Flugzeuge und Bodeneinheiten spawnen und starten !! Nicht ändern funktioniert einwandfrei !!

-- 🛠️ Falls AirbaseMonitor schon existiert, zuerst alte Events abmelden
if AirbaseMonitor then
    AirbaseMonitor:UnHandleEvent(EVENTS.Land)
end
  
-- 📌 Neuen Event Handler erstellen
AirbaseMonitor = EVENTHANDLER:New()

-- 📌 Event: Flugzeug landet
function AirbaseMonitor:OnEventLand(EventData)
    if EventData.IniUnit and EventData.IniUnit:IsAlive() then
        local unitName = EventData.IniUnit:GetName()
        local groupName = EventData.IniGroup:GetName()

        trigger.action.outText("✈️ Touchdown erkannt: " .. unitName, 15)
        
        -- Überprüfen, welche Gruppe gelandet ist
        if string.match(groupName, "^AirbasePatrol$") or string.match(groupName, "^AirbasePatrol#%d+$") then
            trigger.action.outText("AirbasePatrol 1 ist gelandet!", 15)
            SCHEDULER:New(nil, function() CheckShutdown(groupName) end, {}, 5)
        
        elseif string.match(groupName, "^AirbasePatrol2$") or string.match(groupName, "^AirbasePatrol2#%d+$") then
            trigger.action.outText("AirbasePatrol 2 ist gelandet!", 15)
            SCHEDULER:New(nil, function() CheckShutdown(groupName) end, {}, 5)
        
        else
            trigger.action.outText("❌ Unbekannte Gruppe erkannt: " .. groupName, 15)
        end
    end
end

-- 📌 Funktion: Check, ob Motoren aus sind
function CheckShutdown(groupName)
    local group = GROUP:FindByName(groupName)
    
    if group and group:IsAlive() then
        -- Prüfen, ob sich die Flugzeuge noch bewegen
        for _, unit in pairs(group:GetUnits()) do
            if unit:GetVelocityKMH() > 1 then
                -- Falls die Gruppe noch rollt, später erneut prüfen
                SCHEDULER:New(nil, function() CheckShutdown(groupName) end, {}, 5)
                return
            end
        end

        -- Gruppe steht still, jetzt Mechaniker losschicken
        trigger.action.outText(groupName .. " hat Motoren abgeschaltet!", 15)

        -- Realismus: Noch 10 Sekunden warten, dann Mechaniker rufen
        SCHEDULER:New(nil, function()
            SpawnMechanic(groupName)
        end, {}, 10)
    end
end

-- 📌 Funktion: Mechaniker-Fahrzeug spawnen & bewegen
function SpawnMechanic(groupName)
    local spawnPos = nil
    local mechanicName = nil  
    local group = GROUP:FindByName(groupName)

    -- 📌 Mechaniker-Spawnposition je nach Gruppe setzen
    if string.match(groupName, "^AirbasePatrol$") or string.match(groupName, "^AirbasePatrol#%d+$") then
        spawnPos = POINT_VEC3:New(30, 0, 30)
        mechanicName = "Mechanic_Truck1"

    elseif string.match(groupName, "^AirbasePatrol2$") or string.match(groupName, "^AirbasePatrol2#%d+$") then
        spawnPos = POINT_VEC3:New(-30, 0, -30)
        mechanicName = "Mechanic_Truck2"
    end

    if spawnPos and mechanicName then
        trigger.action.outText("🔧 Mechaniker wird gespawnt für " .. groupName, 15)

        local mechanic = SPAWN:New(mechanicName)
            :OnSpawnGroup(function(spawnGroup)
                trigger.action.outText("✅ Mechaniker erfolgreich gespawnt: " .. spawnGroup:GetName(), 15)

                -- 📌 Zielkoordinaten abrufen
                if group and group:IsAlive() then
                    local unit = group:GetUnit(1)
                    if unit then
                        local destinationVec3 = unit:GetPointVec3()
                        if destinationVec3 then
                            local destinationX = destinationVec3.x
                            local destinationY = destinationVec3.y  
                            local destinationZ = destinationVec3.z
                            local destination = POINT_VEC3:New(destinationX, destinationY, destinationZ)

                            trigger.action.outText("📍 Mechaniker fährt nach X=" .. destinationX .. ", Z=" .. destinationZ, 15)
                            
                            -- 📌 Mechaniker erhält Fahrauftrag
                            local route = {
                                id = 'Mission',
                                params = {
                                    route = {
                                        points = {
                                            [1] = {
                                                x = destination.x,
                                                y = destination.z,  
                                                action = 'Cone',
                                                speed = 5,  
                                                formation = 'Column',
                                                task = {}
                                            }
                                        }
                                    }
                                }
                            }

                            -- ✅ Controller einmal setzen (kein doppelter Code!)
                            local controller = spawnGroup:GetController()
                            if controller then
                                trigger.action.outText("✅ Controller für Mechaniker vorhanden! Setze Task...", 15)
                                controller:PushTask(route)
                                trigger.action.outText("🚛 Mechaniker fährt los!", 15)
                            else
                                trigger.action.outText("❌ Fehler: Kein Controller gefunden!", 15)
                            end
                        else
                            trigger.action.outText("❌ Fehler: Keine gültigen Koordinaten für das Ziel!", 15)
                        end
                    else
                        trigger.action.outText("❌ Fehler: Ziel-Einheit nicht gefunden!", 15)
                    end
                else
                    trigger.action.outText("❌ Gruppe " .. groupName .. " nicht gefunden oder tot!", 15)
                end
            end)
            :Spawn()
    else
        trigger.action.outText("❌ Mechaniker-Spawn fehlgeschlagen! Keine gültige Position.", 15)
    end
end

-- 🛠️ Event Handler aktivieren
AirbaseMonitor:HandleEvent(EVENTS.Land)

-- Bestätigung, dass Event Handler läuft
trigger.action.outText("✅ Event Handling für Landung AKTIV!", 15)
