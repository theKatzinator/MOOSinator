-- 5️⃣ KI-Bodeneinheiten mit Straßenbewegung
local GroundPatrol = SPAWN:New("Infantry") -- Name der Bodeneinheit
:InitLimit(10, 10) -- Maximal 10 Soldaten gleichzeitig
:SpawnScheduled(15, 0.5) -- Alle 10 Sekunden eine neue Einheit
