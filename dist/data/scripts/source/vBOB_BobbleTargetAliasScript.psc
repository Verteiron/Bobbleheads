Scriptname vBOB_BobbleTargetAliasScript extends ReferenceAlias
{Adds the BobbleFX spell to the target.}

; === [ vBOB_BobbleTargetAliasScript.psc ] ================================---
; Apply the bobblehead effect to the target if it has a suitable head.
; ========================================================---


;=== Imports ===--

Import Utility
Import Game

;=== Properties ===--

Spell 				Property 	vBOB_BobbleFXSpell	Auto

;=== Variables ===--

;=== Events ===--

Event OnInit()
	If GetReference() as Actor
		;Debug.Trace("vBOB: Adding BobbleFX spell to " + (GetReference() as Actor).GetActorBase().GetName())
		(GetReference() as Actor).AddSpell(vBOB_BobbleFXSpell,False)
	EndIf
EndEvent

;Event OnUpdate()
;	If !(GetReference() as Actor).HasSpell(vBOB_BobbleFXSpell)
;		Debug.Trace("vBOB: Adding BobbleFX spell to " + (GetReference() as Actor).GetActorBase().GetName())
;		(GetReference() as Actor).AddSpell(vBOB_BobbleFXSpell,False)
;	EndIf
;EndEvent