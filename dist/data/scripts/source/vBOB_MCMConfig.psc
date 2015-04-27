Scriptname vBOB_MCMConfig extends SKI_ConfigBase  
{MCM and config variable storage script.}

; === [ vBOB_MCMConfig.psc ] ==============================================---
; MCM and config variable storage script.
; ========================================================---

Import Game
Import Utility

;=== Properties ===--


;=== Constants ===--

;=== Config variables ===--

GlobalVariable 	Property vBOB_MasterEnable	 	Auto
GlobalVariable 	Property vBOB_HeadScaleMult 	Auto
GlobalVariable 	Property vBOB_HeadScaleMax	 	Auto
GlobalVariable 	Property vBOB_DeflateOnDeath 	Auto
GlobalVariable 	Property vBOB_PopWithArrow	 	Auto
GlobalVariable 	Property vBOB_AffectFriends 	Auto
GlobalVariable 	Property vBOB_AffectFoes	  	Auto
GlobalVariable 	Property vBOB_AffectNonHumans 	Auto
GlobalVariable 	Property vBOB_AffectPlayer	 	Auto
GlobalVariable 	Property vBOB_UseSmoothScaling	Auto

;=== Controls ===--

Int 			Property OPTION_TOGGLE_MASTER 			Auto
Int 			Property OPTION_TOGGLE_PLAYER 			Auto
Int 			Property OPTION_TOGGLE_FRIENDS 			Auto
Int 			Property OPTION_TOGGLE_FOES 			Auto
Int 			Property OPTION_TOGGLE_NONHUMAN			Auto
Int 			Property OPTION_TOGGLE_SMOOTHSCALING 	Auto
Int 			Property OPTION_TOGGLE_DEFLATEONDEATH 	Auto
Int 			Property OPTION_TOGGLE_POPWITHARROW 	Auto
Int 			Property OPTION_SLIDER_HEADSCALEMULT 	Auto
Int 			Property OPTION_SLIDER_HEADSCALEMAX 	Auto

;=== Variables ===--

Bool 			bTOGGLE_MASTER 			
Bool 			bTOGGLE_PLAYER 			
Bool 			bTOGGLE_FRIENDS 			
Bool 			bTOGGLE_FOES 			
Bool 			bTOGGLE_NONHUMAN			
Bool 			bTOGGLE_DEFLATEONDEATH 
Bool 			bTOGGLE_POPWITHARROW 	
Bool 			bTOGGLE_SMOOTHSCALING
Float 			fSLIDER_HEADSCALEMULT 	
Float			fSLIDER_HEADSCALEMAX

Int Function GetVersion()
    return 1
EndFunction

Event OnVersionUpdate(int a_version)
;	If CurrentVersion < 11
;		OnConfigInit()
;		;Debug.Trace("MYC/MCM: Updating script to version 12...")
;	EndIf
EndEvent

Event OnConfigInit()
	ModName = "$Bobblehead"
	;Pages = New String[1]
	;Pages[0] = "$Options"
	;PopulateSettings()
EndEvent

event OnGameReload()
    parent.OnGameReload()
endEvent

Function PopulateSettings()
	bTOGGLE_MASTER 			= (vBOB_MasterEnable.GetValue() as Int) as Bool
	bTOGGLE_PLAYER 			= (vBOB_AffectPlayer.GetValue() as Int) as Bool
	bTOGGLE_FRIENDS  		= (vBOB_AffectFriends.GetValue() as Int) as Bool		
	bTOGGLE_FOES 	 		= (vBOB_AffectFoes.GetValue() as Int) as Bool
	bTOGGLE_NONHUMAN		= (vBOB_AffectNonHumans.GetValue() as Int) as Bool
	bTOGGLE_SMOOTHSCALING 	= (vBOB_UseSmoothScaling.GetValue() as Int) as Bool
	bTOGGLE_DEFLATEONDEATH  = (vBOB_DeflateOnDeath.GetValue() as Int) as Bool
	bTOGGLE_POPWITHARROW 	= (vBOB_PopWithArrow.GetValue() as Int) as Bool
	fSLIDER_HEADSCALEMULT 	= vBOB_HeadScaleMult.GetValue()
	fSLIDER_HEADSCALEMAX 	= vBOB_HeadScaleMax.GetValue()
EndFunction

Function ApplySettings()
	vBOB_MasterEnable.SetValue(bTOGGLE_MASTER as Int)
	vBOB_AffectPlayer.SetValue(bTOGGLE_PLAYER as Int)
	vBOB_AffectFriends.SetValue(bTOGGLE_FRIENDS as Int)
	vBOB_AffectFoes.SetValue(bTOGGLE_FOES as Int)
	vBOB_AffectNonHumans.SetValue(bTOGGLE_NONHUMAN as Int)
	vBOB_UseSmoothScaling.SetValue(bTOGGLE_SMOOTHSCALING as Int)
	vBOB_DeflateOnDeath.SetValue(bTOGGLE_DEFLATEONDEATH as Int)
	vBOB_PopWithArrow.SetValue(bTOGGLE_POPWITHARROW as Int)
	vBOB_HeadScaleMult.SetValue(fSLIDER_HEADSCALEMULT)
	vBOB_HeadScaleMax.SetValue(fSLIDER_HEADSCALEMAX)

	vBOB__MetaQuestScript kMetaQuest = Quest.GetQuest("vBOB__MetaQuest") as vBOB__MetaQuestScript
	If vBOB_MasterEnable.GetValue()
		kMetaQuest.DoStartup()
	Else
		kMetaQuest.DoShutdown()
	EndIf
EndFunction

Event OnConfigOpen()
	;PopulateSettings()
EndEvent

Event OnConfigClose()
	ApplySettings()
EndEvent

Event OnPageReset(string a_page)

	;If !a_page
	;	a_page = Pages[0]
	;EndIf
	PopulateSettings()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("$Bobblehead options")

	Int iOptionFlags = OPTION_FLAG_NONE

	OPTION_TOGGLE_MASTER 			= AddToggleOption("$Enable Bobbleheads", bTOGGLE_MASTER)
	If !bTOGGLE_MASTER
		iOptionFlags += OPTION_FLAG_DISABLED
	EndIf
	AddEmptyOption()
	AddHeaderOption("$Who gets bobbledheads")
	OPTION_TOGGLE_PLAYER			= AddToggleOption("$Affect player", bTOGGLE_PLAYER,iOptionFlags)
	OPTION_TOGGLE_FRIENDS 			= AddToggleOption("$Affect friends", bTOGGLE_FRIENDS, iOptionFlags)
	OPTION_TOGGLE_FOES 				= AddToggleOption("$Affect foes", bTOGGLE_FOES, iOptionFlags)
	OPTION_TOGGLE_NONHUMAN			= AddToggleOption("$Affect non-humanoid races", bTOGGLE_NONHUMAN, iOptionFlags)
	AddEmptyOption()
	AddHeaderOption("$Extras")
	OPTION_TOGGLE_DEFLATEONDEATH 	= AddToggleOption("$Deflate on death", bTOGGLE_DEFLATEONDEATH, iOptionFlags)
	OPTION_TOGGLE_SMOOTHSCALING 	= AddToggleOption("$Use Smooth scaling", bTOGGLE_SMOOTHSCALING, iOptionFlags)
	;OPTION_TOGGLE_POPWITHARROW 		= AddToggleOption("$Pop with arrow", bTOGGLE_POPWITHARROW, iOptionFlags)
	SetCursorPosition(1)
	AddHeaderOption("$Size options")
	OPTION_SLIDER_HEADSCALEMULT 	= AddSliderOption("$Head scale mult", fSLIDER_HEADSCALEMULT, "{1}", iOptionFlags)
	OPTION_SLIDER_HEADSCALEMAX 		= AddSliderOption("$Head scale max", fSLIDER_HEADSCALEMAX, "{0}", iOptionFlags)
	SetCursorPosition(23)
	AddTextOption("", "Bobbleheads 1.0 by Verteiron", OPTION_FLAG_DISABLED)
EndEvent

Event OnOptionSelect(Int Option)
	If Option == OPTION_TOGGLE_MASTER
		bTOGGLE_MASTER = !bTOGGLE_MASTER
		Int iOptionFlags = OPTION_FLAG_NONE
		If !bTOGGLE_MASTER
			iOptionFlags = OPTION_FLAG_DISABLED
		EndIf
		SetOptionFlags(OPTION_TOGGLE_PLAYER, iOptionFlags, True)
		SetOptionFlags(OPTION_TOGGLE_FRIENDS, iOptionFlags, True)
		SetOptionFlags(OPTION_TOGGLE_FOES, iOptionFlags, True)
		SetOptionFlags(OPTION_TOGGLE_NONHUMAN, iOptionFlags, True)
		SetOptionFlags(OPTION_TOGGLE_DEFLATEONDEATH, iOptionFlags, True)
		SetOptionFlags(OPTION_TOGGLE_SMOOTHSCALING, iOptionFlags, True)
		SetOptionFlags(OPTION_TOGGLE_POPWITHARROW, iOptionFlags, True)
		SetOptionFlags(OPTION_SLIDER_HEADSCALEMULT, iOptionFlags, True)
		SetOptionFlags(OPTION_SLIDER_HEADSCALEMAX, iOptionFlags, True)
		SetToggleOptionValue(Option,bTOGGLE_MASTER)
	ElseIf Option == OPTION_TOGGLE_PLAYER
		bTOGGLE_PLAYER = !bTOGGLE_PLAYER
		SetToggleOptionValue(Option,bTOGGLE_PLAYER)
	ElseIf Option == OPTION_TOGGLE_FRIENDS
		bTOGGLE_FRIENDS = !bTOGGLE_FRIENDS
		SetToggleOptionValue(Option,bTOGGLE_FRIENDS)
	ElseIf Option == OPTION_TOGGLE_FOES
		bTOGGLE_FOES = !bTOGGLE_FOES
		SetToggleOptionValue(Option,bTOGGLE_FOES)
	ElseIf Option == OPTION_TOGGLE_NONHUMAN
		bTOGGLE_NONHUMAN = !bTOGGLE_NONHUMAN
		SetToggleOptionValue(Option,bTOGGLE_NONHUMAN)
	ElseIf Option == OPTION_TOGGLE_DEFLATEONDEATH
		bTOGGLE_DEFLATEONDEATH = !bTOGGLE_DEFLATEONDEATH
		SetToggleOptionValue(Option,bTOGGLE_DEFLATEONDEATH)
	ElseIf Option == OPTION_TOGGLE_SMOOTHSCALING
		bTOGGLE_SMOOTHSCALING = !bTOGGLE_SMOOTHSCALING
		SetToggleOptionValue(Option,bTOGGLE_SMOOTHSCALING)
	ElseIf Option == OPTION_TOGGLE_POPWITHARROW
		bTOGGLE_POPWITHARROW = !bTOGGLE_POPWITHARROW
		SetToggleOptionValue(Option,bTOGGLE_POPWITHARROW)
	EndIf
EndEvent

Event OnOptionSliderOpen(int a_option)
	If a_option == OPTION_SLIDER_HEADSCALEMULT
		SetSliderDialogStartValue(fSLIDER_HEADSCALEMULT)
		SetSliderDialogDefaultValue(1.8)
		SetSliderDialogInterval(0.1)
		SetSliderDialogRange(0.0,fSLIDER_HEADSCALEMAX)
	ElseIf a_option == OPTION_SLIDER_HEADSCALEMAX
		SetSliderDialogStartValue(fSLIDER_HEADSCALEMAX)
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogInterval(1)
		SetSliderDialogRange(0.0,100.0)
	EndIf
EndEvent

Event OnOptionSliderAccept(int a_option, float a_value)
	If a_option == OPTION_SLIDER_HEADSCALEMULT
		fSLIDER_HEADSCALEMULT = a_value
		SetSliderOptionValue(a_option, a_value, "{1}")
	ElseIf a_option == OPTION_SLIDER_HEADSCALEMAX
		fSLIDER_HEADSCALEMAX = a_value
		SetSliderOptionValue(a_option, a_value, "{0}")
	EndIf
EndEvent

Event OnOptionHighlight(Int option)
	If option == OPTION_TOGGLE_MASTER
		SetInfoText("$OPTION_TOGGLE_MASTER_HELP")
	ElseIf Option == OPTION_TOGGLE_PLAYER
		SetInfoText("$OPTION_TOGGLE_PLAYER_HELP")
	ElseIf Option == OPTION_TOGGLE_FRIENDS
		SetInfoText("$OPTION_TOGGLE_FRIENDS_HELP")
	ElseIf Option == OPTION_TOGGLE_FOES
		SetInfoText("$OPTION_TOGGLE_FOES_HELP")
	ElseIf Option == OPTION_TOGGLE_NONHUMAN
		SetInfoText("$OPTION_TOGGLE_NONHUMAN_HELP")
	ElseIf Option == OPTION_TOGGLE_DEFLATEONDEATH
		SetInfoText("$OPTION_TOGGLE_DEFLATEONDEATH_HELP")
	ElseIf Option == OPTION_TOGGLE_SMOOTHSCALING
		SetInfoText("$OPTION_TOGGLE_SMOOTHSCALING_HELP")
	ElseIf Option == OPTION_TOGGLE_POPWITHARROW
		SetInfoText("$OPTION_TOGGLE_POPWITHARROW_HELP")
	ElseIf Option == OPTION_SLIDER_HEADSCALEMULT
		SetInfoText("$OPTION_SLIDER_HEADSCALEMULT_HELP")
	ElseIf Option == OPTION_SLIDER_HEADSCALEMAX
		SetInfoText("$OPTION_SLIDER_HEADSCALEMAX_HELP")
	Else
		SetInfoText("$OPTION_UNKNOWN_HELP")
	EndIf
EndEvent
