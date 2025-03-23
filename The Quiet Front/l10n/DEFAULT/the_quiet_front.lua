--[[
    The Quiet Front – Phase 1: Ankunft & Aufbau (CTLD-Version)
    Autor: Gerd + ChatGPT
    Datum: 2025-03-21

    Beschreibung:
    Fallschirmjäger-Abwurf über Afghanistan mit CTLD, inkl. Funkspruch + F10 Menü.

    Voraussetzungen:
    - CTLD.lua wurde über Trigger "DO SCRIPT FILE" geladen
    - Transportflugzeug heißt "C130_1"
    - Truppen-Gruppe heißt "Fallschirm_Gruppe" (als Template im Editor)
    - Sounddatei liegt in l10n/DEFAULT/ mit Namen "Abwurf_Fallschirmgruppe.ogg"
]]

-- Prüfen ob Script tatsächlich neu geladen wurde
trigger.action.outText(" Missionsversion 1.13 ", 5)


-- 🧰 CTLD-Konfiguration
ctld.enableParatrooperDrop = true
ctld.paratrooperUnits = {"Fallschirm_Gruppe"} -- Truppennamen aus dem Editor
ctld.dropAltitude = 800           -- Fallschirmsprunghöhe über Boden
ctld.minimumDropAltitude = 600    -- Sicherheitsgrenze

-- 🔧 Debug-Funktion (optional)
local DEBUG = true
function DebugMsg(msg)
    if DEBUG then
        trigger.action.outText("[DEBUG] " .. msg, 10)
    end
end

-- 🎙️ Fallschirmjäger-Abwurf via CTLD
function ManualCTLD_Drop()
    local plane = Unit.getByName("C130_1")
    if not plane then
        trigger.action.outText(" Transportflugzeug 'C130_1' nicht gefunden!", 10)
        return
    end

    -- CTLD-Abwurf auslösen
    ctld.dropTroops(plane)

    -- Funkspruch + Feedback
    trigger.action.soundToAll("Abwurf_Fallschirmgruppe.ogg", 1)
    trigger.action.outText(" Echo Eins: Abwurf läuft - gute Jagd!", 10)

    DebugMsg("Fallschirmjäger-Abwurf ausgelöst.")
end

-- 📋 F10-Menü hinzufügen (für Blue Coalition)
SCHEDULER:New(nil, function()
    MENU_COALITION_COMMAND:New(
        coalition.side.BLUE,
        "Fallschirmjäger ABWURF (CTLD)",
        nil,
        ManualCTLD_Drop
    )
    trigger.action.outText("F10-Menü bereit  Echo Eins steht auf Position.", 5)
end, {}, 5)

-- ✅ Initialmeldung zur Sicherheit
trigger.action.outText(" Fallschirmsprung-Script (CTLD) erfolgreich geladen!", 5)
