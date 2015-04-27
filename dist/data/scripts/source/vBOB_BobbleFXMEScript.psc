Scriptname vBOB_BobbleFXMEScript extends ActiveMagicEffect
{Apply bobblehead effect to target.}

; === [ vBOB_BobbleFXMEScript.psc ] =======================================---
; Apply the bobblehead effect to the target if it has a suitable head.
; ========================================================---

Import Game
Import Utility

;=== Properties ===--

Form 			Property rigidBodyDummy 		Auto

Actor 			Property PlayerREF				Auto

GlobalVariable 	Property vBOB_HeadScaleMult 	Auto
GlobalVariable 	Property vBOB_HeadScaleMax	 	Auto
GlobalVariable 	Property vBOB_DeflateOnDeath 	Auto
GlobalVariable 	Property vBOB_UseSmoothScaling 	Auto
GlobalVariable 	Property vBOB_MasterEnable		Auto

Spell 			Property vBOB_BobbleFXSpell		Auto

Sound 			Property vBOB_DeflateSM			Auto
Sound 			Property vBOB_InflateSM			Auto

Float 			Property OriginalHeadScale 		Auto Hidden
Float 			Property OriginalRootScale		Auto Hidden
Float 			Property OriginalArmScale		Auto Hidden
Float 			Property OriginalLegScale		Auto Hidden
Float 			Property OriginalFootScale		Auto Hidden
Float 			Property OriginalFingerScale	Auto Hidden
Float 			Property MaxHeadSize = 1.8 		Auto Hidden

Bool 			Property UseNiOverride 			Auto Hidden
Int 			Property ActorSex 				Auto Hidden
Actor 			Property TargetActor 			Auto Hidden

String 			Property HeadNode 				Auto Hidden

Bool 			Property LostMyHead				Auto Hidden
Bool 			Property HitByArrow				Auto Hidden

;=== Events ===--

Event OnEffectStart(Actor akTarget, Actor akCaster)
	TargetActor = akTarget
	HeadNode = PickHeadNodeName()
	If !HeadNode
		Return
	EndIf
	If vBOB_HeadScaleMult
		MaxHeadSize = vBOB_HeadScaleMult.GetValue()
	EndIf 
	OriginalHeadScale 	= NetImmerse.GetNodeScale(ref = akTarget, node = HeadNode, firstPerson = False)
	OriginalRootScale 	= NetImmerse.GetNodeScale(ref = akTarget, node = "NPC COM [COM ]", firstPerson = False)
	OriginalArmScale 	= NetImmerse.GetNodeScale(ref = akTarget, node = "NPC L UpperArm [LUar]", firstPerson = False)
	OriginalLegScale 	= NetImmerse.GetNodeScale(ref = akTarget, node = "NPC R Calf [RClf]", firstPerson = False)
	OriginalFootScale 	= NetImmerse.GetNodeScale(ref = akTarget, node = "NPC R Foot [Rft ]", firstPerson = False)
	OriginalFingerScale = NetImmerse.GetNodeScale(ref = akTarget, node = "NPC L Finger00 [LF00]", firstPerson = False)
	If NiOverride.GetScriptVersion() >= 3
		UseNiOverride = True
	EndIf
	ActorSex = TargetActor.GetActorBase().GetSex()
	RegisterForAnimationEvent(akTarget, "Decapitate")
	RegisterForSingleUpdate(1)
EndEvent

Event OnLoad()
	RegisterForSingleUpdate(1)
EndEvent

Event OnCellAttach()
	RegisterForSingleUpdate(1)
EndEvent

Event OnAttachedToCell()
	RegisterForSingleUpdate(1)
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	If asEventName == "Decapitate"
		LostMyHead = True
	EndIf
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	If akProjectile
		HitByArrow = True
	Else
		HitByArrow = False
	EndIf
EndEvent

State Rescaled
	Event OnLoad()
		;Make sure size is set right.
		NetImmerse.SetNodeScale(TargetActor,HeadNode,OriginalHeadScale * MaxHeadSize,False)
		RegisterForSingleUpdate(1)
	EndEvent

	Event OnCellAttach()
		;Make sure size is set right.
		NetImmerse.SetNodeScale(TargetActor,HeadNode,OriginalHeadScale * MaxHeadSize,False)
		RegisterForSingleUpdate(1)
	EndEvent

	Event OnAttachedToCell()
		;Make sure size is set right.
		NetImmerse.SetNodeScale(TargetActor,HeadNode,OriginalHeadScale * MaxHeadSize,False)
		RegisterForSingleUpdate(1)
	EndEvent
EndState

Event OnCellDetach()
	GoToState("Shutdown")
	TargetActor.RemoveSpell(vBOB_BobbleFXSpell)	
EndEvent

Event OnDetachedFromCell()
	GoToState("Shutdown")
	TargetActor.RemoveSpell(vBOB_BobbleFXSpell)	
EndEvent

Event OnUnload()
	GoToState("Shutdown")
	TargetActor.RemoveSpell(vBOB_BobbleFXSpell)	
EndEvent

Event OnDying(Actor akKiller)
	If vBOB_DeflateOnDeath.GetValue()
		GoToState("Shutdown")
		TargetActor.RemoveSpell(vBOB_BobbleFXSpell)	
	EndIf
EndEvent

Event OnDeath(Actor akKiller)
	If vBOB_DeflateOnDeath.GetValue()
		GoToState("Shutdown")
		TargetActor.RemoveSpell(vBOB_BobbleFXSpell)	
	EndIf
EndEvent

Event OnUpdate()
	If !vBOB_MasterEnable.GetValue()
		GoToState("Shutdown")
		TargetActor.RemoveSpell(vBOB_BobbleFXSpell)	
	EndIf
	If TargetActor.IsDead() && vBOB_DeflateOnDeath.GetValue()
		OnDeath(None)
		Return
	EndIf
	If vBOB_HeadScaleMult
		If vBOB_HeadScaleMult.GetValue() != MaxHeadSize || MaxHeadSize * OriginalHeadScale != NetImmerse.GetNodeScale(ref = TargetActor, node = HeadNode, firstPerson = False)
			MaxHeadSize = vBOB_HeadScaleMult.GetValue()
			If TargetActor.Is3DLoaded()
				ResizeMyHead(MaxHeadSize)
				GoToState("Rescaled")
			EndIf
		EndIf
	EndIf 
	If TargetActor.Is3DLoaded()
		RegisterForSingleUpdate(5)
	Else
		RegisterForSingleUpdate(10)
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	GoToState("Shutdown")
	If TargetActor.Is3DLoaded()
		ResizeMyHead(OriginalHeadScale)
	EndIf
EndEvent

;=== Functions ===--

; Math.easeOutQuad = function (t, b, c, d) {
; 	t /= d;
; 	return -c * t*(t-2) + b;
; };

; Math.EaseInOutQuad = function (t, b, c, d) {
	; t /= d/2;
	; if (t < 1) return c/2*t*t + b;
	; t--;
	; return -c/2 * (t*(t-2) - 1) + b;
; };

Float Function EaseInQuad(Float t, Float b, Float c, Float d)
	t /= d
	return c * t * t + b
EndFunction

Float Function EaseOutQuad(Float t, Float b, Float c, Float d) 
	t /= d
	return -c * t * (t - 2) + b
EndFunction

Float Function EaseInOutQuad(Float t, Float b, Float c, Float d)
	t /= d / 2
	if (t < 1) 
		return c / 2 * t * t + b
	EndIf
	t -= 1
	return -c / 2 * (t * (t - 2) - 1) + b
EndFunction

Float Function BalloonEase(Float t, Float b, Float c, Float d)
	If c >= 0
		Return EaseOutQuad(t,b,c,d)
	Else
		Return EaseInQuad(t,b,c,d)
	EndIf
EndFunction

Function ResizeMyHead(Float afTargetScale)
	GoToState("Busy")
	DoRescaling(OriginalHeadScale * afTargetScale)
	GoToState("")
EndFunction

Function DoRescaling(Float afTargetScale)
	If afTargetScale < 0
		TargetActor.RemoveSpell(vBOB_BobbleFXSpell)
		Return
	EndIf
	If afTargetScale > vBOB_HeadScaleMax.GetValue()
		afTargetScale = vBOB_HeadScaleMax.GetValue()
	EndIf
	Float fCurrentHeadScale = NetImmerse.GetNodeScale(ref = TargetActor, node = HeadNode, firstPerson = False)
	If !fCurrentHeadScale || fCurrentHeadScale == afTargetScale
		Return
	EndIf
	Float fHeadScaleDelta 	= afTargetScale - fCurrentHeadScale
	Float RootScaleDelta	= OriginalRootScale * 0.75
	Float ArmScaleDelta		= OriginalArmScale * 0.9
	Float LegScaleDelta		= OriginalLegScale * 0.6
	Float FootScaleDelta	= OriginalFootScale * 2.0
	Float FingerScaleDelta	= OriginalArmScale * 0.6

	Float fVolume = 1.0
	Int iNumSteps = (Math.Abs(fHeadScaleDelta) * 30) as Int
	If LostMyHead
		iNumSteps = 100
	EndIf
	If iNumSteps < 30
		iNumSteps = 30
	ElseIf iNumSteps > 100
		iNumSteps = 100
	EndIf
	Int iStep = 0
	;Debug.Trace("vBOB/" + TargetActor.GetActorBase().GetName() + ": Head node starting at " + fCurrentHeadScale)
	If PlayerREF.HasLOS(TargetActor) && vBOB_UseSmoothScaling.GetValue()
		;Debug.Trace("vBOB/" + TargetActor.GetActorBase().GetName() + ": Player can see me, using smooth scaling...")
		Int iSoundID = 0
		If !(TargetActor == PlayerREF && GetCameraState() == 0) ; Don't play in first-person, it's really loud
			If fHeadScaleDelta > 0
				iSoundID = vBOB_InflateSM.Play(TargetActor)
			ElseIf fHeadScaleDelta < 0
				iSoundID = vBOB_DeflateSM.Play(TargetActor)
			EndIf
		EndIf
		While iStep < iNumSteps
			Float fHeadNodeScale = BalloonEase(iStep,fCurrentHeadScale,fHeadScaleDelta,iNumSteps)
			NetImmerse.SetNodeScale(TargetActor,HeadNode,fHeadNodeScale,False)
			Float fPercent = (iStep as Float) / (iNumSteps as Float)
			If fPercent > 0.75 && iSoundID
				fVolume = (1.0 - fPercent) / 0.25
				;Debug.Trace("vBOB/" + TargetActor.GetActorBase().GetName() + ": Setting volume to " + fVolume)
				Sound.SetInstanceVolume(iSoundID, fVolume)
			EndIf
			iStep += 1
		EndWhile
		If iSoundID
			Sound.StopInstance(iSoundID)
		EndIf
	EndIf
	;Make sure size is set right.
	NetImmerse.SetNodeScale(TargetActor,HeadNode,afTargetScale,False)
	;Debug.Trace("vBOB/" + TargetActor.GetActorBase().GetName() + ": Finished scaling node at " + afTargetScale)
	;String sModKey = "Bobblehead"
	;Int iSex = TargetActor.GetActorBase().GetSex()

	;Function AddNodeTransformScale(ObjectReference akRef, bool firstPerson, bool isFemale, string nodeName, string key, float scale) native global
	;NetImmerse.SetNodeScale(ref = TargetActor, node = "NPC COM [COM ]", scale = RootScaleDelta, firstPerson = False)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC COM [COM ]", sModKey, RootScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC L Finger00 [LF00]", sModKey, FingerScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC L Finger10 [LF10]", sModKey, FingerScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC L Finger20 [LF20]", sModKey, FingerScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC L Finger30 [LF30]", sModKey, FingerScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC L Finger40 [LF40]", sModKey, FingerScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC R Finger00 [RF00]", sModKey, FingerScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC R Finger10 [RF10]", sModKey, FingerScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC R Finger20 [RF20]", sModKey, FingerScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC R Finger30 [RF30]", sModKey, FingerScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC R Finger40 [RF40]", sModKey, FingerScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC L UpperArm [LUar]", sModKey, ArmScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC R UpperArm [RUar]", sModKey, ArmScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC L Foot [Lft ]", sModKey, FootScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC R Foot [Rft ]", sModKey, FootScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC L Calf [LClf]", sModKey, LegScaleDelta)
	;NiOverride.AddNodeTransformScale(TargetActor, False, iSex, "NPC R Calf [RClf]", sModKey, LegScaleDelta)
;
	;NiOverride.UpdateAllReferenceTransforms(TargetActor)
	
EndFunction

Function SetNodeScale(Actor akActor, String asNodeName, Float afScale)
	If UseNiOverride
		NiOverride.AddNodeTransformScale(akActor, False, ActorSex, asNodeName, "Bobblehead", afScale)
		NiOverride.UpdateNodeTransform(akActor, False, ActorSex, asNodeName)
	Else
		NetImmerse.SetNodeScale(akActor, asNodeName, afScale, False)
	EndIf
EndFunction

String Function PickHeadNodeName()
	String[] sHeadNodeNames = New String[128]
	sHeadNodeNames[0] 		= "NPC Head [Head]"
	sHeadNodeNames[1] 		= "HEAD"
	sHeadNodeNames[2] 		= "NPC Head"
	sHeadNodeNames[3] 		= "Scull"
	sHeadNodeNames[4] 		= "ElkScull"
	sHeadNodeNames[5] 		= "HorseScull"
	sHeadNodeNames[6] 		= "Canine_Head"
	sHeadNodeNames[7] 		= "Goat_Head01"
	sHeadNodeNames[8] 		= "Horker_Head"
	sHeadNodeNames[9] 		= "Mammoth Head"
	sHeadNodeNames[10] 		= "Sabrecat_Head [Head]"
	sHeadNodeNames[11] 		= "DragPriestNPC Head [Head]"
	sHeadNodeNames[12] 		= "SlaughterfishHead"
	sHeadNodeNames[13] 		= "Wisp Head"
	sHeadNodeNames[14] 		= "RabbitHead"
	sHeadNodeNames[15] 		= "ChaurusFlyerHead"
	sHeadNodeNames[16] 		= "DwarvenSpiderHead_XYZ"
	sHeadNodeNames[17] 		= "IW Head"
	sHeadNodeNames[18] 		= "FireAtronach_Head [Head]"
	sHeadNodeNames[19] 		= "Bip01 Head"
	
	Int i = 0
	While i < sHeadNodeNames.Length
		If NetImmerse.HasNode(TargetActor, sHeadNodeNames[i], False)
			Return sHeadNodeNames[i]
		EndIf
		i += 1
	EndWhile

	Return ""
EndFunction

State Busy

	;Event OnLoad()
	;EndEvent

	Function ResizeMyHead(Float afTargetScale)
	EndFunction

	Event OnCellAttach()
		GoToState("")
		RegisterForSingleUpdate(1)
	EndEvent

	Event OnAttachedToCell()
		GoToState("")
		RegisterForSingleUpdate(1)
	EndEvent


EndState

State Shutdown
	Event OnLoad()
		
	EndEvent

	Event OnUnload()
		
	EndEvent

	Event OnUpdate()
		
	EndEvent

	Event OnCellAttach()
		
	EndEvent

	Event OnCellDetach()
		
	EndEvent

	Event OnAttachedToCell()
		
	EndEvent

	Event OnDetachedFromCell()
		
	EndEvent

	Event OnDeath(Actor akKiller)
		
	EndEvent

	Event OnDying(Actor akKiller)
		
	EndEvent
EndState