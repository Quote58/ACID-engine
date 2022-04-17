org $9498B2 : dw Easter_egg_1_condition ;pointer to code for air fool xray block bts 03

; --- Quote58 ---
Easter_egg_1_condition:
	LDA !W_Speed_counter : AND #$0F00	;for the green chozo block to crumble, you need to hit this tile while speed boosting
	CMP #$0400 : BNE .not_met
	JSL Is_morphed : BCC .not_met		;in morph
	LDA !W_Items_equip : BIT !C_I_spring : BEQ .not_met ;with springball
	LDA #$0002 : JSL !Check_boss_bit : BCC .not_met	;need to make sure that croc is actually dead before green chozo room is available
	LDA #$0040 : STA !W_Easter_egg_1
	RTS
.not_met
	LDA #$0000 : STA !W_Easter_egg_1
	RTS


; --- Black Falcon (Fixed and Optimized by Quote58) ---
;this should probably be an enemy or a level1_2 pointer because bts blocks really suck at single time setups like this
!Lower_speed = #$001F
!Rise_speed  = #$FFFF-!Lower_speed		;rise speed has to be negative, therefor rise_speed = -(lower_speed) = FFFF - lower_speed
!Difference  = #$0020

Raise_water:							;these two routines could be combined and optimized to save 8 bytes, but for the sake of readability/modularity, I'm leaving them separate
	LDA !Rise_speed : STA !W_FX3_V_speed
   %sub(!W_FX3_Ypos, !Difference, !W_FX3_target_Ypos)
	BRA Shake_and_delay

Lower_water:
	LDA !Lower_speed : STA !W_FX3_V_speed
	%add(!W_FX3_Ypos, !Difference, !W_FX3_target_Ypos)

Shake_and_delay:
	LDA #$0001 : STA !W_FX3_move_delay
	LDA #$0010 : STA !W_Scrn_shake_time
	RTS


; insert at end_clear
.end_clear
	;JSR .check_for_walljumping					;if we're walljumping, we need to fix that pose

.check_for_walljumping
	LDA !W_Current_pose : AND #$00FF
	CMP #$0083 : BEQ +
	CMP #$0084 : BNE ++
	+
	PHA
	LDA !W_Items_equip : BIT !C_I_screw : BNE .has_screw
						 BIT !C_I_spacejump : BNE .has_space
	LDA #$0019 : BRA +
.has_screw
	LDA #$0081 : BRA +
.has_space
	LDA #$001B
	+
	STA !W_Current_pose
	
	STZ $0DC6
	LDA #$0001 : STA $0B02
	PLA : BIT #$0001 : BNE ++
	INC !W_Current_pose
	DEC $0B02
	++
	RTS