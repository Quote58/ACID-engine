; --- DSO ---
;this makes elevators move faster
org $A395B0 : dw $03
org $A395EC : dw $03
org $A395D2 : dw $03
org $A39581								;no free space is used because it over writes the old code
	STZ $0799							;elevator's current direction
	LDA !W_Game_state : CMP #$0008 : BNE +
	LDA !E_Ypos,x
	CLC : ADC #$0003 : STA !E_Ypos,x
	+
	INC !E_Ypos,x : NOP