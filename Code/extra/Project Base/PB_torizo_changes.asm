org $AAC6F6 : JSR Bt_fog_init			;torizo enemy is awake, property bits have been restored
org $AAC269 : JSR Bt_fog_active			;torizo has gotten up, regular palette is given as a target for palette fade routines
org $AAC70F : JSR Bt_fog_chest			;first health threashold, change gfx ai pointer
org $AAC730 : JSR Bt_fog_face			;second health threadhold, change gfx ai pointer
org $AAC99C : JSR Bt_fog_dieing			;shot ai, torizo is out of health, start exploding
org $AAB263 : JSR Bt_fog_dead : NOP		;torizo is done exploding, set up item drops


Bt_fog:
.init
	LDA #$0001 : PHA
	LDA #$FF10 : PHA
	LDA #$FFF0 : BRA .adjust		;while the torizo is standing up and getting ready, the fog should be stopped
.active
	LDX #$001E : PHA
	LDA #$FE90 : PHA
	LDA #$FEB0 : BRA .adjust
.chest
	LDA $0F92,x : PHA
	LDA #$FD20 : PHA
	LDA #$FD30 : BRA .adjust
.face
	LDA $0FB4,x : PHA
	LDA #$FB40 : PHA
	LDA #$FB40 : BRA .adjust
.dieing
	LDA #$C6AB : PHA
	LDA #$FF10 : PHA
	LDA #$FFF0
.adjust
	STA !W_FX3_Ypos : PLA
	STA !W_FX3_target_Ypos
	LDA #$0019 : STA !W_Scrn_shake_type
	LDA #$0040 : STA !W_Scrn_shake_time
	PLA
	RTS

.dead									;don't want to shake the screen when the torizo is already gone
	JSL $A0BAA4
	LDA #$FF10 : STA !W_FX3_target_Ypos
	LDA #$FFF0 : STA !W_FX3_Ypos
	RTS
