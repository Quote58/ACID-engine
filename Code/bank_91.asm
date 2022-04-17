lorom

; misc changes
org $91D755 : CMP !C_Full_charge
org $91E5F0 : LDA !C_Hyper_beam
org $91DAA9 : dw Screw_attack_glow_pal_power, Screw_attack_glow_pal_varia, Screw_attack_glow_pal_gravity
org $91F88C : JSR Moonwalk_check : BCC $02 ;where the game normally checks for moonwalk
org $91FBCF : dw $FC07, $FC07, $FC66, Jump_transition_spin ;0: Standing,  1: Running, 2: Normal jumping, 3: Spin jumping

; shinespark palette stuff
org $91DAC7 : LDA $0A68 : CMP #$010F	;play sound at 94% of the timer (originally AA of B4, now 10F of 120) (****this is also where the actual timer for shinesparking is decremented, NOT just the palette*****)
org $91F7B0 : JMP Give_spark			;the shinespark timer and palette timer are now separate, so they need to both be given the value
org $91DB3A : LDA !W_Spark_pal : DEC	;part of the routine which gives samus her shinespark palette
			  STA !W_Spark_pal

; morph related things
org $91D77F : JSR Load_samus_palette_charge	;hijack of charge beam palette routine, right before it calls DD5B with the charge palette in X
org $91ECFE : JSR Morph_flash_trigger	;hijack of the pose transition routine, where samus is unmorphing
org $91FDE7 : JSR Morph_flash_trigger	;hijack of the routine that changes samus's radius and boundries when she is morphing
org $91EFFA : JSR Morph_flash_trigger : NOP #3 ;originally STZ $0B2C, $0B2E, it does not clear vertical velocity, and it also triggers morph flash

; --- (probably scyzer or black falcon) ---
; part of the routine that handles changing samus palette based on charge flash/charge/seudo screw/etc
; this makes it use the brightest colour in the beam palette
org $91D7A1
	LDA $7EC1CC							;this is normally a solid colour value, and normally this routine has a clc before the rts, but that's not needed
	-
	STA $7EC182,x						;now it just grabs the brightest colour in the beam palette and uses that instead
	DEX #2 : BPL -
	RTS

; --- Quote58 ---
org $91DF80
   !phb									;reserve missiles ram has been repurposed as it's never used in the game, so the restore missiles to samus routine needed to be adjusted to reflect this
	CLC : ADC !W_Missiles : STA !W_Missiles
	CMP !W_Missiles_max : BMI + : BEQ +
	LDA !W_Missiles_max : STA !W_Missiles
	+
   !plb
	RTL

; --- Quote58 ---
org $91DD5B								;X = palette offset in $9B
   !phs									;stores a palette to samus' current palette in ram
	JSR Load_samus_palette
   !pls
	RTS

org $91DDD7								;X = palette offset in $9B
   !phs									;store a palette to samus' target palette in ram
	JSR Load_samus_palette_target
   !pls
	RTS

org $91DE53								;Clean up for blue suit/speed echoes/speed counter
   !phb
	LDA $0B3C : BEQ +					;this is where the check speed counter address is actually used
	STZ $0B3C
	STZ !W_Speed_counter
	STZ $0ACE							;1 if running with speed booster?
	STZ $0AD0							;0 if running with speed booster?
	JSL !Update_palette					;saves 32 bytes because redundant code is redundant
	+
	LDA $0AAE : BMI +++					;if no more echoes, end
	LDA #$FFFF : STA $0AAE				;otherwise clean up echoes
	LDA $0A1E : AND #$00FF : CMP #$0004
	BEQ +
	LDA #$0008 : STA $0AC0 : BRA ++		;saves 4 bytes because redundant code is redundant -_-
	+
	LDA #$FFF8 : STA $0AC0
	++
	STA $0AC2
	+++
   !plb
	RTL

org $9181A9 : JMP Handle_pose_transition
org $91ACC0
; this is the end of the transition table which has been free'd up (currently ends at ACA0, so I'm giving $20 bytes wiggle room by default)
; thanks to Kejardon's initial optimizations of the table. Other code
; starts again at 91AFFC, which gives this space ~790 free bytes to use

; --- Quote58 ---
Screw_attack_glow:
;whoever made the stupid screw attack glow fucked up and it's pissing me off trying to fix it, so I just expanded the damn table by 2 entries so it won't get caught with a 0000 palette entry
.pal_power : dw $9B20,$9B40,$9B60,$9B80,$9B80,$9B80
.pal_varia : dw $9D20,$9D40,$9D60,$9D80,$9D80,$9D80
.pal_gravity : dw $9F20,$9F40,$9F60,$9F80,$9F80,$9F80

; --- Quote58 ---
Moonwalk_check:
	LDA !C_O_Moon_walk : JSL Check_option_bit
	RTS

; --- Scyzer/Kejardon (optimised/reduced by Quote58) ---
; change to the routine for checking if you can transition into a spinjump
; expanded to allow for respin
Jump_transition:
.spin
	SEP #$20							;saves 2 bytes and a few cycles to use 8bit here
	LDA $0A23							;movement type *last* frame
	CMP #$03 : BEQ +					;spin jump
	CMP #$14 : BEQ +					;walljump
	CMP #$02 : BEQ +					;normal jump
	CMP #$06 : BEQ +					;fall
	JSL $9098BC							;calculate samus' vertical speeds (including speed booster height reduction) and sets her moving up (makes her jump basically)
	+
	REP #$20
	RTS

; --- Quote58 ---
Give_spark:
	LDA !W_Speed_counter
	AND #$FF00 : CMP #$0400 : BMI +
	LDA !W_V_direction : BNE +
	LDA !C_Full_spark : STA !W_Spark_timer
						STA !W_Spark_pal
	LDA #$0001 : STA $0ACC
	STZ $0ACE
	+
	CLC
	RTS

; --- Quote58 ---
Load_samus_palette:
	PHY
	TXY : LDX #$0100
	BRA +

.target
	PHY
	TXY : LDX #$0300
	+
   %pea(9B)
	LDA $0000,y : STA $7EC080,x
	LDA $0002,y : STA $7EC082,x
	LDA $0004,y : STA $7EC084,x
	LDA $0006,y : STA $7EC086,x
	LDA $0008,y : STA $7EC088,x
	LDA $000A,y : STA $7EC08A,x
	LDA $000C,y : STA $7EC08C,x
	LDA $000E,y : STA $7EC08E,x
	LDA $0010,y : STA $7EC090,x
	LDA $0012,y : STA $7EC092,x
	LDA $0014,y : STA $7EC094,x
	LDA $0016,y : STA $7EC096,x
	LDA $0018,y : STA $7EC098,x
	LDA $001A,y : STA $7EC09A,x
	LDA $001C,y : STA $7EC09C,x
	LDA $001E,y : STA $7EC09E,x
	PLB
	PLY
	RTS

.charge
	JSL Is_morphed : BCC +
	JMP .bomb_charge
	+
   !phs
	LDA !W_Beams_equip : BIT !C_I_ice : BNE +
	JSR Load_samus_palette
   !pls
	RTS
	+
	PHY
	TXY : LDX #$0100
   %pea(9B)
	LDA #$000F : STA $00
	; with ice equipped, the charge glow gets boosted blue and green to make it colder
	-
	LDA $0000,y	: AND #$001F : STA $02
	LDA $0000,y : AND #$03E0 : CMP #$03C0 : BPL +
	CLC : ADC #$0020
	+
	STA $04
	LDA $0000,y : AND #$7C00 : CMP #$6000 : BPL +
	CLC : ADC #$1C00
	+
	CLC : ADC $04 : ADC $02 : STA $7EC080,x
	INX #2 : INY #2
	DEC $00 : BPL -
	PLB
	PLY
   !pls
	RTS

.bomb_charge
!Type		  = $00
!Index 		  = $02
!Threashold_1 = #$0060					;one third of the maximum #$00C0
!Threashold_2 = #$00C0					;fully charged, max height/speed to launch with
!Palette_1	  = #$0380					;unused (?) 4 line brightness increase (like a 4 line version of charge)
!Palette_2	  = #$0400					;shinespark palette

	LDA !W_Bomb_charge
	CMP !Threashold_1 : BMI ++
	CMP !Threashold_2 : BMI +
	LDA !Palette_2 : BRA $03
	+
	LDA !Palette_1
	STA !Type
	
	LDA !W_Palette_index				;palette index is 0, 2, or 4 for P/V/G respectively
	LSR : XBA : STA !Index				;most of the palettes are stored $200 bytes apart ($80 per 4 line palette)
										;however, the charge flash palette is 8 lines (even though only the first 4 are used)
	TXA									;this means that to offset from the charge palette to the shinespark palette, it's +$400/+$500/+$600
	CLC : ADC !Type : ADC !Index		;instead of 400/600/800, therefor we need to use 400 + (palette_index / 2)
	TAX
	++
	JSR $DD5B
	RTS

; --- Quote58 ---
; this is a big routine in the game, it reads the transition table and handles whether to transition to the pose or not
; I've rewritten it so that you can make a given pose transition only possible if an option is set to on (backflip, upspin, etc.)
Handle_pose_transition:
!Pressed = $0000
!Held	 = $0002
!Pose	 = $0004

	LDA !W_Held : BEQ .end
	JSR $81F4							;this routine translates custom controller bindings into the default ones used by the table
	LDA !W_Current_pose : ASL : TAX
	LDA $9EE2,x : TAY					;$9EE2 is the transition table
	
	LDA !Pressed,y : INC : BEQ .end_of_entry ;0 - 1 = FFFF, which is the terminator value for a pose entry	
	-
	DEC : BEQ +
	AND $12 : BNE .next_entry
	
	+
	LDA !Held,y : BEQ .input_good
	AND $14 : BEQ .input_good
	
.next_entry
   %iny(#$0006)
	LDA !Pressed,y : INC : BNE -
	
.end
	STZ $0A18							;???
	JSL $9182D9							;something to do with animation speed maybe??

.end_of_entry
	CLC
	RTS
	
.input_good
	LDA !Pose,y
	CMP !W_Current_pose : BEQ .end_of_entry
	CMP #$0100 : BMI .normal_pose		;there are no more than FF poses in the game, so the other byte in the table entry is now an option bit if >00
	PHA : AND #$FF00 : XBA
	CMP !C_O_Upspin : BNE .not_upspin	;an unfortunate side effect of upspin is that the morph pose thinks it can do a spinjump
	LDA !W_V_direction : BNE ++			;if you bomb jump and then upspin, so this just makes sure that upspin won't trigger if you're in the air
	PLA : PHA : AND #$FF00 : XBA
.not_upspin
	JSL Check_option_bit : BCS +
	++
	PLA : BRA .next_entry
	+
	PLA : AND #$00FF
.normal_pose
	STA !W_New_pose
	STZ $0A56
	SEC
	RTS

; --- Quote58 (hijack point by Black Falcon) ---
Morph_flash_trigger:
	STA $0B00
	PHA : PHX							;conditions:
	CMP #$0007 : BNE .end				;if the boundry being set is for morph
   %check_option(!C_O_Morph_flash)		;if the option bit is set
	LDA !W_Echoes_active : BNE .end		;if not in speed booster (if echoes sound not playing)
	LDA !W_Morph_flash   : BNE .end		;if not currently performing a morph flash
	LDA !W_Spark_timer   : BNE .end		;if not holding a spark (which causes flashing)
	LDA !W_Charge : CMP !C_Full_charge	;if not holding a charge
	BPL .end
	
	LDA !W_X_pos : CLC : ADC #$0004		;samus' y position is centred within her sprite, so it needs to check +/- 4 pixels of her y pos
	JSR .check_if_air : BNE .end		;if the block above samus isn't air, don't flash
	
	LDA !W_X_pos : SEC : SBC #$0004
	JSR .check_if_air : BNE .end
	
	LDA !C_Flash_amount : STA !W_Morph_flash ;activate morph flash by resetting the palette index
	;JSL Play_morph_sound
	
.end
	PLX
	PLA									;this value is used after the hijack, so it needs to be preserved
	RTS
	
.check_if_air
	TAX
	LDA !W_Y_pos : SEC : SBC #$0010
	JSL Find_block : AND #$F000
	RTS

print "End of extra space after transition table (91AFFC): ",pc

org $91FFEE
; free space at the end of bank $91

print "End of free space (91FFFF): ", pc































