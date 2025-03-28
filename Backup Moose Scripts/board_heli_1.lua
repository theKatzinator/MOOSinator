-- Einheiten definieren
local Infantry = GROUP:FindByName("Infantry")
local InfantryCargo = CARGO_GROUP:New(Infantry, "InfantryCargo", "Soldaten", 2000)

local Heli = GROUP:FindByName("Helicopter")
local Truck = GROUP:FindByName("Truck")

-- Transporte definieren (Wichtig: Klasse anpassen!)
local HeliTransport = CARGO_HELICOPTER:New(Heli, "HeliTransport")
local TruckTransport = CARGO_GROUP:New(Truck, "TruckTransport")

-- Zonen definieren
local PickupZone = ZONE:New("PickupZone")          
local HeliLandingZone = ZONE:New("Heli_LZ")        
local TruckDestination = ZONE:New("Truck_Destination")

-- Schritt 1: Heli holt Infanterie automatisch in der PickupZone ab
HeliTransport:Pickup(InfantryCargo, PickupZone:GetVec2(), 150)

-- Schritt 2: Sobald Infanterie im Heli geladen ist, fliegt Heli zur Landezone
function InfantryCargo:OnEnterLoaded(From, Event, To, Carrier)
  if Carrier == HeliTransport then
    HeliTransport:Deploy(HeliLandingZone:GetVec2(), 150)
  end
  
  if Carrier == TruckTransport then
    TruckTransport:GetCarrierGroup():RouteToVec2(TruckDestination:GetVec2(), 60)
  end
end

-- Schritt 3: Sobald Infanterie ausgeladen wurde, steigt sie automatisch in Truck ein
function InfantryCargo:OnEnterUnLoaded(From, Event, To, Carrier)
  if Carrier == HeliTransport then
    InfantryCargo:Board(TruckTransport, 25)
  end
end
