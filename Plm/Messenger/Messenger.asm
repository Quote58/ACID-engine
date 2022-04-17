Messenger:
.instr
	dw .show_message

.init
   !phxy
	TYX
	LDA !P_Args,x : AND #$FF00			;the high byte of this plm acts as the event bit for the individual message
	CMP #$FF00 : BEQ +
	XBA
	JSL Check_event_extra : BCC +		;if not FF, check the event bit in the extra event bits array
	LDA #$0000 : STA !P_Headers,x		;if the bit is set, delete the plm
	+
	LDA #$0001 : STA !P_Frame_delay,x	;otherwise, set up the frame delay (maybe not needed?) and let the plm run
   !plxy
	RTS

.show_message
   !phxy
   
	LDA #$0001 : STA !P_Frame_delay,x	;since we need the instruction list to continue being used, it needs a frame delay
	
	TXY
	LDX !P_Index
	JSR Samus_PLM_contact : BCC .end	;this just checks if samus is touching the plm square
	LDA !P_Args,y : AND #$00FF			;if she touches it, grab the message box index from the low byte of the plm arugments
	JSL !Message_box					;spawn the message box
	LDA !P_Args,y : AND #$FF00
	CMP #$FF00 : BEQ +
	XBA : JSL Set_event_extra			;if the plm is not supposed to return, set it's event bit in the extra event bits array
	+
	LDA #$0000 : STA !P_Headers,y		;and delete the plm to free space
.end
   !plxy
	PLA
	RTS