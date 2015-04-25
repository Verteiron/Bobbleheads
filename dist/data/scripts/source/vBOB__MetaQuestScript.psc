Scriptname vBOB__MetaQuestScript extends Quest  
{Do initialization and track variables for scripts.}

;=== Imports ===--

Import Utility
Import Game

;=== Properties ===--

Actor Property PlayerRef Auto

Bool Property Ready = False Auto

Float Property ModVersion Auto Hidden
Int Property ModVersionInt Auto Hidden

Int Property ModVersionMajor Auto Hidden
Int Property ModVersionMinor Auto Hidden
Int Property ModVersionPatch Auto Hidden

String Property ModName = "Bobblehead" Auto Hidden

Quest Property vBOB_ApplyBobbleheadSpell Auto

;Message Property vMYC_ModLoadedMSG Auto
;Message Property vMYC_ModUpdatedMSG Auto
;Message Property vMYC_ModShutdownMSG Auto

VisualEffect 	Property vMYC_FFLogoEffect 	Auto
;=== Config variables ===--

;=== Variables ===--

Event OnInit()
	;If IsRunning()
		vBOB_ApplyBobbleheadSpell.Start()
		RegisterForSingleUpdate(5)
	;EndIf
EndEvent

Event OnUpdate()
	;While vBOB_ApplyBobbleheadSpell.IsRunning()
	;	vBOB_ApplyBobbleheadSpell.Stop()
	;	Wait(0.1)
	;EndWhile
	vBOB_ApplyBobbleheadSpell.Stop()
	vBOB_ApplyBobbleheadSpell.Start()
	Wait(0.33)

	While vBOB_ApplyBobbleheadSpell.IsRunning()   ; .GetAliasByName("BobbleTarget")
		vBOB_ApplyBobbleheadSpell.Stop()
		vBOB_ApplyBobbleheadSpell.Start()
		Wait(0.33)
	EndWhile
	RegisterForSingleUpdate(5)
EndEvent