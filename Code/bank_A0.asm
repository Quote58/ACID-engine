lorom

; bomb related changes
org $A09834 : JSR Skip_bomb_jump		;hijack during interaction with bomb projectile, setup for bomb jump
org $A0A2D2 : JSR Clear_bomb_timer : NOP #2
org $A09D94 : BRA $03					;making sure that bombs will explode on contact with enemies that use multiple hitboxes as well
org $A0A280 : NOP #5					;make sure the game doesn't skip over bombs that aren't exploding

; enemy related changes
org $A08F5E : JSR Enemy_load			;better enemy loading
org $A0A119 : JSR Frozen_contact : BCS $02	;counter set = enemy not frozen
org $A0A9DC : JSR Frozen_alt 	 : BCC $0B	;counter clear = enemy frozen (this hijack is using the list of enemies left to process, so $0E54 is the last enemy that was processed, not the current one)

; misc changes
org $A0A70B : JSR Enemy_vulnerability_check
org $A08A98 : JSR Colour_Shift
org $A09169 : JSR Backflip				;hijack of the damage boost routine
org $A0F9D3
; free space in bank $A0

Enemy_vulnerability_check:
	AND #$000F : CMP #$000F : BNE +
	LDA #$000B
	+
	RTS

; --- kejardon maybe??? ---
; I'll be honest, I don't remember what this was for
; might be related to the super missile projectile changes?
; idk man, probably don't mess with it
Clear_bomb_timer:
	LDA #$0000 : STA $0C86,y
	RTS

; --- Scyzer ---
Skip_bomb_jump:
	LDA !W_Held : BIT !W_B_down : BEQ +	;check for holding down
	PLA : PLB							;if so, close out the routine, and RTL
	RTL									;this works because the address used for RTL wasn't changed with the JSR
	+
	LDA !W_X_pos						;otherwise continue the function
	RTS

; --- Quote58 ---
; this is mostly the same as the original screen shake routine
; but now you can turn them off entirely at their source
Screen_shake:
	LDA !C_O_Screen_shake : JSL Check_option_bit : BCS +
	STZ !W_Scrn_shake_time
	RTL
	+
   %pea(A0) : REP #$30
	LDA !W_Scrn_shake_time : BEQ .end
	LDA !W_Pause_time : BNE .end
	LDA !W_Scrn_shake_type : CMP #$0024 : BPL .end
	ASL #3 : TAX
	LDA !W_Scrn_shake_time : BIT #$0002 : BEQ +
	LDA $872D,x : EOR #$FFFF : INC : CLC : ADC !W_BG1_X : STA !W_BG1_X
	LDA $872F,x : EOR #$FFFF : INC : CLC : ADC !W_BG1_Y : STA !W_BG1_Y
	LDA $8731,x : EOR #$FFFF : INC : CLC : ADC !W_BG2_X : STA !W_BG2_X
	LDA $8733,x : EOR #$FFFF : INC : CLC : ADC !W_BG2_Y : STA !W_BG2_Y
	BRA ++
	+
   %inc(!W_BG1_X, "$872D,x") : %inc(!W_BG1_Y, "$872F,x")
   %inc(!W_BG2_X, "$8731,x") : %inc(!W_BG2_Y, "$8733,x")
	++
	DEC !W_Scrn_shake_time
	LDA !W_Scrn_shake_type : CMP #$0012 : BMI .end
	JSR $8712							;enemy shake routine
.end
	INC $1842
	PLB
	RTL

; --- Quote (hijack point from hex tweak by DSO) ---
; originally CMP #$0800, which is the size of the total space for enemy data
; $0E4C is the index of the last enemy in the room, meaning it only processes as many as it needs to
Enemy_load:
	PHA
	LDA !W_Region : CMP #$0004 : BPL .normal
	PLA : CMP !W_Enemy_last
	RTS
	
.normal
	PLA : CMP #$0800
	RTS
	
; --- Scyzer (fixed and expanded by Quote58) ---
Frozen_alt:
!SpeedBoost  = #$0001					;contact damage is 1 while speed boosting
!ShineSpark  = #$0002					;and 2 while shinesparking
!ScrewAttack = #$0003
!PsuedoSA	 = #$0004
!Index		 = $00

	LDA $18A6 : STA !Index
	BRA Frozen_contact_check

Frozen_contact:
	LDA !E_Index : STA !Index

.check
	LDA !W_Contact_dmg
	CMP !SpeedBoost : BEQ ++			;to add or remove contact damage indexes that destroy frozen enemies, replace or add CMP statements
	CMP !ShineSpark : BEQ ++				
	PHX
	LDX !Index
	LDA !E_Frozen,x : BEQ +				;if no time left on frozen timer
	PLX : CLC
	RTS
	+
	PLX : SEC
	RTS
	++
	JSR .possessors						;certain enemies spawn a second wing enemy which needs to be deleted manually
	SEC
	RTS

.possessors
   !phxy
	LDY #$0000
	LDX !E_Index
	LDA !E_Header,x
	CMP #$EABF : BEQ .two				;pink kihunter
	CMP #$EB3F : BEQ .two				;green kihunter
	CMP #$EBBF : BEQ .two				;red kihunter (which doesn't freeze in the normal game but just in case)
	CMP #$D2FF : BEQ .two				;norfair bird thing
	CMP #$D33F : BEQ .two				;lower norfair bird thing
	CMP #$D2BF : BEQ .two				;lava jumping platform thing
	CMP #$E6BF : BEQ .two				;eye enemy
	CMP #$DFFF : BEQ .two				;spike platform
	CMP #$E8BF : BEQ .two				;balloon grapple buddy
	CMP #$E07F : BEQ .two				;fire plume
	CMP #$D4BF : BEQ .two				;dragooon
	CMP #$E63F : BEQ .three				;draygon's minions
	CMP #$E83F : BEQ .three				;lavaman
	CMP #$DB3F : BEQ .four				;bang
	CMP #$E5FF : BEQ .five				;dachora
	CMP #$F0F7 : BEQ .five				;fucking shaktool takes up *seven* enemies (he also doesn't freeze correctly, so this isn't useful unless he's also fixed)
   !plxy
	RTS
.seven : INY #2
.five  : INY
.four  : INY
.three : INY
.two   : INY
.delete
	TYA : BEQ +							;[Y] = number of enemy parts to delete
   %inx(#$0040)							;the extra enemies for the possessor to 'possess' are stored right after it in ram (each enemy slot is $40 bytes)
	LDA !E_Props,x : ORA #$0200			;can't TSB n,x unforunately
	STA !E_Props,x						;this property bit tells the enemy to delete itself
	DEY
	BRA .delete
	+
   !plxy
	RTS

; --- Scyzer ---
Colour_Shift:
	JSR $8D64
	PHP : STZ $16 : STZ $10 : STZ $00
	--									;checks the bts tilemap to find the instructions
	LDA $16 : TAX
	SEP #$20 : LDA $7F6402,X : BEQ ++
		ASL #5 : STA $10
		LDA $7F6403,X : ASL A : CLC : ADC $7F6403,X : TAY : REP #$20
		LDA .color_table,Y : STA $00
		LDA .color_table+1,Y : STA $01
	LDY #$0000 : LDX $10
	-
	LDA [$00],Y : STA $7EC300,X			;uses the enemy flashing palette
	INX #2 : INY #2 : CPY #$0020 : BCC -
		INC $16 : INC $16 : BRA --
	++
	PLP : RTS
.color_table
	dl $B7FFB0, $B7FFB0, $B7FF90, $B7FF70, $B7FF50, $B7FF30, $B7FF10, $B7FEF0
	dl $B7FED0, $B7FEB0, $B7FE90, $B7FE70, $B7FE50, $B7FE30, $B7FE10, $B7FDF0
	dl $B7FED0

; --- Scyzer (optimized/expanded by Quote58)
Backflip:
!FirstLift 	   = #$0000					;How many frames before the FIRST lift. 0008 = double-jump effect
!DecayOne 	   = #$0006					;How many frames until 1st vertical momentum slowdown
!DecayTwo 	   = #$0012					;How many frames until 2nd vertical momentum slowdown
!DecayThree    = #$0025					;How many frames until 3rd vertical momentum slowdown / after falling
!StartSpeed	   = #$0005					;How many pixels to boost up at the start
!LiftSpeed 	   = #$0004					;How many pixels to boost up during damage boost
!DecaySpeedOne = #$0002					;How many pixels to boost up during damage boost after 1st decay time
!DecaySpeedTwo = #$0001					;How many pixels to boost up during damage boost after 2nd decay time

;*** add check for being under liquid and distinguish between water/lava/acid ***

	LDA $18A8 : BEQ +					;if samus is in invincibility frames (hurt damage boosting)
	BRA .end
	+
	LDA $0A28 : CMP #$004F : BEQ +
				CMP #$0050 : BEQ +
	LDA $0A1C : CMP #$004F : BEQ ++
				CMP #$0050 : BEQ ++
	BRA .end
	+
	LDA #$0002 : STA !W_V_direction		;start samus moving down
	LDA #$FFFF-!StartSpeed
	BRA +++
	++
	LDA !W_H_momentum : CMP #$0002 : BMI +
	LDX !W_Ending_spark : INX
	STX !W_Ending_spark : CPX !FirstLift
	BPL +
	BRA .end
	+
	CPX !DecayThree : BPL .end
	CPX !DecayTwo	: BPL +
	CPX !DecayOne	: BPL ++
	LDA #$FFFF-!LiftSpeed	  : BRA +++
	+
	LDA #$FFFF-!DecaySpeedTwo : BRA +++
	++
	LDA #$FFFF-!DecaySpeedOne
	+++
	;JSL Vertical_check					;this is in bank $90, don't forget about that
	BRA .end
.end
	LDA $18A8
	RTS


print "End of free space (A0FFFF): ", pc









