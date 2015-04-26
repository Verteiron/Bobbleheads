Scriptname vBOB_ActorPollingScript extends Quest  
{Start/stop ApplyBobbleheadSpellQuest.}

;=== Imports ===--

Import Utility
Import Game

;=== Properties ===--

Actor 			Property PlayerRef 						Auto

Quest 			Property vBOB_ApplyBobbleheadSpellQuest Auto

;=== Config variables ===--

GlobalVariable 	Property vBOB_MasterEnable				Auto

;=== Variables ===--

;=== Events ===--

Event OnInit()
	;If IsRunning()
		Debug.Trace("vBOB/ActorPollingScript: Starting up!")
		vBOB_ApplyBobbleheadSpellQuest.Start()
		RegisterForSingleUpdate(5)
	;EndIf
EndEvent

Event OnUpdate()
	;While vBOB_ApplyBobbleheadSpellQuest.IsRunning()
	;	vBOB_ApplyBobbleheadSpellQuest.Stop()
	;	Wait(0.1)
	;EndWhile
	Debug.Trace("vBOB/ActorPollingScript: Checking for new targets...")
	If !vBOB_MasterEnable.GetValue()
		Debug.Trace("vBOB/ActorPollingScript: MasterEnable is off, shutting down!")
		vBOB_ApplyBobbleheadSpellQuest.Stop()
		Stop()
		Return
	EndIf

	vBOB_ApplyBobbleheadSpellQuest.Stop()
	vBOB_ApplyBobbleheadSpellQuest.Start()
	Wait(0.5)

	While vBOB_ApplyBobbleheadSpellQuest.IsRunning()   ; .GetAliasByName("BobbleTarget")
		vBOB_ApplyBobbleheadSpellQuest.Stop()
		vBOB_ApplyBobbleheadSpellQuest.Start()
		Wait(0.5)
	EndWhile
	RegisterForSingleUpdate(5)
EndEvent