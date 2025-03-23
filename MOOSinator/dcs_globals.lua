-- Dummy für IntelliSense – NICHT in DCS einbinden

trigger = {}
trigger.action = {}
function trigger.action.outText(text, time) end
function trigger.action.signalFlare(point, color, intensity) end
function trigger.action.soundToAll(file, volume) end

timer = {}
function timer.getTime() return 0 end
function timer.scheduleFunction(func, args, time) return 0 end

Group = {}
function Group.getByName(name) return {} end

Unit = {}
function Unit.getByName(name) return {} end

ctld = {}
function ctld.dropTroops(unit) end

mist = {}
function mist.scheduleFunction(func, args, time) return 0 end
