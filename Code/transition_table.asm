;Bank $91:
;transition table

;transition table currently ends at $91AC88, 983 (0x387) bytes of free space from AC88 to B00F

org $919EE2
; --- Kejardon, Scyzer, Quote58 ---
; if using notepad++, you can fold all the {} to find poses by catagory

macro t_1(press, hold, option_bit, pose)					;format for pose transition data: buttons pressed this frame, buttons held, pose to transition to
	dw <press>, <hold>
	db <pose>, <option_bit>
endmacro

macro t_2(press, hold_1, hold_2, option_bit, pose)			;many poses require multiple buttons to be held, so this adds multiple buttons together for readability
	dw <press>, <hold_1>+<hold_2>
	db <pose>, <option_bit>
endmacro

macro t_3(press, hold_1, hold_2, hold_3, option_bit, pose)
	dw <press>, <hold_1>+<hold_2>+<hold_3>
	db <pose>, <option_bit>
endmacro

!TRun	 = $8000
!TCancel = $4000
!TSelect = $2000
!TStart	 = $1000
!TUp	 = $0800
!TDown	 = $0400
!TLeft	 = $0200
!TRight	 = $0100
!TJump	 = $0080
!TFire	 = $0040
!TAimD	 = $0020
!TAimU	 = $0010
!TNone	 = $0000
!TEnd	 = $FFFF

!Quick_morph_right	  = %t_2(!TNone, !TCancel, !TDown, !C_O_Quickmorph, $37)
!Quick_morph_left	  = %t_2(!TNone, !TCancel, !TDown, !C_O_Quickmorph, $38)

!Quick_morph_altr	  = %t_2(!TNone, !TAimD, !TDown, !C_O_Quickmorph, $37)
!Quick_morph_altl	  = %t_2(!TNone, !TAimD, !TDown, !C_O_Quickmorph, $38)

!Upspin_right		  = %t_2(!TJump, !TRun, !TNone, !C_O_Upspin, $19)
!Upspin_left		  = %t_2(!TJump, !TRun, !TNone, !C_O_Upspin, $1A)

!Ballspin_right		  = %t_1(!TJump, !TRun, !C_O_Upspin, $19) 	;isn't this basically the same as upspin?
!Ballspin_left		  = %t_1(!TJump, !TRun, !C_O_Upspin, $1A)

!Respin_right		  = %t_1(!TJump, !TNone, !C_O_Respin, $19)
!Respin_left		  = %t_1(!TJump, !TNone, !C_O_Respin, $1A)

!Backflip_right		  = %t_2(!TNone, !TRun, !TJump, !C_O_Backflip, $50)
!Backflip_left		  = %t_2(!TNone, !TRun, !TJump, !C_O_Backflip, $4F)

	dw T00,T01,T02,T03,T04,T05,T06,T07,T08,T09,T0A,T0B,T0C,T0D,T0E,T0F
	dw T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T1A,T1B,T1C,T1D,T1E,T1F
	dw T20,T21,T22,T23,T24,T25,T26,T27,T28,T29,T2A,T2B,T2C,T2D,T2E,T2F
	dw T30,T31,T32,T33,T34,T35,T36,T37,T38,T39,T3A,T3B,T3C,T3D,T3E,T3F
	dw T40,T41,T42,T43,T44,T45,T46,T47,T48,T49,T4A,T4B,T4C,T4D,T4E,T4F
	dw T50,T51,T52,T53,T54,T55,T56,T57,T58,T59,T5A,T5B,T5C,T5D,T5E,T5F
	dw T60,T61,T62,T63,T64,T65,T66,T67,T68,T69,T6A,T6B,T6C,T6D,T6E,T6F
	dw T70,T71,T72,T73,T74,T75,T76,T77,T78,T79,T7A,T7B,T7C,T7D,T7E,T7F
	dw T80,T81,T82,T83,T84,T85,T86,T87,T88,T89,T8A,T8B,T8C,T8D,T8E,T8F
	dw T90,T91,T92,T93,T94,T95,T96,T97,T98,T99,T9A,T9B,T9C,T9D,T9E,T9F
	dw TA0,TA1,TA2,TA3,TA4,TA5,TA6,TA7,TA8,TA9,TAA,TAB,TAC,TAD,TAE,TAF
	dw TB0,TB1,TB2,TB3,TB4,TB5,TB6,TB7,TB8,TB9,TBA,TBB,TBC,TBD,TBE,TBF
	dw TC0,TC1,TC2,TC3,TC4,TC5,TC6,TC7,TC8,TC9,TCA,TCB,TCC,TCD,TCE,TCF
	dw TD0,TD1,TD2,TD3,TD4,TD5,TD6,TD7,TD8,TD9,TDA,TDB,TDC,TDD,TDE,TDF
	dw TE0,TE1,TE2,TE3,TE4,TE5,TE6,TE7,TE8,TE9,TEA,TEB,TEC,TED,TEE,TEF
	dw TF0,TF1,TF2,TF3,TF4,TF5,TF6,TF7,TF8,TF9,TFA,TFB,TFC

;------ the transitions ------ {

;elevator poses {
T00:									;Facing forward, ala Elevator pose (power suit)
T9B:									;Facing forward, ala Elevator pose (Varia and/or Gravity Suit)
dw !TNone,!TRight,$0026
dw !TNone,!TLeft, $0025
dw !TEnd
}

;facing right {
T01:									;Facing right, normal
; --- new ---
	!Quick_morph_right
; -----------
T03:									;Facing right, aiming up
T05:									;Facing right, aiming upright
T07:									;Facing right, aiming Downright
TA4:									;Landing from normal jump, facing right
TA6:									;Landing from spin jump, facing right
TE0:									;Landing from normal jump, facing right and aiming up
TE2:									;Landing from normal jump, facing right and aiming upright
TE4:									;Landing from normal jump, facing right and aiming Downright
TE6:									;Landing from normal jump, facing right, firing
; --- new ---
	!Upspin_right						;When holding run, a normal jump from standstill becomes a spinjump
; -----------
dw !TJump,!TUp,   $0055
dw !TJump,!TAimU, $0057
dw !TJump,!TAimD, $0059
dw !TJump,!TNone, $004B
dw !TDown,$0030,  $00F1
dw !TDown,!TAimU, $00F3
dw !TDown,!TAimD, $00F5
dw !TDown,!TNone, $0035
dw !TNone,$0260,  $0078
dw !TNone,$0250,  $0076
dw !TNone,$0230,  $0025
dw !TNone,$0030,  $0003
dw !TNone,$0110,  $000F
dw !TNone,$0120,  $0011
dw !TNone,$0900,  $000F
dw !TNone,$0500,  $0011
dw !TNone,$0240,  $004A
dw !TNone,!TLeft, $0025
dw !TNone,!TUp,   $0003
dw !TNone,!TAimU, $0005
dw !TNone,!TAimD, $0007
dw !TNone,!TRight,$0009
dw !TEnd
}

;facing left {
T02:									;Facing left, normal
; --- new ---
	!Quick_morph_left
; -----------
T04:									;Facing left, aiming up
T06:									;Facing left, aiming upleft
T08:									;Facing left, aiming Downleft
TA5:									;Landing from normal jump, facing left
TA7:									;Landing from spin jump, facing left
TE1:									;Landing from normal jump, facing left and aiming up
TE3:									;Landing from normal jump, facing left and aiming upleft
TE5:									;Landing from normal jump, facing left and aiming Downleft
TE7:									;Landing from normal jump, facing left, firing
; --- new ---
	!Upspin_left						;when holding run, a normal jump from standstill becomes a spinjump
; -----------
dw !TJump,!TUp,$0056
dw !TJump,!TAimU,$0058
dw !TJump,!TAimD,$005A
dw !TJump,!TNone,$004C
dw !TDown,$0030,$00F2
dw !TDown,!TAimU,$00F4
dw !TDown,!TAimD,$00F6
dw !TDown,!TNone,$0036
dw !TNone,$0160,$0077
dw !TNone,$0150,$0075
dw !TNone,$0140,$0049
dw !TNone,!TRight,$0026
dw !TNone,$0030,$0004
dw !TNone,$0210,!TAimU
dw !TNone,$0220,$0012
dw !TNone,$0A00,!TAimU
dw !TNone,$0600,$0012
dw !TNone,!TUp,$0004
dw !TNone,!TAimU,$0006
dw !TNone,!TAimD,$0008
dw !TNone,!TLeft,$000A
dw !TEnd
}

;moving right {
T09:									;Moving right, not aiming
T0D:									;Moving right, aiming straight up (unused?)
T0F:									;Moving right, aiming upright
T11:									;Moving right, aiming Downright
; --- new ---
	!Quick_morph_right
	!Quick_morph_altr
; -----------
dw !TDown,!TNone, $0035
dw !TJump,!TNone, $0019
dw !TNone,$0110,  $000F
dw !TNone,$0120,  $0011
dw !TNone,$0900,  $000F
dw !TNone,$0500,  $0011
dw !TNone,$0140,  $000B
dw !TNone,!TRight,$0009
dw !TNone,!TLeft, $0025
dw !TNone,!TUp,   $0003
dw !TNone,!TAimU, $0005
dw !TNone,!TAimD, $0007
dw !TEnd
}

;moving left {
T0A:									;Moving left, not aiming
T0E:									;Moving left, aiming straight up (unused?)
T10:									;Moving left, aiming upleft
T12:									;Moving left, aiming Downleft
; --- new ---
	!Quick_morph_left
	!Quick_morph_altl
; -----------
dw !TDown,!TNone, $0036
dw !TJump,!TNone, $001A
dw !TNone,$0210,  !TAimU
dw !TNone,$0220,  $0012
dw !TNone,$0A00,  !TAimU
dw !TNone,$0600,  $0012
dw !TNone,$0240,  $000C
dw !TNone,!TLeft, $000A
dw !TNone,!TRight,$0026
dw !TNone,!TUp,   $0004
dw !TNone,!TAimU, $0006
dw !TNone,!TAimD, $0008
dw !TEnd
}

;moving with gun extended {
T0B:									;Moving right, gun extended forward (not aiming)
dw !TDown,!TNone,$0035
dw !TJump,!TNone,$0019
dw !TNone,$0110,$000F
dw !TNone,$0120,$0011
dw !TNone,$0900,$000F
dw !TNone,$0500,$0011
dw !TNone,!TRight,$000B
dw !TNone,!TLeft,$0025
dw !TNone,!TUp,$0003
dw !TNone,!TAimU,$0005
dw !TNone,!TAimD,$0007
dw !TEnd

T0C:									;Moving left, gun extended forward (not aiming)
dw !TDown,!TNone,$0036
dw !TJump,!TNone,$001A
dw !TNone,$0210,!TAimU
dw !TNone,$0220,$0012
dw !TNone,$0A00,!TAimU
dw !TNone,$0600,$0012
dw !TNone,!TLeft,$000C
dw !TNone,!TRight,$0026
dw !TNone,!TUp,$0004
dw !TNone,!TAimU,$0006
dw !TNone,!TAimD,$0008
dw !TEnd

T13:									;Normal jump facing right, gun extended, not aiming or moving
; --- new ---
	!Quick_morph_right
; -----------
; --- new ---
	!Respin_right
; -----------
dw !TNone,$0900,  $0069
dw !TNone,$0500,  $006B
dw !TNone,$0190,  $0069
dw !TNone,$01A0,  $006B
dw !TNone,!TLeft, $002F
dw !TNone,!TUp,   $0015
dw !TNone,!TDown, $0017
dw !TNone,!TAimU, $0069
dw !TNone,!TAimD, $006B
dw !TNone,!TRight,$0051
dw !TNone,!TFire, $0013
dw !TEnd

T14:									;Normal jump facing left, gun extended, not aiming or moving
; --- new ---
	!Quick_morph_left
; -----------
; --- new ---
	!Respin_left
; -----------
dw !TNone,$0A00,  $006A
dw !TNone,$0600,  $006C
dw !TNone,$0290,  $006A
dw !TNone,$02A0,  $006C
dw !TNone,!TRight,$0030
dw !TNone,!TUp,   $0016
dw !TNone,!TDown, $0018
dw !TNone,!TAimU, $006A
dw !TNone,!TAimD, $006C
dw !TNone,!TLeft, $0052
dw !TNone,!TFire, $0014
dw !TEnd
}

;normal jump facing right {
T4D:									;Normal jump facing right, gun not extended, not aiming, not moving
T51:									;Normal jump facing right, moving forward (gun extended)
; --- new ---
	!Respin_right
; -----------
T69:									;Normal jump facing right, aiming upright. Moving optional
T6B:									;Normal jump facing right, aiming Downright. Moving optional
T15:									;Normal jump facing right, aiming up
; --- new ---
	!Quick_morph_right
	!Quick_morph_altr
; -----------
dw !TNone,$0900,  $0069
dw !TNone,$0500,  $006B
dw !TNone,$0190,  $0069
dw !TNone,$01A0,  $006B
dw !TNone,!TLeft, $002F
dw !TNone,!TUp,   $0015
dw !TNone,!TDown, $0017
dw !TNone,!TAimU, $0069
dw !TNone,!TAimD, $006B
dw !TNone,!TRight,$0051
dw !TNone,$00C0,  $0013
dw !TNone,!TJump, $004D
dw !TNone,!TFire, $0013
dw !TEnd

T17:									;Normal jump facing right, aiming Down
; --- new ---
	!Quick_morph_right
	!Respin_right
; -----------
dw !TDown,!TNone, $0037
dw !TNone,$0900,  $0069
dw !TNone,$0500,  $006B
dw !TNone,$0190,  $0069
dw !TNone,$01A0,  $006B
dw !TNone,!TLeft, $002F
dw !TNone,!TUp,   $0015
dw !TNone,!TDown, $0017
dw !TNone,!TAimU, $0069
dw !TNone,!TAimD, $006B
dw !TNone,!TRight,$0051
dw !TNone,$00C0,  $0013
dw !TNone,!TJump, $0017
dw !TNone,!TFire, $0013

dw !TEnd

}

;normal jump facing left {
T4E:									;Normal jump facing left, gun not extended, not aiming, not moving
T52:									;Normal jump facing left, moving forward (gun extended)
; --- new ---
	!Respin_left
; -----------
T6A:									;Normal jump facing left, aiming upleft. Moving optional
T6C:									;Normal jump facing left, aiming Downleft. Moving optional
T16:									;Normal jump facing left, aiming up
; --- new ---
	!Quick_morph_left
	!Quick_morph_altl
; -----------
dw !TNone,$0A00,  $006A
dw !TNone,$0600,  $006C
dw !TNone,$0290,  $006A
dw !TNone,$02A0,  $006C
dw !TNone,!TRight,$0030
dw !TNone,!TUp,   $0016
dw !TNone,!TDown, $0018
dw !TNone,!TAimU, $006A
dw !TNone,!TAimD, $006C
dw !TNone,!TLeft, $0052
dw !TNone,$00C0,  $0014
dw !TNone,!TJump, $004E
dw !TNone,!TFire, $0014
dw !TEnd

T18:									;Normal jump facing left, aiming Down
; --- new ---
	!Quick_morph_left
	!Respin_left
; -----------
dw !TDown,!TNone, $0038
dw !TNone,$0A00,  $006A
dw !TNone,$0600,  $006C
dw !TNone,$0290,  $006A
dw !TNone,$02A0,  $006C
dw !TNone,!TRight,$0030
dw !TNone,!TUp,   $0016
dw !TNone,!TDown, $0018
dw !TNone,!TAimU, $006A
dw !TNone,!TAimD, $006C
dw !TNone,!TLeft, $0052
dw !TNone,$00C0,  $0014
dw !TNone,!TJump, $0018
dw !TNone,!TFire, $0014
dw !TEnd

}

;spin jump {
T19:									;Spin jump right
; --- new ---
	!Quick_morph_right
; -----------
dw !TFire,!TNone, $0013
dw !TNone,$0840,  $0015
dw !TNone,$0440,  $0017
dw !TNone,$0050,  $0069
dw !TNone,$0060,  $006B
dw !TNone,$0180,  $0019
dw !TNone,!TUp,   $0015
dw !TNone,!TAimU, $0069
dw !TNone,!TAimD, $006B
dw !TNone,!TDown, $0017
dw !TNone,!TRight,$0019
dw !TNone,!TLeft, $001A
dw !TEnd

T1A:									;Spin jump left
; --- new ---
	!Quick_morph_left
; -----------
dw !TFire,!TNone, $0014
dw !TNone,$0840,  $0016
dw !TNone,$0440,  $0018
dw !TNone,$0050,  $006A
dw !TNone,$0060,  $006C
dw !TNone,$0280,  $001A
dw !TNone,!TUp,   $0016
dw !TNone,!TAimU, $006A
dw !TNone,!TAimD, $006C
dw !TNone,!TDown, $0018
dw !TNone,!TLeft, $001A
dw !TNone,!TRight,$0019
dw !TEnd
}

;space jump {
T1B:									;Space jump right
; --- new ---
	!Quick_morph_right
; -----------
dw !TFire,!TNone, $0013
dw !TNone,$0840,  $0015
dw !TNone,$0440,  $0017
dw !TNone,$0050,  $0069
dw !TNone,$0060,  $006B
dw !TNone,$0180,  $001B
dw !TNone,!TUp,   $0015
dw !TNone,!TAimU, $0069
dw !TNone,!TAimD, $006B
dw !TNone,!TDown, $0017
dw !TNone,!TRight,$001B
dw !TNone,!TLeft, $001C
dw !TEnd

T1C:									;Space jump left
; --- new ---
	!Quick_morph_left
; -----------
dw !TFire,!TNone, $0014
dw !TNone,$0840,  $0016
dw !TNone,$0440,  $0018
dw !TNone,$0050,  $006A
dw !TNone,$0060,  $006C
dw !TNone,$0280,  $001C
dw !TNone,!TUp,   $0016
dw !TNone,!TAimU, $006A
dw !TNone,!TAimD, $006C
dw !TNone,!TDown, $0018
dw !TNone,!TLeft, $001C
dw !TNone,!TRight,$001B
dw !TEnd
}

;morphball {
T1D:									;Facing right as morphball, no springball
T1E:									;Moving right as a morphball on ground without springball
; --- new ---
	!Ballspin_right						;holding run + jump in morph ball without spring will make samus perfrom upspin
; -----------
dw !TUp,!TNone,$003D
dw !TJump,!TNone,$003D

T1F:									;Moving left as a morphball on ground without springball
T41:									;Staying still with morphball, facing left, no springball
; --- new ---
	!Ballspin_left						;holding run + jump in morph ball without spring will make samus perfrom upspin
; -----------
dw !TUp,!TNone,$003E
dw !TJump,!TNone,$003E
dw !TNone,!TRight,$001E
dw !TNone,!TLeft,$001F
dw !TEnd
}

;unused poses {

;morphball {
TDD:									;Morphball transition to standing, facing right? Unused?
TDE:									;Morphball transition to standing, facing left? Unused?
TC5:									;Morph ball, facing right. Unused? (Grabbed by Draygon movement)
TC6:									;Morph ball, facing left. Unused? (Grabbed by Draygon movement)
TDB:									;Standing transition to morphball, facing right? Unused?
TDC:									;Standing transition to morphball, facing left? Unused?
}

;standing {
T47:									;Standing, facing right. Unused?
T48:									;Standing, facing left. Unused?
T63:									;Facing left on grapple blocks, ready to jump. Unused?
T64:									;Facing right on grapple blocks, ready to jump. Unused?
TA8:									;Just standing, facing right. Unused? (Grapple movement)
TA9:									;Just standing, facing left. Unused? (Grapple movement)
TAA:									;Just standing, facing right aiming Downright. Unused? (Grapple movement)
TAB:									;Just standing, facing left aiming Downleft. Unused? (Grapple movement)
}

;jumping {
TAC:									;jumping, facing right, gun extended. Unused? (Grapple movement)
TAD:									;jumping, facing left, gun extended. Unused? (Grapple movement)
TAE:									;jumping, facing right, aiming Down. Unused? (Grapple movement)
TAF:									;jumping, facing left, aiming Down. Unused? (Grapple movement)
TB0:									;jumping, facing right, aiming Downright. Unused? (Grapple movement)
TB1:									;jumping, facing left, aiming Downleft. Unused? (Grapple movement)
T20:									;Spinjump right. Unused?
T21:									;Spinjump right. Unused?
T22:									;Spinjump right. Unused?
T23:									;Spinjump right. Unused?
T24:									;Spinjump right. Unused?
T33:									;Spinjump right. Unused?
T34:									;Spinjump right. Unused?
T42:									;Spinjump right. Unused?
T65:									;Glitchy jump, facing left. Used by unused grapple jump?
T66:									;Glitchy jump, facing right. Used by unused grapple jump?
}

;crouching {
TB4:									;Crouching, facing right. Unused? (Grapple movement)
TB5:									;Crouching, facing left. Unused? (Grapple movement)
TB6:									;Crouching, facing right, aiming Downright. Unused? (Grapple movement)
TB7:									;Crouching, facing left, aiming Downleft. Unused? (Grapple movement)
}

;maybe/probably unused	{
T5B:									;Something for grapple (wall jump?), probably unused
T5C:									;Something for grapple (wall jump?), probably unused
T39:									;Midair morphing into ball, facing right? May be unused
T3A:									;Midair morphing into ball, facing left? May be unused
T3F:									;Some transition with morphball, facing right. Maybe unused
T40:									;Some transition with morphball, facing left. Maybe unused
T5D:									;Broken grapple? Facing clockwise, maybe unused
T5E:									;Broken grapple? Facing clockwise, maybe unused
T5F:									;Broken grapple? Facing clockwise, maybe unused
T60:									;Better broken grapple. Facing clockwise, maybe unused
T61:									;Nearly normal grapple. Facing clockwise, maybe unused
T62:									;Nearly normal grapple. Facing counterclockwise, maybe unused
}

}

;transitions and general poses with no movement {
T2F:									;starting with normal jump facing right, turning left
T30:									;starting with normal jump facing left, turning right
T35:									;Crouch transition, facing right
T36:									;Crouch transition, facing left
T37:									;Morphing into ball, facing right. Ground and mid-air
T38:									;Morphing into ball, facing left. Ground and mid-air
T3B:									;Standing from crouching, facing right
T3C:									;Standing from crouching, facing left
T3D:									;Demorph while facing right. Mid-air and on ground
T3E:									;Demorph while facing left. Mid-air and on ground
T43:									;starting from crouching right, turning left
T44:									;starting from crouching left, turning right
T4B:									;Normal jump transition from ground(standing or crouching), facing right
T4C:									;Normal jump transition from ground(standing or crouching), facing left
T55:									;Normal jump transition from ground, facing right and aiming up
T56:									;Normal jump transition from ground, facing left and aiming up
T57:									;Normal jump transition from ground, facing right and aiming upright
T58:									;Normal jump transition from ground, facing left and aiming upleft
T59:									;Normal jump transition from ground, facing right and aiming Downright
T5A:									;Normal jump transition from ground, facing left and aiming Downleft
T87:									;Turning from right to left while falling
T88:									;Turning from left to right while falling
T8F:									;Turning around from right to left while aiming straight up in midair
T90:									;Turning around from left to right while aiming straight up in midair
T91:									;Turning around from right to left while aiming Down or diagonal Down in midair
T92:									;Turning around from left to right while aiming Down or diagonal Down in midair
T93:									;Turning around from right to left while aiming straight up while falling
T94:									;Turning around from left to right while aiming straight up while falling
T95:									;Turning around from right to left while aiming Down or diagonal Down while falling
T96:									;Turning around from left to right while aiming Down or diagonal Down while falling
T97:									;Turning around from right to left while aiming straight up while crouching
T98:									;Turning around from left to right while aiming straight up while crouching
T99:									;Turning around from right to left while aiming diagonal Down while crouching
T9A:									;Turning around from left to right while aiming diagonal Down while crouching
T9C:									;Turning around from right to left while aiming diagonal up while standing
T9D:									;Turning around from left to right while aiming diagonal up while standing
T9E:									;Turning around from right to left while aiming diagonal up in midair
T9F:									;Turning around from left to right while aiming diagonal up in midair
TA0:									;Turning around from right to left while aiming diagonal up while falling
TA1:									;Turning around from left to right while aiming diagonal up while falling
TA2:									;Turn around from right to left while aiming diagonal up while crouching
TA3:									;Turn around from left to right while aiming diagonal up while crouching
TB2:									;Grapple, facing clockwise
TB3:									;Grapple, facing counterclockwise
TB8:									;Grapple, attached to a wall on right, facing left
TB9:									;Grapple, attached to a wall on left, facing right
TC9:									;Horizontal super jump, right
TCA:									;Horizontal super jump, left
TCB:									;Vertical super jump, facing right
TCC:									;Vertical super jump, facing left
TCD:									;Diagonal super jump, right
TCE:									;Diagonal super jump, left
TD3:									;Crystal flash, facing right
TD4:									;Crystal flash, facing left
TD5:									;X-raying right, standing
TD6:									;X-raying left, standing
TD7:									;Crystal flash ending, facing right
TD8:									;Crystal flash ending, facing left
TD9:									;X-raying right, crouching
TDA:									;X-raying left, crouching
TE8:									;Samus exhausted(Metroid drain, MB attack), facing right
TE9:									;Samus exhausted(Metroid drain, MB attack), facing left
TEA:									;Samus exhausted, looking up to watch Metroid attack MB, facing right
TEB:									;Samus exhausted, looking up to watch Metroid attack MB, facing left
TF1:									;Crouch transition, facing right and aiming up
TF2:									;Crouch transition, facing left and aiming up
TF3:									;Crouch transition, facing right and aiming upright
TF4:									;Crouch transition, facing left and aiming upleft
TF5:									;Crouch transition, facing right and aiming Downright
TF6:									;Crouch transition, facing left and aiming Downleft
TF7:									;Crouching to standing, facing right and aiming up
TF8:									;Crouching to standing, facing left and aiming up
TF9:									;Crouching to standing, facing right and aiming upright
TFA:									;Crouching to standing, facing left and aiming upleft
TFB:									;Crouching to standing, facing right and aiming Downright
TFC:									;Crouching to standing, facing left and aiming Downlef
dw !TEnd
}

;turning {
T25:									;starting standing right, turning left
dw !TNone,$0280,$001A					;auto jump if holding (technically pressing) jump and the opposite direction
dw !TJump,!TNone,$004C
dw !TNone,!TLeft,$0025
dw !TEnd

T26:									;starting standing left, turning right
dw !TNone,$0180,$0019					;auto jump if holding (technically pressing) jump and the opposite direction
dw !TJump,!TNone,$004B
dw !TNone,!TRight,$0026
dw !TEnd
}

;crouching and related transitions {
T27:									;Crouching, facing right
T71:									;Standing to crouching, facing right and aiming upright
T73:									;Standing to crouching, facing right and aiming Downright
T85:									;Crouching, facing right aiming up
dw !TUp,  $0030,  $00F7
dw !TUp,  !TAimU, $00F9
dw !TUp,  !TAimD, $00FB
dw !TUp,  !TNone, $003B
dw !TLeft,!TNone, $0043
; --- new ---
	!Backflip_right						;lets you enter a damage boost from crouch for backflip
; -----------
dw !TDown,!TNone, $0037
dw !TJump,!TNone, $004B
dw !TNone,$0030,  $0085
dw !TNone,!TRight,$0001
dw !TNone,!TAimU, $0071
dw !TNone,!TAimD, $0073
dw !TEnd

T28:									;Crouching, facing left
T72:									;Standing to crouching, facing left and aiming upleft
T74:									;Standing to crouching, facing left and aiming Downleft
T86:									;Crouching, facing left aiming up
dw !TUp,   $0030,  $00F8
dw !TUp,   !TAimU, $00FA
dw !TUp,   !TAimD, $00FC
dw !TUp,   !TNone, $003C
dw !TRight,!TNone, $0044
dw !TDown, !TNone, $0038
; --- new ---
	!Backflip_left						;lets you enter a damage boost from crouch for backflip
; -----------
dw !TJump, !TNone, $004C
dw !TNone, $0030,  $0086
dw !TNone, !TLeft, $0002
dw !TNone, !TAimU, $0072
dw !TNone, !TAimD, $0074
dw !TEnd
}

;falling {
T29:									;Falling facing right, normal pose
; --- new ---
	!Respin_right
; -----------
T2B:									;Falling facing right, aiming up
T6D:									;Falling facing right, aiming upright
T6F:									;Falling facing right, aiming Downright
; --- new/modified ---
	!Quick_morph_right					;holding item canel + down enters quickmorph
	!Quick_morph_altr
; --------------------
dw !TNone,$0900, $006D
dw !TNone,$0500, $006F
dw !TNone,!TLeft,$0087
dw !TNone,!TUp,  $002B
dw !TNone,!TDown,$002D
dw !TNone,!TAimU,$006D
dw !TNone,!TAimD,$006F
dw !TNone,!TFire,$0067
dw !TNone,$8100, $0029
dw !TEnd

T2A:									;Falling facing left, normal pose
; --- new ---
	!Respin_left
; -----------
T2C:									;Falling facing left, aiming up
T6E:									;Falling facing left, aiming upleft
T70:									;Falling facing left, aiming Downleft
; --- new/modified ---
	!Quick_morph_left					;holding item canel + down enters quickmorph
	!Quick_morph_altl
; --------------------
dw !TNone,$0A00,  $006E
dw !TNone,$0600,  $0070
dw !TNone,!TRight,$0088
dw !TNone,!TUp,   $002C
dw !TNone,!TDown, $002E
dw !TNone,!TAimU, $006E
dw !TNone,!TAimD, $0070
dw !TNone,!TFire, $0068
dw !TNone,$8200,  $002A
dw !TEnd

T2D:									;Falling facing right, aiming Down
; --- new ---
	!Respin_right
; -----------
dw !TDown,!TNone,$0037
dw !TNone,$0900,$006D
dw !TNone,$0500,$006F
dw !TNone,!TUp,$002B
dw !TNone,!TDown,$002D
dw !TNone,!TLeft,$0087
dw !TNone,!TAimU,$006D
dw !TNone,!TAimD,$006F
dw !TNone,!TFire,$0067
dw !TNone,!TRight,$0029
dw !TEnd

T2E:									;Falling facing left, aiming Down
; --- new ---
	!Respin_left
; -----------
dw !TDown,!TNone,$0038
dw !TNone,$0A00,$006E
dw !TNone,$0600,$0070
dw !TNone,!TUp,$002C
dw !TNone,!TDown,$002E
dw !TNone,!TRight,$0088
dw !TNone,!TAimU,$006E
dw !TNone,!TAimD,$0070
dw !TNone,!TFire,$0068
dw !TNone,!TLeft,$002A
dw !TEnd
}

;midair morphball {
T31:									;Midair morphball facing right without springball
dw !TUp,!TNone,$003D
dw !TJump,!TNone,$003D

T32:									;Midair morphball facing left without springball
dw !TUp,!TNone,$003E
dw !TJump,!TNone,$003E
dw !TNone,!TRight,$0031
dw !TNone,!TLeft,$0032
dw !TEnd
}

;unused running {
T45:									;running, facing right, shooting left. Unused? (Fast moonwalk)
dw !TNone,$0240,$0045
dw !TNone,!TRight,$0009
dw !TNone,!TLeft,$0025
dw !TEnd

T46:									;running, facing left, shooting right. Unused? (Fast moonwalk)
dw !TNone,$0140,$0046
dw !TNone,!TLeft,$000A
dw !TNone,!TRight,$0026
dw !TEnd
}

;moonwalk {
T49:									;Moonwalk, facing left
T75:									;Moonwalk, facing left aiming upleft
T77:									;Moonwalk, facing left aiming Downleft
dw !TDown,!TNone,$0036
dw !TJump,!TNone,$00C0
dw !TNone,$0160,$0077
dw !TNone,$0150,$0075
dw !TNone,$0140,$0049
dw !TNone,!TLeft,$000A
dw !TNone,!TRight,$0026
dw !TEnd

T4A:									;Moonwalk, facing right
T76:									;Moonwalk, facing right aiming upright
T78:									;Moonwalk, facing right aiming Downright
dw !TDown,!TNone,$0035
dw !TJump,!TNone,$00BF
dw !TNone,$0250,$0076
dw !TNone,$0260,$0078
dw !TNone,$0240,$004A
dw !TNone,!TRight,$0009
dw !TNone,!TLeft,$0025
dw !TEnd
}

;hurt {
T4F:									;Hurt roll back, moving right/facing left
dw !TNone,$0280,$0052
%t_2(!TNone, !TRight, !TJump, $00, $4F)
dw !TNone,!TJump,$004E
dw !TEnd

T50:									;Hurt roll back, moving left/facing right
dw !TNone,$0280,$0050
%t_2(!TNone, !TLeft, !TJump, $00, $51)
dw !TNone,!TJump,$004D
; ----------------
dw !TEnd

T53:									;Hurt, facing right
dw !TNone,$0280,$0050
dw !TEnd

T54:									;Hurt, facing left
dw !TNone,$0180,$004F
dw !TEnd
}

;firing while falling {
T67:									;Facing right, falling, fired a shot
; --- new ---
	!Quick_morph_right
; -----------
; --- new ---
	!Respin_right
; -----------
dw !TNone,$0900,  $006D
dw !TNone,$0500,  $006F
dw !TNone,!TUp,   $002B
dw !TNone,!TDown, $002D
dw !TNone,!TLeft, $0087
dw !TNone,!TAimU, $006D
dw !TNone,!TAimD, $006F
dw !TNone,!TFire, $0067
dw !TNone,!TRight,$0067
dw !TEnd

T68:									;Facing left, falling, fired a shot
; --- new ---
	!Quick_morph_left
; -----------
; --- new ---
	!Respin_left
; -----------
dw !TNone,$0A00,  $006E
dw !TNone,$0600,  $0070
dw !TNone,!TUp,   $002C
dw !TNone,!TDown, $002E
dw !TNone,!TRight,$0088
dw !TNone,!TAimU, $006E
dw !TNone,!TAimD, $0070
dw !TNone,!TFire, $0068
dw !TNone,!TLeft, $0068
dw !TEnd
}

;springball {
T79:									;Spring ball on ground, facing right
T7B:									;Spring ball on ground, moving right
dw !TUp,!TNone,$003D
dw !TJump,!TNone,$007F

T7A:									;Spring ball on ground, facing left
T7C:									;Spring ball on ground, moving left
dw !TUp,!TNone,$003E
dw !TJump,!TNone,!TJump
dw !TNone,!TRight,$007B
dw !TNone,!TLeft,$007C
dw !TEnd

T7D:									;Spring ball falling, facing/moving right
dw !TUp,!TNone,$003D

T7E:									;Spring ball falling, facing/moving left
dw !TUp,!TNone,$003E
dw !TNone,!TRight,$007D
dw !TNone,!TLeft,$007E
dw !TEnd

T7F:									;Spring ball jump in air, facing/moving right
dw !TUp,!TNone,$003D

T80:									;Spring ball jump in air, facing/moving left
dw !TUp,!TNone,$003E
dw !TNone,!TRight,$007F
dw !TNone,!TLeft,!TJump
dw !TEnd
}

;screw attack {
T81:									;Screw attack right
dw !TFire,!TNone,$0013
dw !TNone,$0840,$0015
dw !TNone,$0440,$0017
dw !TNone,$0050,$0069
dw !TNone,$0060,$006B
dw !TNone,$0180,$0081
dw !TNone,!TUp,$0015
dw !TNone,!TAimU,$0069
dw !TNone,!TAimD,$006B
dw !TNone,!TDown,$0017
dw !TNone,!TRight,$0081
dw !TNone,!TLeft,$0082
dw !TEnd

T82:									;Screw attack left
dw !TFire,!TNone,$0014
dw !TNone,$0840,$0016
dw !TNone,$0440,$0018
dw !TNone,$0050,$006A
dw !TNone,$0060,$006C
dw !TNone,$0280,$0082
dw !TNone,!TUp,$0016
dw !TNone,!TAimU,$006A
dw !TNone,!TAimD,$006C
dw !TNone,!TDown,$0018
dw !TNone,!TLeft,$0082
dw !TNone,!TRight,$0081
dw !TEnd
}

;walljump {
T83:									;Walljump right
dw !TDown,!TNone,$0037
dw !TNone,!TLeft,$001A
dw !TNone,!TAimU,$0069
dw !TNone,!TAimD,$006B
dw !TFire,!TNone,$0013					;this lets you hold charge while walljumping, but still fire by pressing fire
dw !TNone,!TJump,$0083
dw !TEnd

T84:									;Walljump left
dw !TDown,!TNone,$0038
dw !TNone,!TRight,$0019
dw !TNone,!TAimU,$006A
dw !TNone,!TAimD,$006C
dw !TFire,!TNone,$0014					;this lets you hold charge while walljumping, but still fire by pressing fire
dw !TNone,!TJump,$0084
dw !TEnd
}

;ran into a wall {
T89:									;Ran into a wall on right (facing right)
TCF:									;Samus ran right into a wall, is still holding right and is now aiming diagonal up
TD1:									;Samus ran right into a wall, is still holding right and is now aiming diagonal Down
; --- new ---
	!Quick_morph_right
	!Upspin_right
; -----------
dw !TJump,!TNone, $004B
dw !TNone,$0900,  $000F
dw !TNone,$0500,  $0011
dw !TDown,!TNone, $0035
dw !TNone,$0220,  $0078
dw !TNone,$0210,  $0076
dw !TNone,!TUp,   $0003
dw !TNone,!TAimU, $0005
dw !TNone,!TAimD, $0007
dw !TNone,!TLeft, $0025
dw !TNone,!TRight,$0009
dw !TEnd

T8A:									;Ran into a wall on left (facing left)
TD0:									;Samus ran left into a wall, is still holding left and is now aiming diagonal up
TD2:									;Samus ran left into a wall, is still holding left and is now aiming diagonal Down
; --- new ---
	!Quick_morph_left
	!Upspin_left
; -----------
dw !TJump,!TNone, $004C
dw !TNone,$0A00,  !TAimU
dw !TNone,$0600,  $0012
dw !TDown,!TNone, $0036
dw !TNone,$0120,  $0077
dw !TNone,$0110,  $0075
dw !TNone,!TUp,   $0004
dw !TNone,!TAimU, $0006
dw !TNone,!TAimD, $0008
dw !TNone,!TRight,$0026
dw !TNone,!TLeft, $000A
dw !TEnd
}

;turning {
T8B:									;Turning around from right to left while aiming straight up while standing
T8D:									;Turn around from right to left while aiming diagonal Down while standing
TBF:									;jump/Turn right to left while moonwalking.
TC1:									;jump/Turn right to left while moonwalking and aiming diagonal up.
TC3:									;jump/Turn right to left while moonwalking and aiming diagonal Down.
dw !TJump,!TLeft,$001A
dw !TJump,!TNone,$004C
dw !TEnd

T8C:									;Turning around from left to right while aiming straight up while standing
T8E:									;Turn around from left to right while aiming diagonal Down while standing
TC0:									;jump/Turn left to right while moonwalking.
TC2:									;jump/Turn left to right while moonwalking and aiming diagonal up.
TC4:									;jump/Turn left to right while moonwalking and aiming diagonal Down.
dw !TJump,!TRight,$0019
dw !TJump,!TNone,$004B
dw !TEnd
}

;grabbed by draygon {
TBA:									;Grabbed by Draygon, facing left, not moving
TBB:									;Grabbed by Draygon, facing left aiming upleft, not moving
TBC:									;Grabbed by Draygon, facing left and firing
TBD:									;Grabbed by Draygon, facing left aiming Downleft, not moving
TBE:									;Grabbed by Draygon, facing left, moving
dw !TNone,$0A40,$00BB
dw !TNone,$0640,$00BD
dw !TNone,$0240,$00BC
dw !TNone,!TAimU,$00BB
dw !TNone,!TAimD,$00BD
dw !TNone,!TFire,$00BC
dw !TNone,!TLeft,$00BE
dw !TNone,!TRight,$00BE
dw !TNone,!TUp,$00BE
dw !TNone,!TDown,$00BE
dw !TEnd

TEC:									;Grabbed by Draygon, facing right. Not moving
TED:									;Grabbed by Draygon, facing right aiming upright. Not moving
TEE:									;Grabbed by Draygon, facing right and firing.
TEF:									;Grabbed by Draygon, facing right aiming Downright. Not moving
TF0:									;Grabbed by Draygon, facing right. Moving
dw !TNone,$0940,$00ED
dw !TNone,$0540,$00EF
dw !TNone,$0140,$00EE
dw !TNone,!TAimU,$00ED
dw !TNone,!TAimD,$00EF
dw !TNone,!TFire,$00EE
dw !TNone,!TLeft,$00F0
dw !TNone,!TRight,$00F0
dw !TNone,!TUp,$00F0
dw !TNone,!TDown,$00F0
dw !TEnd

TDF:									;Samus is facing left as a morphball. Unused? (Grabbed by Draygon movement)
dw !TUp,!TNone,$00DE
dw !TEnd

}

;shinespark {
TC7:									;Super jump windup, facing right
dw !TNone,$0880,$00CB					;up+jump -> vertical spark
dw !TNone,$0010,$00CD					;aimup	 -> diagonal spark
dw !TNone,$0100,$00C9					;right 	 -> horizontal spark
dw !TEnd

TC8:									;Super jump windup, facing left
dw !TNone,$0880,$00CC
dw !TNone,$0010,$00CE
dw !TNone,$0200,$00CA
dw !TEnd
}

}

print "End of Pose Transition Table: ", pc



















