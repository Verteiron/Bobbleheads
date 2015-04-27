Scriptname vBOB__MetaQuestScript extends Quest  
{Do initialization and track variables for scripts.}

; === [ vBOB__MetaQuestScript.psc ] =======================================---
; Quest that tracks, stops, starts other quests.
; ========================================================---

;=== Imports ===--

Import Utility
Import Game

;=== Properties ===--

Actor 	Property PlayerRef 							Auto

Quest 	Property vBOB_ActorPollingQuest 			Auto
Quest 	Property vBOB_ApplyBobbleheadSpellQuest 	Auto

Bool 	Property Ready 				= False			Auto Hidden
Float 	Property ModVersion 						Auto Hidden
Int 	Property ModVersionInt 						Auto Hidden

Int 	Property ModVersionMajor 					Auto Hidden
Int 	Property ModVersionMinor 					Auto Hidden
Int 	Property ModVersionPatch 					Auto Hidden

String 	Property ModName 			= "Bobbleheads"	Auto Hidden

;=== Config variables ===--

;=== Variables ===--

Float _CurrentVersion
Int _iCurrentVersion
String _sCurrentVersion

;=== Events ===--

Event OnInit()
	If IsRunning()
		RegisterForSingleUpdate(1)
	EndIf
EndEvent

Event OnUpdate()
	DoUpkeep(False)
EndEvent

Function DoStartup()
	DebugTrace("Starting up!")
	If !vBOB_ActorPollingQuest.IsRunning()
		DebugTrace("Starting up!")
		DebugTrace("Starting vBOB_ActorPollingQuest!")
		vBOB_ActorPollingQuest.Start()
	EndIf
	ModVersion = _iCurrentVersion
EndFunction

Function DoUpkeep(Bool DelayedStart = True)
	DebugTrace("Doing upkeep!")

	;FIXME: CHANGE THIS WHEN UPDATING!
	ModVersionMajor = 1
	ModVersionMinor = 0
	ModVersionPatch = 0
	_iCurrentVersion = GetVersionInt(ModVersionMajor,ModVersionMinor,ModVersionPatch)
	_sCurrentVersion = GetVersionString(_iCurrentVersion)
	String sModVersion = GetVersionString(ModVersion as Int)
	Ready = False
	If DelayedStart
		Wait(RandomFloat(3,5))
	EndIf
	String sErrorMessage
	DebugTrace("" + ModName)
	DebugTrace("Performing upkeep...")
	DebugTrace("Loaded version is " + sModVersion + ", Current version is " + _sCurrentVersion)
	If !CheckDependencies()
		DebugTrace("Failed dependency check, aborting!")
		Return
	EndIf
	If ModVersion == 0
		DebugTrace("Newly installed, doing initialization...")
		DoStartup()
		If ModVersion == _iCurrentVersion
			DebugTrace("Initialization succeeded.")
		Else
			DebugTrace("WARNING! Initialization had a problem!")
		EndIf
	ElseIf ModVersion < _iCurrentVersion
		DebugTrace("Installed version is older. Starting the upgrade...")
		DoUpgrade()
		If ModVersion != _iCurrentVersion
			DebugTrace("WARNING! Upgrade failed!")
			Debug.MessageBox("WARNING! " + ModName + " upgrade failed for some reason. You should report this to the mod author.")
		EndIf
		DebugTrace("Upgraded to " + GetVersionString(_iCurrentVersion))
	Else
		DebugTrace("Loaded, no updates.")
	EndIf
	DebugTrace("Upkeep complete!")
	Ready = True
EndFunction

Function DoUpgrade()
	;Nothing here, yet!
EndFunction

Function DoShutdown()
	DebugTrace("Shutting down!")
	If vBOB_ActorPollingQuest.IsRunning()
		DebugTrace("Stopping vBOB_ActorPollingQuest!")
		vBOB_ActorPollingQuest.Stop()
	EndIf
	If vBOB_ApplyBobbleheadSpellQuest.IsRunning()
		DebugTrace("Stopping vBOB_ApplyBobbleheadSpellQuest!")
		vBOB_ApplyBobbleheadSpellQuest.Stop()
	EndIf
EndFunction

Bool Function CheckDependencies()
	Float fSKSE = SKSE.GetVersion() + SKSE.GetVersionMinor() * 0.01 + SKSE.GetVersionBeta() * 0.0001
	DebugTrace("SKSE is version " + fSKSE)
	If fSKSE < 1.07
		Debug.MessageBox("Bobbleheads\nThis mod requires SKSE 1.7 or higher, but it seems to be missing or out of date.\nIt is very unlikely the mod will work properly!")
		Return False
	Else
		;Proceed
	EndIf
	Return True
EndFunction

Int Function GetVersionInt(Int iMajor, Int iMinor, Int iPatch)
	Return Math.LeftShift(iMajor,16) + Math.LeftShift(iMinor,8) + iPatch
EndFunction

String Function GetVersionString(Int iVersion)
	Int iMajor = Math.RightShift(iVersion,16)
	Int iMinor = Math.LogicalAnd(Math.RightShift(iVersion,8),0xff)
	Int iPatch = Math.LogicalAnd(iVersion,0xff)
	String sMajorZero
	String sMinorZero
	String sPatchZero
	If !iMajor
		sMajorZero = "0"
	EndIf
	If !iMinor
		sMinorZero = "0"
	EndIf
	Return sMajorZero + iMajor + "." + sMinorZero + iMinor + "." + sPatchZero + iPatch
EndFunction

Function DebugTrace(String sDebugString, Int iSeverity = 0)
	Debug.Trace("vBOB/MetaQuest: " + sDebugString,iSeverity)
EndFunction
