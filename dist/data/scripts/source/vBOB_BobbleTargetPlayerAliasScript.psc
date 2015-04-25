Scriptname vBOB_BobbleTargetPlayerAliasScript extends ReferenceAlias
{Adds the BobbleFX spell to the target.}

; === [ vBOB_BobbleTargetPlayerAliasScript.psc ] ==========================---
; Track the player and do stuff to other actors.
; ========================================================---


;=== Imports ===--

Import Utility
Import Game

;=== Properties ===--

Actor 				Property 	PlayerREF	 		Auto

Spell 				Property 	vBOB_BobbleFXSpell	Auto

;=== Variables ===--

;=== Events ===--

Event OnInit()
	If PlayerREF
		If !PlayerREF.HasSpell(vBOB_BobbleFXSpell)
			PlayerREF.AddSpell(vBOB_BobbleFXSpell)
		EndIf
	EndIf
EndEvent

Event OnPlayerLoadGame()
	If PlayerREF
		If !PlayerREF.HasSpell(vBOB_BobbleFXSpell)
			PlayerREF.AddSpell(vBOB_BobbleFXSpell)
		EndIf
	EndIf
EndEvent

Event OnUpdate()
	
EndEvent

Event OnCellLoad()
	If PlayerREF
		If !PlayerREF.HasSpell(vBOB_BobbleFXSpell)
			PlayerREF.AddSpell(vBOB_BobbleFXSpell)
		EndIf
	EndIf
EndEvent
