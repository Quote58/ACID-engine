

org $90854D : JSR Dash_ball					;this is where the game normally checks that samus' movement type is walk or run before deciding whether to dash
org $909774 : JSR Dash_ball					; ||
org $90A57C : JSR Midair_unmorph : NOP #3	;mid air unmorph won't reset horizontal speed
org $90851D : JSR Spin_slower : NOP #2		;hijack of animation frameskip

; --- Quote58 ---
Bomb_speed:
	;LDA !W_V_direction : BNE +				;uncomment this line if you want bombs to only be instant when on the ground
	LDA !W_Held : BIT !W_B_down : BEQ +		;check for holding down
	LDA #$0001 : BRA ++						;0 makes bombs never explode, 1 makes them explode instantly
	+
	LDA !W_Bomb_timer : ASL : TAY			;replace these two lines with a LDA #$<your_bomb_timer> if you want a constant speed
	LDA .timers,y
	++
	RTS
	
.timers
	dw $005C, $003C, $001C


; --- Quote58 ---
Dash_ball:
	AND #$00FF : CMP #$0001 : BEQ .end		;this is what is normally used to determine whether to dash
				 CMP #$0004 : BEQ +			; + normal ball on ground
				 CMP #$0011 : BNE .end		; + spring ball on ground
	+
	LDA !W_Items_equip : BIT !C_I_dash		;if in ball, check for item
	BNE +									;until dash ball plm is placed in the game, this ability comes with springball
	LDA #$0000								;if dash ball is not equipped, don't dash
	RTS
	+
	LDA #$0001								;if it is, all good to dash
.end
	RTS


; --- Author Unknown ---
Midair_unmorph:
	LDA !W_Collision_flag : CMP #$0001 : BNE +
	STZ !W_H_speed
	STZ !W_H_speed_sub
	+
	RTS


; --- Black Falcon (opimized/reduced by Quote58) ---
Spin_slower:
!MaxCount = #$000A							;after how many animation frames it adds +1 to the animation timer
!MaxDelay = #$000A							;maximum of 10 ingame frames between animations

	LDA !C_O_Spin_complex : JSL Check_option_bit : BCS +
	LDA [$00],y : AND #$00FF
	RTS

	+
	LDA !W_Move_type
	AND #$00FF : CMP #$0003 : BEQ +
				 CMP #$0014 : BNE .no_spin	;must be spin jumping
	+
	LDA !W_Current_pose
	AND #$00FF : CMP #$0019 : BEQ .spin		;must be in spin jump pose
				 CMP #$001A : BNE .no_spin	;else don't change the animation counter
.spin
	INC !W_Spin_counter
	LDA !W_Spin_counter : CMP !MaxCount
	BMI .add_delay
	
	STZ !W_Spin_counter
	LDA !W_Spin_frame_delay : CMP !MaxDelay
	BPL .add_delay
	
	INC !W_Spin_frame_delay					;if it's been !Max_count frames, increase the delay on the animation
.add_delay										
	LDA [$00],y
	CLC : ADC !W_Spin_frame_delay
	BRA .end
	
.no_spin									;no spin at all
	STZ !W_Spin_counter
	STZ !W_Spin_frame_delay
	LDA [$00],y
.end
	AND #$00FF
	RTS

Spinjump_animation_alt:
	PHY
	JSL Spinjump_animation_get_table : BCC +
	TYA : BRA ++
	+
	LDA $91B010,x
	++
	PLY
	RTS