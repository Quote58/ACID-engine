Disappearing_block:
.instr_air
	dw !InstrPlaySound2 : db !ArgBreakBlockSound
	dw $0004, $A345						;frames to show tile, tilemap to use
	dw $0004, $A34B						;animation for a block breaking
	dw $0004, $A351
	dw $0004, $A357
	dw .air_wait

.instr_solid
	dw $0005, $A351
	dw $0005, $A34B
	dw $0005, $A345
	dw $8B17							;1-frame animation with stored tile
	dw .solid_wait

.init									;Y = PLM index
!NewBlockType = $1E69

	LDA !P_Location,y
	LSR : TAX
	LDA !W_Room_bts-1,x
	SEP #$20
	LDA #$00 : STA !W_Room_bts,x
	TYX
	XBA
	REP #$20
	ASL #4
	INC : STA !P_Frame_delay,x
	LDX !P_Location,y
	LDA !W_Room_tilemap,x : BMI .set_graphic
	
	PHA
	LDA #$00FF : STA !W_Room_tilemap,x	;mimicking PLM instruction 8B17
				 STA !NewBlockType
	LDA #$0001 : STA $1E67				;usually set to 1
				 STZ $1E6B				;end value, usually 0
	LDA #$1E67
	TYX : STA !P_Tile_value,x			;new value for block under plm
	LDA #.instr_solid
	STA !P_Instr_next,y
	JSR $861E
	LDX !P_Index
	JSL !Get_PLM_XY
	JSR $8DAA
	PLA
	
	ORA #$8000							;make block initially solid
	TXY
.set_graphic
	STA !P_Respawn_value,y
	RTS

.air_wait
	LDA !P_Args,x : AND #$FF00			;get 'high' value, aka 'OffTime'
	LSR #4
	STA !P_Frame_delay,x				;once the delay is up
	TYA
	STA !P_Instr_next,x					;animate block reforming and set instructions for 'OnTime'
	PLA
	RTS

.solid_wait
	LDA !P_Args,x : AND #$00FF			;get 'low' value, aka 'OnTime'
	ASL #4
	STA !P_Frame_delay,x				;once the delay is up
	LDA #.instr_air
	STA !P_Instr_next,x					;animate block crumbling and set instructions for 'OffTime'
	PLA
	RTS