-- === Phase 1b: Heli landet per Script in EinstiegZone, dann Boarding & Weiterflug ===

local CargoHeli = UNIT:FindByName("Heli1")
local EinstiegZone = ZONE:New("EinstiegZone")
local LandeZone = ZONE:New("LandeZone1")

-- Heli fliegt zur Einstiegszone und landet dort
MESSAGE:New("Heli startet vom Stützpunkt und fliegt zur Einstiegszone!", 10):ToAll()
CargoHeli:CommandLandAtZone(EinstiegZone)

-- Sobald Heli in der Einstiegszone ist UND gelandet ist → Boarding
SCHEDULER:New(nil, function()
  if CargoHeli:IsInZone(EinstiegZone) and CargoHeli:IsLanding() then
    local InfantryGroup = GROUP:FindByName("Infantry")
    if InfantryGroup then
      MESSAGE:New("Heli gelandet – Infanterie steigt ein!", 10):ToAll()
      local InfantryCargo = CARGO_GROUP:New(InfantryGroup, "Engineers", "Infanterie", 1000)
      InfantryCargo:Board(CargoHeli, 25)

      -- Weiterflug zur Landezone
      SCHEDULER:New(nil, function()
        MESSAGE:New("Heli fliegt zur Landezone!", 10):ToAll()
        CargoHeli:RouteToVec2(LandeZone:GetVec2())

        -- In Landezone: Ausstieg und Vorrücken
        SCHEDULER:New(nil, function()
          if CargoHeli:IsInZone(LandeZone) then
            MESSAGE:New("Heli ist in der Landezone – Ausstieg beginnt!", 10):ToAll()
            InfantryCargo:UnBoard()

            SCHEDULER:New(nil, function()
              local moveTo = LandeZone:GetVec2()
              InfantryGroup:RouteToVec2(moveTo)
            end, {}, 10)
          end
        end, {}, 5, 5)
      end, {}, 10)
    end
  end
end, {}, 5, 5)
