lorom

; this is a change to the gate plm to allow it to use only one tile in vram
; instead of the four tiles which were just one tile flipped three times
org $86E659								;regular gate
	dw $E5D5							;init ai
	dw $E604							;pre instruction routine
	dw $E55E							;instruction list
	db $00,$00							;x/y radius
	dw $2000							;properties
	dw $0000							;touch ai
	dw $84FC							;shot ai

org $86E64B								;downwards gate spawned by regular gate
	dw $E5D0							;init ai
	dw $E604							;pre instruction routine
	dw $E53C							;instruction list
	db $00,$00							;x/y radius
	dw $2000							;properties
	dw $0000							;touch ai
	dw $84FC							;shot ai

org $86E55E								;regular gate
	dw $E533, $FF00
	dw $0001, Frame_4_gate, $8159		;show frame for close gate, then wait
	dw $8161,$E605						;finds the speed value for moving up/down
	
	dw $0001, Frame_4_gate, $8159		;show frame, then wait
	dw $0001, Frame_3_gate, $8159
	dw $0001, Frame_2_gate, $8159
	dw $0001, Frame_1_gate, $8159
	dw $8154
	
org $86E53C								;downwards gate
	dw $E533, $0100
	dw $8161,$E605						;finds the speed value for moving up/down
	
	dw $0001, Frame_1_gate, $8159		;show frame, then wait
	dw $0001, Frame_2_gate, $8159
	dw $0001, Frame_3_gate, $8159
	dw $0001, Frame_4_gate, $8159
	dw $816A

org $8683B2 : JMP New_draw
org $86EFE2 : JSL Charge_attract : NOP #2
org $86FAB0
; free space in bank $86
; --- Quote58 ---
; since the gate spritemaps are now much larger than before, they can't be stored in the same bank as before
; and as a result we need to change the draw routine to pull from a different bank in the case that it's drawing the gate projectile
New_draw:
	PHB
	REP #$30
	JSR $8427							;check if room is shaking

	LDX #$0022
	-
	LDA $1997,x : BEQ ++				;any projectiles left to draw?
	CMP #$E659 : BEQ +					;check for regular gate
	CMP #$E64B : BEQ +					;check for downwards gate
	PEA $8D00 : BRA $03
	+
   %pealt(83)							;if it's a gate, switch the bank to $83 for the tilemaps
	LDA $1BD7,x : AND #$1000			;check if the projectile is visible
	BNE ++
	JSR $83D6							;draw the sprite
	++
	DEX #2 : BPL -
	PLB
	RTL

; --- Quote58 (initial concept by black falcon/jathys (and metroid prime)) ---
; this is a super metroid version of the tractor beam first introduced in Metroid Prime
; the difference with this one, is that it calculates the angle between the projectile and samus
; so that it can move smoothly towards her
; on top of that, it also accelerates based on time holding charge
; ie. if you release shoot and then charge again, it needs to regain it's acceleration

Charge_attract:							;[X = projectile index]
!Angle = $00
!NewX  = $02
!NewY  = $04

	LDA !C_O_Charge_attract : JSL Check_option_bit : BCC .end
	LDA !W_Charge : CMP !C_Full_charge : BMI .end
	
   %sub("!ER_proj_Xpos,x", !W_X_pos, $12)
   %sub("!ER_proj_Ypos,x", !W_Y_pos, $14)
	JSL !Angle_calc : STA !Angle		;get angle between the projectile and samus
	LDA !W_Charge : CMP !C_Full_charge+1 : BPL +
	LDA !W_Bomb_charge : BRA ++
	+
	SEC : SBC !C_Full_charge			;set the multiplier depending on how long you've been charging
	++
	-
	LSR A
	CMP #$0008 : BMI +
	CMP #$0010 : BPL -
	LDA #$0008
	+
	STA !W_Multiplier

	LDA !Angle : JSL !Sine_neg			;get the x length (number of pixels to move horizontally)
	LDA !W_Trig_result : STA !NewX

	LDA !Angle : JSL !Cosine			;get the y length (number of pixels to move vertically)
	LDA !W_Trig_result : STA !NewY

   %inc("!ER_proj_Xpos,x", !NewX)		;move the projectile towards samus
   %inc("!ER_proj_Ypos,x", !NewY)
	
.end
	DEC $1B23,x
	LDA $1B23,x
	RTL


print "End of free space (86FFFF): ",pc

















