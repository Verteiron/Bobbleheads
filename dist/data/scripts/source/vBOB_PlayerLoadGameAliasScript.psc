Scriptname vBOB_PlayerLoadGameAliasScript extends ReferenceAlias
{Attach to Player alias. Enables the quest to receive the OnGameReload event.}

; === [ vBOB_PlayerLoadGameAliasScript.psc ] ==============================---
; Enables the owningquest to do its upkeep.
; ========================================================---

;=== Events ===--

Event OnPlayerLoadGame()
	(GetOwningQuest() as vBOB__MetaQuestScript).DoUpkeep()
EndEvent
