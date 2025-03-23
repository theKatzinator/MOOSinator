---
-- CONDITION: Any and All
-- 
-- This is a simple example demonstrating any and all conditions.
-- 
-- Two groups are outside of a zone will drive inside the zone. 
-- 
-- We define two conditions:
-- One returns true if ANY group is inside the zone.
-- The second will return true if ALL groups are inside the zone.
---

-- Define the zone where we check the groups.
local zone=ZONE:FindByName("Kobuleti X"):DrawZone()

-- Get the two ground groups.
local group1=GROUP:FindByName("Ground-1")
local group2=GROUP:FindByName("Ground-2")

--- Function that return true if a given group is completely inside a zone.
local function GroupInZone(_group)
  local group=_group --Wrapper.Group#GROUP
  return group:IsCompletelyInZone(zone)
end

-- Create a new condition instance.
local conditionAny=CONDITION:New("Any Group In Zone")

-- Add ANY condition functions. If any of these passed functions (GroupInZone) returns true, the condition will return true when evaluated.
conditionAny:AddFunctionAny(GroupInZone, group1)
conditionAny:AddFunctionAny(GroupInZone, group2)


-- Create a new condition instance.
local conditionAll=CONDITION:New("All Groups in Zone")

-- Add ALL condition functions. Here ALL of these passed functions (GroupInZone) must return true for the condition to return true when evaluated.
conditionAll:AddFunctionAll(GroupInZone, group1)

-- We can also use the GROUP.IsCompletelyInZone function directly. Note that we must pass the group and the zone as arguments now.
conditionAll:AddFunctionAll(GROUP.IsCompletelyInZone, group2, zone)


--- Function that evaluates the conditions and prints some output.
local function eval()

  -- Evaluate ANY condition. Will return true, if ANY group is in the zone and false otherwise.
  local isAny=conditionAny:Evaluate()
  
  -- Evaluate ALL condition. Will return true, if ALL groups are in the zone and false otherwise.
  local isAll=conditionAll:Evaluate()
  
  -- Flare the zone with colour depending on present state of conditions.
  if isAll then
    zone:FlareZone(FLARECOLOR.Green)
  elseif isAny then
    zone:FlareZone(FLARECOLOR.Red)
  else
    zone:FlareZone(FLARECOLOR.White)
  end
  
  -- Text message to screen and to log file.
  local text=string.format("Any group in zone is %s\n", tostring(isAny))
  text=text..string.format("ALL groups in zone is %s", tostring(isAll))
  MESSAGE:New(text, 10):ToAll():ToLog()  
end

-- Timer that evaluates the conditions every 10 seconds.
local timer=TIMER:New(eval):Start(10, 10)