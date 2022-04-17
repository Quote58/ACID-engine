lorom

;this is a file of hex tweaks that are applied to Project base (and formatted for a program to easily read...)

org $91EFFA : NOP #6	;mid air un-morphing will not slow your fall, at least out of water/lava/acid
org $91ED19 : NOP #6	;mid air unmorphing after bouncing won't reset fall speed

org $84D50B : dw $0010					;Author: Quote | Title: Maridia Tube Timer | normally dw $0060, determines how long to wait after starting the earthquake/glass breaking before giving samus control and setting event, etc. in Maridia Tube

org $A9C586 : LDY #$FFFC				;Author: Grime? | Title: MB rainbow beam extra damage based on suit type | normally LDY #$FFFE

org $82C7FB : rep 8 : dw $0000			;Author: Quote | Title: Remove map icons | normally dw C84D,C8B7,C91D,C98B,C9ED,CA4F,0000,0000

org $829297 : DEC $B1					;Author: DSO? | Title: Faster map scrolling (left) | normally the game SBC $92E4,x and stores back to the layer 1 horizontal scroll, instead it just decs every frame the input is read
	
org $8292C6 : INC $B1					;Author: DSO? | Title: Faster map scrolling (right) | normally the game ADC $92E4,x and stores back to the layer 1 horizontal scroll, instead it just incs every frame the input is read

org $8292D3 : DEC $B3					;Author: DSO? | Title: Faster map scrolling (up) | normally the game SBC $92E4,x and stores back to the layer 1 horizontal scroll, instead it just decs every frame the input is read

org $8292E0 : INC $B3					;Author: DSO? | Title: Faster map scrolling (down) | normally the game ADC $92E4,x and stores back to the layer 1 horizontal scroll, instead it just incs every frame the input is read

;org $909005 : AND #$0000				;Author: Unknown | Title: walljumps no longer push samus away from the wall | the game normally checks if you're in the walljump movement type to determine whether to push you away from the wall, this just tells it to never push you

org $91F66F : NOP #4					;Author: Unknown | Title: No longer lose bluesuit when turning during spinjump | originally JSL $91DE53, which cleans up the blue suit/echoes/speed counter/etc. when samus is stopped while boosting

org $90D036 : LDA #$003A				;Author: Scyzer | Title: Extra time for choosing shinespark direction | originally LDA #$001E : STA $0AA2 (spark delay), set this higher to for more time (max of 3A)

org $9BCB97 : LDA #$0019 : org $9BCB9F : LDA #$001A ;Author: Scyzer | Title: Grapple now exits into spinjump | originally LDA #$0051 STA $0A2C

org $8B8674 : LDA #$20 : STA $74 : LDA #$40 : STA $75 ;Author: Unknown | Title: Remove blue filter from title screen | sets intensity of red and green fixed colour data to 0

org $90992B : NOP #3					;Author: Unknown | Title: Horizontal jumps no longer lose height with speed booster on | normally adds !Samus_Hspeed_sub to !Samus_Vspeed

org $90EC1A : BRA $01					;Author: Unknown | Title: Removes blinking during elevator | checks $05B6 (current frame). (If odd, draw samus) -> always draw samus

;org $91B384 : db $01,$01,$01,$01,$01,$01,$01,$01,$01 ;Author: Unknown (Grime?) | Title: Spin jump animation speed increase | animation timing table, each value has been increased

org $8B9C97 : JSL $888293				;Author: DChronos | Title: Remove title screen haze | normally $888288 which activates HDMA, $888293 deactivates it instead

org $81924C : JSL $888293				;Author: DChronos | Title: Remove game over screen haze | normally $888288 which activates HDMA, $888293 deactivates it instead

org $88DDC7 : RTL						;Author: Quote58 | Title: Remove ceres haze from game entirely | literally just removes the call to it's hdma setup routine

org $909E99 : db $00,$08 				;Author: Black Falcon | Title: Remove height limit for Space Jump (in air) | vertical speed limiter for spacejump in air

org $909E9D : db $00,$08 				;Author: Black Falcon | Title: Remove height limit for Space Jump (in liquid) | vertical speed limiter for spacejump in liquid

org $90D396 : BRA $27					;Author: Scyzer | Title: Recover from shinesparks faster | skips checking the speeds of the spark echoes, therefor runs the timer out faster

org $90BB90 : STZ $0CD6,x				;Author: Begrimed | Title: Charge animation change | zeroes the animation counter instead of storing a value to it

org $9085A3 : LDA #$000F				;Author: Unknown | Title: Sound of running with speed boost = sound of shinespark | just changes what's loaded up as the index before the sound routine

org $9BC682 : NOP #3 : LDA $7EC1C4		;Author: Quote58 | Title: Grapple beam colour = equiped beam colour | removes the call to the beam update routine indexed with ice (0002), and then loads the brightest colour in the beam palette instead of a constant

org $90C14A : LDA #$0008				;Author: Unknown | Title: Change sound for bomb explosion | just changes the index for the sound to play (normally #$0008, changed to 67 when the gfx were energy things)

org $90C27B : dw $0A0A					;Author: Unknown | Title: Super missile fire rate = Missile fire rate | changes the super missile fire rate to match missiles

org $9085FE : LDA #$0000				;Author: Unknown | Title: Remove flicker from samus I frames | changes the BIT check (BIT #$0001) on the current frame index into a LDA #$0000 so it always branches

org $938125 : LDA #$0014				;Author: Unknown | Title: Super missile screenshake type (all solid surfaces) | #$0014 is the standard type

org $93812B : LDA #$001E				;Author: Unknown | Title: Super missile screenshake duration (all solid surfaces) | #$001E is the standard type

org $A0A1E9 : LDA #$0012				;Author: Unknown | Title: Super missile screenshake type (all enemies except pirates) | #$0012 is the standard type for enemies

org $A0A1E3 : LDA #$001E				;Author: Unknown | Title: Super missile screenshake duration (all enemies except pirates) | #$0012 is the standard type for enemies

org $A09CB7 : LDA #$0012				;Author: Unknown | Title: Super missile screenshake type (space pirates) | #$0012 is the standard type for enemies

org $A09CB1 : LDA #$001E				;Author: Unknown | Title: Super missile screenshake duration (space pirates) | #$0012 is the standard type for enemies

org $A6F65E : db $30					;Author: Unknown | Title: Ceres doors open/close distance | *will check later*

org $9081CC : BRA $0A					;Author: Unknown | Title: Allow running in lava | forces a branch regardless of suit

org $90E2E9 : LDA #$0050				;Author: DSO | Title: Draygon Pose-change softlock fix (moving left, facing right) | originally #$0001, which is facing left normal

org $90E2F1 : LDA #$004F				;Author: DSO | Title: Draygon Pose-change softlock fix (moving right, facing left) | originally #00002, which is facing right normal

org $84DCF2 : db $01					;Author: Unknown | Title: Number of hits to destroy Draygon room turrets | *will check later* (default is 03)

org $84DDCD : db $01					;Author: Unknown | Title: Number of hits to destroy Draygon room turrets | *will check later* (default is 03)

;org $91BA12 : db $12					;Author: Unknown (black falcon?) | Title: Springball height fix (right) | probably a height table (originally 13)

;org $91BA1A : db $12					;Author: Unknown (black falcon?) | Title: Springball height fix (left) | probably a height table (originally 13)

org $908349 : CMP #$001E				;Author: Unknown | Title: Amount of health to trigger arm shaking | compares samus' health to X where X is normally #$001E

org $948E92 : dw $EAEA					;Author: Unknown | Title: Allow WS spikes to work before killing Phantoon | *will check later*

org $A3F027 : LDA #$0190				;Author: Unknown | Title: Enemy frozen timer for Metroids | X is stored to $0F9E,x where X is the duration and $0F9E,x is the frozen timer index in enemy ram data

org $A5EA43 : dw $2680					;Author: Unknown | Title: Spore Spawn's tail is made of spore spawners from ceiling | changes projectile pointer?

org $84D156 : dw $02D2					;Author: Unknown | Title: Golden Torizo liquid level | *will check later*

org $88DB62 : ADC !W_FX3_Ypos			;Author: Unknown | Title: Fog vertical offset determined by FX3 height variable (actual height) | adds FX3 Ypos instead of a constant

org $88DB82 : ADC !W_FX3_target_Ypos	;Author: Unknown | Title: Fog horizontal offset determined by FX3 height variable (target height) | adds FX3 Ypos target instead of a constant

org $88DA73 : ADC !W_FX3_Ypos			;Author: Unknown | Title: Spores speed & angle determined by FX3 height variable (actual height) | adds FX3 Ypos instead of a constant

org $88DA97 : ADC !W_FX3_target_Ypos	;Author: Unknown | Title: Spores speed & angle determined by FX3 height variable (target height) | adds FX3 Ypos target instead of a constant

org $AAC957 : NOP #3					;Author: JAM | Title: GT code doesn't freeze the game | *will check later*

org $909ED3 : db $02					;Author: Grime | Title: Walljump height [under water] w/o Gravity | part of a data table of values to use for walljumping

org $909EDF : db $02					;Author: Grime | Title: Walljump height [under water] w/o Gravity, with Hijump | part of a data table of values to use for walljumping

org $909EF7 : db $01					;Author: Grime | Title: Bombjump height [under water] w/o Gravity | part of a data table of values to use for bomb jumping

org $90D0A3 : LDA #$0061 : JSL $8090C1	;Author: Grime | Title: Shinespark sound [samus presses jump and nothing else] | changes the index of the sound as well as the library for the sound to use (originally #$000F with library 2 ($80912F))

org $91DAD0 : LDA #$003B : JSL $809049	;Author: Grime | Title: Shinespark sound [samus stored a shinespark by crouching] | changes the index of the sound as well as the library for the sound to use (originally #$000C with library 2 ($80912F))

org $91FAF3 : LDA #$0061 : JSL $8090C1	;Author: Grime | Title: Speedbooster sound [samus is now shinesparking] | changes the index of the sound as well as the library for the sound to use (originally #$0003 with library 2 ($80912F))

org $90B85F : CMP !C_Full_charge		;Author: Unknown | Title: Length of time (in frames) fire needs to be held down before beam becomes charged | originally LDA #$003C

org $91D755 : CMP !C_Full_charge		;Author: Unknown | Title: Length of time (in frames) before samus palette changes when charging | originally LDA #$003C

org $909E98 : db $01					;Author: Unknown | Title: Frequency that space jump can be used [air] | part of a data table related to space jump physics

org $909E9C : db $01					;Author: Unknown | Title: Frequency that space jump can be used [under water] | part of a data table related to space jump physics

org $90C27B : db $08					;Author: Unknown | Title: Rate of fire for missiles | originally 0A
			  db $0A					;Author: Unknown | Title: Rate of fire for super missiles | originally 14

org $A0A096 : NOP #3					;normally STZ !W_Invuln_timer ($18A8)

org $8280BD : db $07					;Author: Unknown | Title: Different music for rainy zebes after ceres | normally $05, play index for landing on rainy Zebes after Ceres

org $88878A : db $00					;Author: Quietus | Title: How long Xray Scope takes to widen | This is actually not at all how this works. This hex tweak literally changes the second byte of an address, not some timer or anything
org $888799 : LDA #$000A				;Author: Quietus | Title: Xray Scope beam width | maximum angle from samus (although it's 0A84, but the angle should be in 0A82?). If this is changed, then $888791 needs to be 1 more than the new value
org $888791 : CMP #$000B				;Author: N/A | Title: N/A | this is the max value + 1 that is compared against to determine whether the angle of the beam has been reached

org $8887F8 : db $02					;Author: Black Falcon | Title Xray Scope speed changes | frame delay table changes afaik
org $88881A : db $02
org $88887B : db $02
org $888850 : db $02

org $84D193 : dw $0004					;Author: Unknown | Title: Which item activates lower norfair chozo | just a bit check normally, #$0200 (space jump)

org $AAC90F : NOP #4					;Author: Quote58? | Title: Remove haze from Bomb Torizo room | normally JSL $88DD32, which activates the bomb torizo room haze. It's hardcoded because ????

;org $90BCF9 : LDA !C_Hyper_beam			;Author: Unknown | Title: Type of projectile used for hyper beam | default is 9018 (charged plasma)

org $AAD507 : dw $0010					;Author: Unknown | Title: Distance from Samus until Golden Torizo jumps backwards and does his spitting or crescent attacks | *needs more info*

org $84B48B : dw $0000, $0001  			;Author: N/A | How far samus gets moved in quicksand? | Distance to move Samus vertically * 100h in air, on ground, and her max velocity (dw w/o gravity, with gravity) (originally 0200, 0200, 0120, 0100, 0280, 0380)
			  dw $0120, $0100
			  dw $0600, $0600

org $84B4B6 : LDA #$0000 : STA $0B5A	;Author: N/A | Fast sandfall no longer pushes samus down at all? | noramlly C000 to 0B5A and 0001 to 05BC
			  LDA #$0000 : STA $0B5C

org $A6AACD : LDA #$003B : JSL $8090CB  ;Author: Grime? | different sound for ridely before he flies at samus in ceres | normally #$004E

;org $90EA5A : CMP #$0007				;Author: Quote | what region can't pause | default is 0006 (ceres), 0007 is debug <-- this causes gfx issues in ceres, whoops!


;Wrecked ship chozo animation changes
;bowling chozo grabbing samus in ball form
org $AAE467 : dw $0010	;normally $0020
			  dw $E7DD, $E5D8, $0002
			  dw $0001	;normally $0008
			  dw $E839, $E5D8, $0004
			  dw $0001	;normally $0050

;glowing eyes opening  
org $AAE481 : dw $0012, $E8E7	;normally $0080
			  dw $0004, $ECB9	;normally $0006
			  dw $0004,	$ED15	;normally $0004
			  dw $0004,	$ED71	;normally $000A
			  dw $0004, $EDCD	;normally $000C
			  dw $0042, $EE29	;normally $0080

;eyes dimming/glowing repeatedly
org $AAE49B : dw $0002			;number of times to repeat animation, normally 04
			  dw $0004, $ED15	;normally $000B
			  dw $0004, $ED71	;normally $0008
			  dw $0004, $EDCD	;normally $0006
			  dw $0004, $EE29	;normally $0008
			  dw $0004, $EDCD	;normally $0006
			  dw $0004, $ED71	;normally $0008

;walking left and breaking through spikes
org $AAE4C9 : dw $0004, $EC49	;normally $0008
			  dw $E587, $E5D8
			  dw $0008, $E58F, $FFEC
			  dw $0008, $E943, $E5D8	;normally $000B
			  dw $000A, $E58F, $FFF0
			  dw $0004, $E9AE, $E5D8	;normally $0008
			  dw $000C, $E58F, $0000
			  dw $0003, $EA1E, $E5D8	;normally $0006
			  dw $000E, $E58F, $FFF8
			  
			  dw $0004, $EA8E	;normally $0008
			  dw $E587, $E5D8
			  dw $0010, $E58F, $FFEC
			  dw $0008, $EAFE, $E5D8	;normally $000B
			  dw $0012, $E58F, $FFF0
			  dw $0004, $EB69, $E5D8	;normally $0008
			  dw $0014, $E58F, $0000
			  dw $0003, $EBD9, $8110	;normally $0006

;last step in front of gravity suit room's door
org $AAE531 : dw $0004, $EC49, $E5D8	;normally $0008
			  dw $0008, $E58F, $FFEC
			  dw $0008, $E943, $E5D8	;normally $000B
			  dw $000A, $E58F, $FFF0
			  dw $0004, $E9AE, $E5D8	;normally $0008
			  dw $000C, $E58F, $0000
			  dw $0003, $EA1E, $8074	;normally $0006

;holding and releasing samus after stopping
org $AAE55F : dw $0001, $E8E7, $E5D8	;normally $0080
			  dw $0004
			  dw $0002, $E890, $E5D8	;normally $0050
			  dw $0002
			  dw $0002, $E839, $E5D8	;normally $0008
			  dw $0000
			  dw $0002, $E7DD, $E6F0	;normally $0020

org $AAE4BF : dw $0010	;distance to walk before releasing samus (normally $0010)

;Lower norfair chozo animation changes

;grabbing onto Samus in morph ball form
org $AAE3AD : dw $0001
org $AAE3B5 : dw $0002
org $AAE3BD : dw $0001

;glowing eyes 'opening'
org $AAE3C7 : dw $0001, $F0E2	;normally $0040
			  dw $0002, $F4B4	;normally $0006
			  dw $0002,	$F510	;normally $0004
			  dw $0002,	$F56C	;normally $000A
			  dw $000C, $F5C8	;normally $0060

;eyes dimming/glowing repeatedly
org $AAE3E3 : dw $0010			;number of times to repeat animation, normally 04
			  dw $0002, $F510	;normally $000B
			  dw $0002, $F56C	;normally $0008
			  dw $0002, $F5C8	;normally $0006
			  dw $0002, $F624	;normally $0008
			  dw $0002, $F5C8	;normally $0006
			  dw $0002, $F56C	;normally $0008

;holding and releasing Samus after acid has been lowered
org $AAE407 : dw $0002			;normally $0080
org $AAE40F : dw $0002			;normally $0050
org $AAE417 : dw $0002			;normally $0008
org $AAE41F : dw $0002			;normally $0020

; ::: Edits to samus eater plants (DSO) :::
org $84ACFE : db $02					;mouth timer top
org $84ACBE : db $02					;mouth timer bottom
org $84ACAB : dw $0008					;damage value

org $84ACBF : db $03 : skip 3			;animation top
			  db $03 : skip 3
			  db $03 : skip 3
org $84ACD0 : db $03 : skip 3
			  db $03 : skip 3
			  db $03 : skip 3
			  db $03 : skip 3
org $84ACE2 : db $03
org $84ACEE : dw $0030					;time between attacks for samus to jump out

org $84ACFF : db $03 : skip 3			;animation bottom
			  db $03 : skip 3
			  db $03 : skip 3
org $84AD10 : db $03 : skip 3
			  db $03 : skip 3
			  db $03 : skip 3
			  db $03 : skip 3
org $84AD22 : db $03
org $84AD2E : dw $0010					;time between attacks for samus to jump out










































