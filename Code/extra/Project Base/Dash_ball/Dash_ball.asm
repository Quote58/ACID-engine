; Dash ball (Quote58)
print "Dash ball: ", pc
dw !InstrEquipInit, Dash_ball_instr


; --- Quote58 ---
incsrc Plm/Dash_ball/Dash_ball.asm

Dash_ball:
.instr
	dw !InstrTransferGfx, $9100
	dw $0000, $0000, $0000, $0000
	dw !InstrCheckItemBit, .end
	dw !InstrSetReturn,    .touch
	dw !InstrSetPreInstr,  !ArgTouchAi
.animate
	dw !InstrDrawCustom, !InstrDrawCustom2
	dw !InstrGoTo, .animate
.touch
	dw !InstrSetItemBit
	dw !InstrSoundFX : db $37
	dw $88F3, $0010  : db $1D
.end
	dw !InstrGoTo, !ArgKillPLM