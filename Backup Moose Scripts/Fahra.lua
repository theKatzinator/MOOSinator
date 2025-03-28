-- === Phase 1: Landung & Vorrücken bei Farah ===

-- Einheiten & Zonen finden
local InfantryGroup = GROUP:FindByName("Infantry")
local CargoHeli = UNIT:FindByName("Heli1")
local LandeZone = ZONE:New("LandeZone1")

-- Infanterie als Cargo deklarieren
local InfantryCargo = CARGO_GROUP:New(InfantryGroup, "Engineers", "Infanterie", 2000)

-- Infanterie einsteigen lassen
InfantryCargo:Board(CargoHeli, 25)

-- Regelmäßige Prüfung, ob der Heli in der Landezone ist
SCHEDULER:New(nil, function()
  if CargoHeli:IsInZone(LandeZone) then
    MESSAGE:New("Heli ist in der Landezone!", 10):ToAll()

    -- Aussteigen
    InfantryCargo:UnBoard()

    -- Nach 10 Sekunden: Vorrücken in die Mitte der Zone
    SCHEDULER:New(nil, function()
      local moveTo = LandeZone:GetVec2()
      InfantryGroup:RouteToVec2(moveTo)
    end, {}, 10)
  end
end, {}, 5, 5) -- alle 5 Sekunden prüfen
