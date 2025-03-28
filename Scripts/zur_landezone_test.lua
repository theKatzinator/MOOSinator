
-- Prüfen ob Script tatsächlich neu geladen wurde
trigger.action.outText("Gell da gugsch", 5)


-- 5️⃣ KI-Bodeneinheiten mit Straßenbewegung
local GroundPatrol = SPAWN:New("GroundPatrol") -- Name der Bodeneinheit
:InitLimit(10, 10) -- Maximal 10 Fahrzeuge gleichzeitig
:SpawnScheduled(15, 0.5) -- Alle 10 Sekunden eine neue Einheit

-- 5️⃣ KI-Bodeneinheiten mit Straßenbewegung
local GroundPatrol = SPAWN:New("AirPatrol") -- Name der Bodeneinheit
:InitLimit(10, 10) -- Maximal 10 Fahrzeuge gleichzeitig
:SpawnScheduled(15, 0.5) -- Alle 10 Sekunden eine neue Einheit

-- 5️⃣ KI-Bodeneinheiten mit Straßenbewegung
local GroundPatrol = SPAWN:New("Rebellen") -- Name der Bodeneinheit
:InitLimit(10, 10) -- Maximal 10 Fahrzeuge gleichzeitig
:SpawnScheduled(15, 0.5) -- Alle 10 Sekunden eine neue Einheit

local GroundPatrol = SPAWN:New("T55_Rebellen") -- Name der Bodeneinheit
:InitLimit(5, 5) -- Maximal 10 Fahrzeuge gleichzeitig
:SpawnScheduled(110, 0.5) -- Alle 10 Sekunden eine neue Einheit

-- Spawn a gound vehicle...
Spawn_Vehicle_1 = SPAWN:New( "AirPatrol_1" )
Spawn_Group_1 = Spawn_Vehicle_1:Spawn()