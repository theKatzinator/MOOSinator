-- === Phase 1: Infanterie per Truck zum Heli, dann Boarding & Landezone ===

--**************************************
---- Wird im DCS Editor  vorbereitet !!
--***************************************

-- === Heli-Boarding-Phase ===

local CargoHeli = UNIT:FindByName("Heli1")
local LandeZone = ZONE:New("LandeZone1")

-- Warten auf Flag 1 (Infanterie ist beim Heli angekommen)
SCHEDULER:New(nil, function()
  if trigger.misc.getUserFlag(1) == 1 then
    local InfantryGroup = GROUP:FindByName("Infantry")
    if InfantryGroup then
      MESSAGE:New("Infanterie bereit – Einstieg in Heli beginnt!", 10):ToAll()
      local InfantryCargo = CARGO_GROUP:New(InfantryGroup, "Engineers", "Infanterie", 1000)
      InfantryCargo:Board(CargoHeli, 25)

      -- Warten bis Heli in Landezone
      SCHEDULER:New(nil, function()
        if CargoHeli:IsInZone(LandeZone) then
          MESSAGE:New("Heli ist in der Landezone!", 10):ToAll()
          InfantryCargo:UnBoard()

          -- Nach Ausstieg vorrücken in die Mitte der Zone
          SCHEDULER:New(nil, function()
            local moveTo = LandeZone:GetVec2()
            InfantryGroup:RouteToVec2(moveTo)
          end, {}, 10)
        end
      end, {}, 5, 5)
    end
  end
end, {}, 10, 5)
