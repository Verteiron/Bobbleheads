Scriptname vBOB__MetaQuestScript extends Quest  
{Do initialization and track variables for scripts.}

;=== Imports ===--

Import Utility
Import Game

;=== Properties ===--

Actor 	Property PlayerRef 							Auto

Quest 	Property vBOB_ActorPollingQuest 			Auto
Quest 	Property vBOB_ApplyBobbleheadSpellQuest 	Auto

Message Property vBOB_ModLoadedMSG 					Auto
Message Property vBOB_ModUpdatedMSG 				Auto
Message Property vBOB_ModShutdownMSG 				Auto


Bool 	Property Ready 				= False			Auto Hidden
Float 	Property ModVersion 						Auto Hidden
Int 	Property ModVersionInt 						Auto Hidden

Int 	Property ModVersionMajor 					Auto Hidden
Int 	Property ModVersionMinor 					Auto Hidden
Int 	Property ModVersionPatch 					Auto Hidden

String 	Property ModName 			= "Bobblehead"	Auto Hidden

;=== Config variables ===--

;=== Variables ===--

;=== Events ===--

Event OnInit()
	;If IsRunning()
		RegisterForSingleUpdate(1)
	;EndIf
EndEvent

Event OnUpdate()
	DoStartup()
EndEvent

Function DoStartup()
	Debug.Trace("vBOB/MetaQuest: Starting up!")
	If !vBOB_ActorPollingQuest.IsRunning()
		Debug.Trace("vBOB/MetaQuest: Starting vBOB_ActorPollingQuest!")
		vBOB_ActorPollingQuest.Start()
	EndIf
EndFunction

Function DoUpkeep(Bool abBackground = True)
	
EndFunction

Function DoShutdown()
	Debug.Trace("vBOB/MetaQuest: Shutting down!")
	If vBOB_ActorPollingQuest.IsRunning()
		Debug.Trace("vBOB/MetaQuest: Stopping vBOB_ActorPollingQuest!")
		vBOB_ActorPollingQuest.Stop()
	EndIf
	If vBOB_ApplyBobbleheadSpellQuest.IsRunning()
		Debug.Trace("vBOB/MetaQuest: Stopping vBOB_ApplyBobbleheadSpellQuest!")
		vBOB_ApplyBobbleheadSpellQuest.Stop()
	EndIf

EndFunction