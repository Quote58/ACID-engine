lorom

org $A9C579 : JSR Baby_metroid_check_pose
org $A9EF92 : JSR Baby_metroid_set_event
org $A9FB70
Baby_metroid:
; --- Quote58 ---
.set_event
	LDA #$0014 : JSL !Set_event
	LDY #$F8C6
	RTS

; --- Scyzer ---
;Big metroid ??? fix
.check_pose
	STA $09C2
	LDA $0A1C : INC A : AND #$00C8 : CMP #$00C8 : BNE +
	LDA $0A1F : AND #$00FF : CMP #$001B : BNE +
		LDA $0A1C : AND #$0001 : ASL A : TAY
		LDA .table0A1C,Y : STA $0A1C
		LDA .table0A1E,Y : STA $0A1E
		LDA #$A337 : STA $0A58 
		LDA #$E913 : STA $0A60 
		LDA #$0003 : STA $0A68
		STZ $0AAE : STZ $0AB0 : STZ $0AB2
		STZ $0B2C : STZ $0B2E
	+
	RTS
	
.table0A1C : dw $002A,$0029
.table0A1E : dw $0604,$0608

print "End of free space (A9FFFF): ", pc