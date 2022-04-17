; --- Quote58 ---
org $8DC5CF : JSR Palette_obj_del
org $8DC591 : JSR Palette_obj_main_end
org $8DFFF1
; free space in bank $8D

Palette_obj:
.main_end : JSL Load_samus_palette_heat_glow : RTS
.del : JSL Samus_electrifying : RTS


; insert this routine in bank 80 free space
; --- Quote58 ---
Samus_electrifying:
	LDA !W_Pal_obj_index,x				;if the palette obj being deleted is the samus-being-electrified one, then update the palette before we leave
	STZ !W_Pal_obj_index,x : CMP #$E1F4 : BEQ +
							 CMP #$E1F8 : BEQ +
							 CMP #$E1FC : BNE ++
	+
   !phxy : JSL !Update_palette : !plxy
	++
	RTL

org $91DE53								;Clean up for blue suit/speed echoes/speed counter
   !phb
	LDA $0B3C : BEQ +					;this is where the check speed counter address is actually used
	STZ $0B3C
	STZ !W_Speed_counter
	STZ $0ACE							;1 if running with speed booster?
	STZ $0AD0							;0 if running with speed booster?
	LDA #$0001 : STA !W_Cannon_reset	;we're ending speed booster, so use the beam coloured arm cannon
	JSL !Update_palette					;saves 32 bytes because redundant code is redundant
	STZ !W_Cannon_reset					;this is the only time cannon reset needs to not be zero
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

; insert this stuff in bank 91 free space
; --- Quote58 (concept by Black Falcon) ---
Load_samus_palette:
!Power 	 = $CC60
!Wave 	 = $CC68
!Ice 	 = $CC70
!Spazer  = $CC78
!Plasma  = $CE60
!CPower  = $D060
!CWave 	 = $D068
!CIce 	 = $D070
!CSpazer = $D078
!CPlasma = $D0E0

	JSR .sort_out_palette
	PHY
	TXY : LDX #$0100
	BRA +

.target
	JSR .sort_out_palette
	PHY
	TXY : LDX #$0300
	+
	JSR .store_normal_palette
	PLY
	JSR .store_cannon_palette
	RTS

.store_normal_palette
   %pea(9B)								;this routine could be done with a MVN, but the cannon palette needs to be stored after it <--this isn't accurate I'm pretty sure. MVN should stop the cpu until it's done
	LDA $0000,y : STA $7EC080,x			;which means it can't take any extra time which the code is running (ie. can't DMA before the cannon palette is stored)
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
	RTS

.store_cannon_palette
   %pea(9B)
	LDA !W_Game_state : CMP #$001E : BEQ +
	LDA $00 : BEQ +
	LDA $0000,y : STA $7EC08A,x
	LDA $0002,y : STA $7EC08E,x
	LDA $0004,y : STA $7EC090,x
	LDA $0006,y : STA $7EC09A,x
	+
	PLB
	RTS

.heat_glow
	STA $1EBD,x							;increasing the palette fx object list pointer by 4

	LDA !W_Pal_obj_index,x : CMP #$F761 : BNE +	;heat glow (and also tourian something?)
   !phxy
   
	JSR .sort_out_palette
	LDA $00 : PHA
	LDA !W_Heat_glow_index : %multiply(#$20) : STA $00
	LDA !W_Beams_equip : AND #$0FFF : ASL A : TAX
	LDA .beam_type,x : CLC : ADC $00 : TAY
	PLA : STA $00
	
	LDX #$0100 : JSR .store_cannon_palette
	LDX #$0300 : JSR .store_cannon_palette

   !plxy
	+
	RTL

.sort_out_palette
	PHX
	LDX $1E7B : LDA !W_Pal_obj_index,x : CMP #$E1F4 : BEQ .end	;pal object for electrifying samus when loading power suit
										 CMP #$E1F8 : BEQ .end  ; || varia suit
										 CMP #$E1FC : BEQ .end  ; || gravity suit
	LDA !W_Game_state : CMP #$0007 : BEQ .end
	LDA !C_O_Cannon_tint : JSL Check_option_bit : BCC .end
	LDA !W_Hyper_beam : BNE .end			;check if hyper beam is active
	LDA !W_Hurt_flash : BEQ + : CMP #$0007 : BPL + ;check for normal hurt flash
	BIT #$0001 : BNE .end				;on odd frames, samus is normal suit colours, and should update her arm cannon, on even frames she's all white (#$A380)
	+
	LDA !W_Cannon_reset  : BNE +		;check for just ending speed booster
	LDA !W_Echoes_active : BNE .end		;check for speed booster
	LDA !W_Morph_flash   : BNE .end		;morph flash
	LDA !W_Charge : CMP !C_Full_charge	;charge beam
	BPL .charge_beam
	LDA !W_Current_pose					;check for screw attacking <--this should probably have an AND #$00FF, but space
			  CMP #$0081 : BEQ .end		;right
			  CMP #$0082 : BEQ .end		;left
	LDA !W_Spark_timer   : BNE .end		;and shinesparking
	LDA !W_Spark_pal     : BNE .end
	+
	LDA !W_Beams_equip : AND #$0FFF		;else find the current beam

.get_cannon_palette
	ASL A : TAY
	LDA .beam_type,y : TAY				;get the right offset
	LDA #$0001 : STA $00				;and tell the other routine to swap the palette
	PLX
	RTS

.end
	STZ $00
	PLX
	RTS

.charge_beam
	JSL Is_spinning : BCS .end
	LDA !W_Charge_index : TAX
	LDA .charge_indexes,x : %multiply(#$20) : STA $00
	LDA !W_Beams_equip : AND #$0FFF
	ASL A : TAX
	LDA .beam_type_charge,x
	ADC $00 : TAY
	LDA #$0001 : STA $00
	PLX
	RTS

.charge_indexes
	dw $0000, $0001, $0002, $0003, $0002, $0001

.beam_type
	dw !Power							;0 power
	dw !Wave							;1 wave
	dw !Ice								;2 ice
	dw !Ice								;3 ice + wave
	dw !Spazer							;4 spazer
	dw !Wave							;5 spazer + wave
	dw !Ice								;6 spazer + ice
	dw !Ice								;7 spazer + wave + ice
	dw !Plasma							;8 plasma
	dw !Plasma							;9 plasma + wave
	dw !Ice								;A plasma + ice
	dw !Ice								;B plasma + wave + ice

.beam_type_charge
	dw !CPower							;0 power
	dw !CWave							;1 wave
	dw !CIce							;2 ice
	dw !CIce							;3 ice + wave
	dw !CSpazer							;4 spazer
	dw !CWave							;5 spazer + wave
	dw !CIce							;6 spazer + ice
	dw !CIce							;7 spazer + wave + ice
	dw !CPlasma							;8 plasma
	dw !CPlasma							;9 plasma + wave
	dw !CIce							;A plasma + ice
	dw !CIce							;B plasma + wave + ice
