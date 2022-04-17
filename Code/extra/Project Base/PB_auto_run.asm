org $908542 : JSR Auto_run
org $909781 : JSR Auto_run
org $909786 : JMP Auto_run_air

; --- Quote58 ---
Auto_run:
	PHA
	LDA !C_O_Auto_run : JSL Check_option_bit : BCC +
	PLA : LDA #$0001
	RTS
	+
	PLA : BIT !W_B_run
	RTS

.air
	LDA !C_O_Auto_run : JSL Check_option_bit : BCC +
	JMP $9789
	+
	JMP $9808