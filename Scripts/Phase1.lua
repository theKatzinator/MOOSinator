-- === Phase 1: Infanterie per Truck zum Heli, dann Boarding & Landezone ===

--**************************************
---- Wird im DCS Editor  vorbereitet !!
--***************************************


-- === Phase 1.1: Heli Boarding & Flug zur Landezone per Script ===

local CargoHeli = UNIT:FindByName("Heli1")
local LandeZone = ZONE:New("LandeZone1")


    -- Heli fliegt per Script zur Landezone (kein Wegpunkt nötig)
      MESSAGE:New("Heli fliegt zur Landezone!", 10):ToAll()
      CargoHeli:RouteToVec2(LandeZone:GetVec2())

      -- Warten bis Heli in Landezone ist
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
      end, {}, 5, 5) -- prüft alle 5 Sekunden