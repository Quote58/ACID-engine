	LDA !W_Health : CMP !W_Health_mirror : BEQ +
	STA !W_Health_mirror
	LDA !C_H_Health : TSB !W_Hud_update_flags
	+

	LDA !W_Reserves : CMP !W_Reserves_mirror : BEQ +
	STA !W_Reserves_mirror
	LDA !C_H_Reserves : TSB !W_Hud_update_flags
	+

	LDA !W_Missiles_max : BEQ +
	LDA !W_Missiles : CMP !W_Missiles_mirror : BEQ +
	STA !W_Missiles_mirror
	LDA !C_H_Missiles : TSB !W_Hud_update_flags
	+

	LDA !W_Supers_max : BEQ +
	LDA !W_Supers : CMP !W_Supers_mirror : BEQ +
	STA !W_Supers_mirror
	LDA !C_H_Supers : TSB !W_Hud_update_flags
	+

	LDA !W_Powers_max : BEQ +
	LDA !W_Powers : CMP !W_Powers_mirror : BEQ +
	STA !W_Powers_mirror
	LDA !C_H_Powers : TSB !W_Hud_update_flags
	+

	LDA !W_HUD_select : CMP !W_HUD_select_mirror : BEQ +
	LDA !C_H_Select : TSB !W_Hud_update_flags
	JSR .toggle_click
	+

	LDA !W_Auto_cancel_item : BEQ +
	LDA !C_H_Select : TSB !W_Hud_update_flags
	+

	LDA !W_Pressed : CMP !W_Pressed_mirror : BEQ +
	STA !W_Pressed_mirror : BRA ++
	+
	LDA !W_Held : CMP !W_Held_mirror : BEQ +
	STA !W_Held_mirror
	++
	LDA !C_H_Input : TSB !W_Hud_update_flags
	+

	LDA !W_Beams_collect : BIT !C_I_charge : BEQ +
	LDA !W_Charge : CMP !W_Charge_mirror : BEQ +
	STA !W_Charge_mirror
	LDA !C_H_Charge : TSB !W_Hud_update_flags
	+

	LDA !W_Spark_timer : BEQ +
	LDA !C_H_Spark : TSB !W_Hud_update_flags
	+

	LDA !W_Disable_minimap : BNE ++
	LDA !W_Mini_map_mirror : CMP #$0001 : BEQ +
	LDA !W_Frame_counter : AND #$000F : BEQ +
	CMP #$0009 : BNE ++
	+
	LDA !C_H_Minimap : TSB !W_Hud_update_flags
	++