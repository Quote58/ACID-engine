lorom

org $8B80B4 : NOP #3				;this used to zero reserve missiles, but that ram has been repurposed now
org $8BA367 : JSR Intro_skip
org $8BE1DA : JMP Credit_screen
org $8BF71B : JSL Suit_Check
org $8BE627
; --- Quote58 --- (with change to plm collection by Scyzer)
; this overwrites the original end percentage calculation, so it doesn't need any free space
End_percent_calc:
!HundredsPos = #$339A
!Decimal	 = #$385A
!Percent     = #$386A
!Ones 		 = $06
!Tens  		 = $08
!Hundreds 	 = $0A
!Tenths 	 = $0C
!Hundredths  = $0E

   !phb
   !phxy

	LDX !C_Item_total
	LDA !W_Collected_items : JSL Get_percent_digits
	LDX !HundredsPos
	LDA !Hundreds : BEQ + : JSR .draw_digit
	+
	INX #2
	LDA !Tens 		  : JSR .draw_digit : INX #2
	LDA !Ones 		  : JSR .draw_digit : INX #2
	LDA !Decimal      : STA $7E0040,x   : INX #2
	LDA !Tenths       : JSR .draw_digit : INX #2
	LDA !Hundredths   : JSR .draw_digit : INX #2
	LDA !Percent      : STA $7E0000,x
	LDA !Percent+$10  : STA $7E0040,x

   !plxy
   !plb
	RTS

.draw_digit
	ASL #2 : TAY
	LDA $E741,y : STA $7E0000,x
	LDA $E743,y : STA $7E0040,x
	RTS

org $8BF760
; free space in bank $8B

; --- Quote58 ---
Intro_skip:
	LDX #$0010
	-
	LDA !W_Intro_state : CMP .fade_states,x : BEQ +
	DEX #2 : BMI .not_fading : BRA -
	+
	STZ !W_Can_skip_intro
	LDX #$0000
	-
	TXA : CMP #$0032 : BPL +
	LDA #$3C29 : STA $7E3646,x
	INX #2 : BRA -
	+
	BRA .end
.not_fading
	LDX #$000E
	-
	LDA !W_Intro_state : CMP .states,x : BEQ +
	DEX #2 : BMI .end : BRA -
	+
	LDA !W_Can_skip_intro : BNE .can_skip
	LDX #$0000
.clear_text
	TXA : CMP #$0032 : BPL +
	LDA #$3C29 : STA $7E3646,x
	INX #2 : BRA .clear_text
	+
	LDA !W_Pressed : BIT !C_B_X : BNE +
					 BIT !C_B_A : BNE +
					 BIT !C_B_B : BNE +
					 BIT !C_B_Y : BNE +
					 BIT !C_B_R : BNE +
					 BIT !C_B_L : BNE +
					 BIT !C_B_start : BEQ .end
	+
	LDA #$0020 : STA !W_Can_skip_intro
.draw_text
	BRA .clear_layer_1					;I know this is weird. Don't worry about it. Just move on.
.return
	LDX #$0004
	-
	LDA .palette,x : STA $7EC022,x
	DEX #2 : BMI + : BRA -
	+
	LDX #$0000
	-
	TXA : CMP #$0032 : BPL +
	LDA .text,x : STA $7E3646,x
	INX #2 : BRA -
	+
.end
	LDA $1B9F
	RTS

.can_skip
	REP #$30							;when it gets here, it's in 8bit for whatever reason
	LDA !W_Can_skip_intro : CMP #$0002 : BMI +
	DEC !W_Can_skip_intro : BRA .draw_text
	+
	LDA !W_Pressed : BIT !C_B_start : BEQ .draw_text
	STZ !W_Can_skip_intro
	LDA #$B72F : STA !W_Intro_state
	BRA .end

.clear_layer_1
	LDX $0330
	LDA #$00C0 : STA $D0,x				;amount
	LDA #.clear : STA $D2,x				;source
	LDA #$8B8B : STA $D4,x				;bank
	LDA #$5300 : STA $D5,x				;destination
	TXA : CLC : ADC #$0007
	STA $0330
	BRA .return
	
.text
	dw $300F,$3011,$3004,$3012,$3012
	dw $302F
	dw $3012,$3013,$3000,$3011,$3013
	dw $302F
	dw $3013,$300E
	dw $302F
	dw $3012,$300A,$3008,$300F
	dw $302F
	dw $3008,$300D,$3013,$3011,$300E
	dw $3025,$302F

.palette
	db $FF,$7F,$00,$00,$4A,$29

	db $00,$00,$E0,$03,$18,$63,$40,$03,$E0,$3B,$E0,$03,$18,$63,$80,$02
	db $80,$26,$E0,$03,$18,$63,$00,$02,$80,$15,$E0,$03,$18,$63,$60,$01
	
.states
	dw $A391,$AEB8,$AF6C,$B0F2,$B123,$B1DA,$A390

.fade_states
	dw $B250,$B35F,$B370,$B2D2,$B381,$B392,$B3F4,$B458

.clear
	rep 96 : dw $2D00
	
; --- Scyzer ---
Suit_Check:
	LDA !W_Items_equip : BIT #$0020 : BNE .G
						 BIT #$0001 : BNE .V
	.P	LDX #$941E : BRA .D
	.V	LDX #$953E : BRA .D
	.G	LDX #$981E
	.D	LDA #$9B00 : STA $13 : STX $12	;pallete to use is in X
	LDX #$001E							;loop through the palette line
	-	LDA [$12] : STA $7EC040,X : STA $7EC1C0,X
		DEC $12 : DEC $12				;storing to the palette lines used by ending cutscene
		DEX #2 : BPL -
	SEP #$20 : STZ $69
	RTL

; --- Jathys (modified and expanded by Quote58) ---
Credit_screen:
!DisplayTime = #$01A0

.special_thanks
	LDY #Credit_sheet_data_special_thanks
	JSR .store_tilemap
	JSR .prep_end
	LDA #.programming_credits : STA !W_Intro_state
	STZ $0D9C
	RTS

.programming_credits
	DEC !W_Cutscene_timer : BEQ +
	RTS
	+
	LDY #Credit_sheet_data_programming_credits
	JSR .store_tilemap
	JSR .prep_end
	LDA #.tester_credits : STA !W_Intro_state
	STZ $0D9C
	RTS

.tester_credits
	DEC !W_Cutscene_timer : BEQ +
	RTS
	+
	LDY #Credit_sheet_data_tester_credits
	JSR .store_tilemap
	JSR .prep_end
	LDA #.exit : STA !W_Intro_state
	STZ $0D9C
	RTS

.exit
	DEC !W_Cutscene_timer : BEQ .end
	RTS
.end
	LDX #$0000
	LDA #$004F							;blank out tilemap in prep for NINTENDO screen
	-
	STA !W_MSG_lookup,x
	INX #2 : CPX #$06E0
	BMI -
	LDA #$007F							;timer for the screen after this one
	JMP $E1DD

.store_tilemap
   %pea(E4)
	LDX #$0000
	-
	LDA $0000,y : STA !W_MSG_lookup,x 	;message boxes also use this space for their tilemap, which is used more so I named it that way
	INX #2 : INY #2 : CPX #$06E0
	BMI -
	PLB
	RTS
	
.prep_end
	JSR $8806
	SEP #$20
	LDA #$01 : STA $69 : STZ $6B
	STZ $6F : STZ $72
	REP #$20
	LDA !DisplayTime : STA !W_Cutscene_timer
	RTS


print "End of free space (8BFFFF): ",pc





















