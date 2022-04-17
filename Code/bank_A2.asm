lorom

org $A2AA86 : LDA #$0090				;this is the timer for how long to wait before starting anything
org $A2AB18 : LDA #Ship_save
org $A2F498
; free space in bank $A2

; --- quote58 ---
; just fixing the ship message box stuff since the message box routines no longer do the saving within them
Ship_save:
	LDA #$0017 : JSL !Message_box : CMP #$0001 : BEQ +
	LDA $7ED8F8 : ORA #$0001 : STA $7ED8F8
	LDA #$002E : JSL $809049			;play ship saving sound <-- this stuff was originally in the message box routines themselves, which was dumb, so now it's here
	LDA #$00A0 : JSL Pause_game			;pauses game for A frames, using !Wait_for_nmi for each iteration
	LDA $7ED8F8 : ORA #$0001 : STA $7ED8F8	;this doesn't index by region because the gunship is only ever in region 0 <-change this if you change where the gunship can be
	STZ $078B							;zero the station index
	LDA !W_Save_slot : JSL !Save_game
	LDA #$0018 : JSL !Message_box		;display 'save completed'
	+
	LDA #$AB60 : STA $0FB2,x
	LDA #$0001 : STA $1014,x
	LDA #$A5BE : STA $1012,x
	LDA #$0090 : STA $0FA8
	LDA #$0014 : JSL $80914D			;play ship opening sound
	RTL

print "End of free space (A2FFFF): ",pc