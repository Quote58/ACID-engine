org $A2AAAB : STZ !W_MSG_return : JMP $AB18	;this normally refills, but since that's a message box determined function now, it goes straight to that
org $A2AB1F : JMP Ship_message

; --- Quote58 ---
Ship_message:
	LDA !W_MSG_return : CMP #$0001 : BEQ .refill
						CMP #$0003 : BEQ .refill_finished
	-
	LDA #$001B : JSL !Message_box
	CMP #$0001 : BEQ .refill
	CMP #$0002 : BEQ .exit

.save
	STZ $078B
	LDA #$002E : JSL $809049			;play ship saving sound
	LDA #$00A0 : JSL Pause_game			;pauses game for A frames, using !Wait_for_nmi for each iteration
	LDA $7ED8F8 : ORA #$0001 : STA $7ED8F8	;this doesn't index by region because the gunship is only ever in region 0 <-change this if you change where the gunship can be
	STZ $078B							;zero the station index
	LDA !W_Save_slot : JSL !Save_game
	LDA #$0018 : JSL !Message_box		;display 'save completed'
	RTL

.exit
	LDA #$AB60 : STA $0FB2,x
	LDA #$0001 : STA $1014,x
	LDA #$A5BE : STA $1012,x
	LDA #$0090 : STA $0FA8
	LDA #$0014 : JSL $80914D
	RTL

.refill_finished
	LDA #$001C : JSL !Message_box
	RTL

.refill
	LDA !C_Refill_amt : JSL !Restore_health
	LDA !C_Refill_amt : JSL !Restore_missiles
	LDA !C_Refill_amt : JSL !Restore_supers
	LDA !C_Refill_amt : JSL !Restore_powers
	LDA !W_Reserves : CMP !W_Reserves_max : BMI +
	LDA !W_Health   : CMP !W_Health_max : BMI +
	LDA !W_Missiles : CMP !W_Missiles_max : BMI +
	LDA !W_Supers   : CMP !W_Supers_max : BMI +
	LDA !W_Powers   : CMP !W_Powers_max : BMI +
	LDA #$0003 : STA !W_MSG_return
	+
	RTL