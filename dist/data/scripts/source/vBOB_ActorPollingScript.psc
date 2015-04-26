Scriptname vBOB_ActorPollingScript extends Quest  
{Start/stop ApplyBobbleheadSpellQuest.}

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

Quest Property vBOB_ApplyBobbleheadSpellQuest Auto

;Message Property vMYC_ModLoadedMSG Auto
;Message Property vMYC_ModUpdatedMSG Auto
;Message Property vMYC_ModShutdownMSG Auto

;=== Config variables ===--

;=== Variables ===--

Event OnInit()
	;If IsRunning()
		vBOB_ApplyBobbleheadSpellQuest.Start()
		RegisterForSingleUpdate(5)
	;EndIf
EndEvent

Event OnUpdate()
	;While vBOB_ApplyBobbleheadSpellQuest.IsRunning()
	;	vBOB_ApplyBobbleheadSpellQuest.Stop()
	;	Wait(0.1)
	;EndWhile
	vBOB_ApplyBobbleheadSpellQuest.Stop()
	vBOB_ApplyBobbleheadSpellQuest.Start()
	Wait(0.33)

	While vBOB_ApplyBobbleheadSpellQuest.IsRunning()   ; .GetAliasByName("BobbleTarget")
		vBOB_ApplyBobbleheadSpellQuest.Stop()
		vBOB_ApplyBobbleheadSpellQuest.Start()
		Wait(0.33)
	EndWhile
	RegisterForSingleUpdate(5)
EndEvent