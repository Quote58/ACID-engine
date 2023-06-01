lorom

macro text_purple()
	table data/message_boxes/text_purple.txt
endmacro

macro text_yellow()
	table data/message_boxes/text_yellow.txt
endmacro

macro text_blue()
	table data/message_boxes/text_blue.txt
endmacro

macro text_green()
	table data/message_boxes/text_green.txt
endmacro

org $858080
; --- Quote58 ---
%text_purple()
Message_box:
!Blank		 = #$2CFB
!Border		 = $0A
!BorderType  = $0C
!NumTiles	 = $0E
!Tilemap	 = $10
!TilemapNext = $12
!Index 		 = $14
!NumSubs 	 = $16

   !phb
   !phxy

	JSR .get_header

	; open the box
	JSL !Pause_sounds
	JSR .init_ppu
	JSR .load_gfx
	STZ !W_MSG_return
	JSR .clear_tilemap
	JSR .init_message
	JSR .wait_2_frames
	JSR .open_message

	; handle input
	JSR .handle_input

	; close the box
	JSR .close_message
	JSR .clear_tilemap
	JSR .restore_gfx
	JSR .restore_ppu
	JSL !Resume_sounds
	JSR .wait_2_frames

	; the return value from a message box is anywhere from 0 to 3, and the vanilla game sees 0 as true and 1 as false
	LDA !W_MSG_return

.end
   !plxy
   !plb
	RTL

; ::: tables that a user might want to adjust :::
.delays									;the first entry in this table is the default delay amount (vanilla is 0168), the second is for confirmation messages (vanilla is 000A)
	dw !C_Message_normal, !C_Message_short, !C_Message_fanfare

; ::: basic game functions :::
.get_header
	DEC : ASL : STA !W_MSG_type			;message header is 6 bytes and starts at 0
	ASL : CLC : ADC !W_MSG_type			;.:. msg_type is (msg_type-1)*6
	STA !W_MSG_type
	RTS

.wait_for_nmi							;waits for the nmi signal at vblank
	PHP
	SEP #$20
	LDA !W_NMI_counter
	-
	CMP !W_NMI_counter : BEQ -
	REP #$20
	PLP
	RTS

.wait_2_frames							;uses wait_frames to wait for 2 frames
	LDX #$0002
.wait_frames							;processes any sounds in the queue while it waits the specified number of frames in X
;	SEP #$30							;leaving this here because I honestly don't remember why I included it but obviously it limits the number of frames so for now it's commented
	-
	JSR .wait_for_nmi
	PHX
	JSL !Handle_music_queue
	JSL !Handle_sounds
	PLX
	DEX : BNE -
;	REP #$30
	RTS

.update_from_vram
	LDA $2139							;gotta read the register to use something (to use what though?)
	LDA #$3981 : BRA +					;we're reading *from* vram here, need to use different settings

.update_vram							;updates vram manually based on DP memory filled before it's called
	LDA #$1801							;everything else is using the standard settings here
	+
	STA $4310
	JSR .wait_for_nmi
	LDA !dst  : STA $2116
	LDA !src  : STA $4312
	LDA !bnk  : STA $4314
	LDA !amt  : STA $4315
	STZ $4317 : STZ $4319
	SEP #$20
	LDA #$80  : STA $2115
	LDA #$02  : STA $420B
	JSL !Handle_music_queue
	JSL !Handle_sounds
	REP #$20
	RTS
; ::::::::::::::::::::::::::::

; ::: basic box functions :::
.clear_tilemap
	REP #$30
	LDX #$06FE							;size of tilemap
	LDA #$000E
	-
	STA $7E3800,x						;clear the entire thing
	DEX #2 : BPL -
	
	LDA #$5880 : STA !dst
	LDA #$3800 : STA !src
	LDA #$007E : STA !bnk
	LDA #$0700 : STA !amt
	JSR .update_vram
	RTS

.load_gfx								;loads the message box gfx depending on the option bit
	REP #$30
	LDA #$0085 : STA !bnk				;the message box gfx are stored in this same bank at the very end
	LDA #$FB00 : BRA .move_gfx

.restore_gfx							;restores original gfx, which includes the FX and whatnot
	REP #$30
	LDA !W_FX3_type : BEQ .restore_normal_fx ;if no FX present, move the normal gfx
	CMP #$0006 : BEQ .restore_normal_fx	;if the FX is water, move the normal gfx
	CMP #$000B : BPL .restore_normal_fx	;if the FX is fog, move the normal gfx
	LDA #$0087 : STA !bnk				;otherwise, it's acid, lava, rain, or spores
	LDA #$47D8 : STA !dst				;and they all go to the same place in vram
	LDA #$0050 : STA !amt				;which we need to update, because we over wrote it earlier
	LDX #$000A							;however, we don't know which gfx we need, because it's handled as animated tiles
	-
	LDA $1F3D,x : CMP #$47D8 : BEQ +	;luckily we can find out, by looking for an animated tile object that stores to vram address 45D8, where we're using
	DEX #2 : BPL -
	+
	LDA $1F0D,x : TAX					;and then using that index to get the instruction pointer
	LDA $870000,x : BPL +				;positive instruction = animation, negative instruction = looping
	DEX #4								;if we're looping, just go back by one instruction to get the previous state
	+
	LDA $870002,x : STA !src			;we can use this to find the gfx index
	JSR .update_vram					;which we can use to update the gfx
	RTS

.restore_normal_fx
	LDA #$009A : STA !bnk				;the FX gfx are stored in 9A
	LDA #$BD00

.move_gfx
	STA !src
	LDA #$4580 : STA !dst				;same amount, destination, settings, etc.
	LDA #$0500 : STA !amt
	JSR .update_vram
	RTS

.init_ppu								;backs up the screen and hdma settings, sets the fixed colour data and scrolls, and then preps the lookup table
	REP #$30
	JSR .wait_for_nmi

	;backup screen settings
	SEP #$20
	STZ !R_HDMA
	LDA #$19 : STA !R_CGRAM_addr
	LDA #$B1 : STA !R_CGRAM_clr
	LDA #$0B : STA !R_CGRAM_clr
	LDA #$1F : STA !R_CGRAM_clr
	LDA #$00 : STA !R_CGRAM_clr
	LDA !W_Active_HDMA : STA $7E33EA
	LDA $5B : STA $7E33EB
	LDA #$58 : STA $5B
	LDA #$17 : STA $6A
	STZ $70 : STZ $73

	;set fixed colour and scrolls
	LDA #$20 : STA !R_Fixed_clr
	LDA #$40 : STA !R_Fixed_clr
	LDA #$80 : STA !R_Fixed_clr
	LDA !R_BG3_H
	STZ !R_BG3_H : STZ !R_BG3_H
	LDA !R_BG3_V
	STZ !R_BG3_V : STZ !R_BG3_V
	REP #$20

	;clear the lookup table
	LDX #$0080
	LDA #$0000
	-
	STA !W_MSG_lookup,x
	DEX #2 : BPL -

	;prep the tilemap space and update vram
	JSR .wait_for_nmi
	LDA !W_Game_state : CMP #$0009 : BMI +	;if we're in the pause screen, we need to use a different space for the tilemap
	LDX #$06FE
	-
	LDA $7E3800,x : STA $7E4000,x
	DEX #2 : BPL -
	RTS

	+
	LDA #$5880 : STA !dst
	LDA #$4100 : STA !src
	LDA #$007E : STA !bnk
	LDA #$0700 : STA !amt
	JSR .update_from_vram
	RTS

.restore_ppu
	REP #$30
	JSR .wait_for_nmi

	;restore screen settings
	SEP #$20
	LDA $7E33EA : STA $85 : STA !R_HDMA
	LDA $7E33EB : STA $5B
	LDA $69 : STA $6A
	LDA $6E : STA $70
	LDA $71 : STA $73
	LDA #$19 : STA !R_CGRAM_addr
	LDA $7EC032 : STA !R_CGRAM_clr
	LDA $7EC033 : STA !R_CGRAM_clr
	LDA $7EC034 : STA !R_CGRAM_clr
	LDA $7EC035 : STA !R_CGRAM_clr
	REP #$20

	;restore FX tilemap
	LDA !W_Game_state : CMP #$0009 : BMI +
	LDX #$06FE
	-
	LDA $7E4000,x : STA $7E3800,x
	DEX #2 : BPL -
	BRA ++
	+
	LDA #$5880 : STA !dst
	LDA #$4100 : STA !src
	LDA #$007E : STA !bnk
	LDA #$0700 : STA !amt
	JSR .update_vram
	++
	RTS

.open_message
	REP #$30
	STZ !W_MSG_percent
	-
	JSR .write_hdma_table
   %inc(!W_MSG_percent, #$0200)
	CMP #$1800 : BMI -
	LDA #$1800 : STA !W_MSG_percent
	JSR .write_hdma_table
	RTS

.close_message
	REP #$30
	-
	JSR .write_hdma_table
   %dec(!W_MSG_percent, #$0200)
	BPL -
	RTS

.write_hdma_table
	PHP
	JSR .wait_for_nmi
	REP #$30
	JSL !Handle_music_queue
	JSL !Handle_sounds
	
	LDA #$7B00 : SEC : SBC !W_MSG_percent
	XBA : AND #$00FF : STA !W_MSG_top
	LDA #$0063 : STA $05AA
	
	LDA #$7C00 : CLC : ADC !W_MSG_percent
	XBA : AND #$00FF : STA !W_MSG_bottom
	LDA #$0094 : STA $05A6

	LDX #$00F6 : LDY #$00F8
	LDA #$001E : STA $14

	-
	LDA $05AA : SEC : SBC !W_MSG_top
	STA !W_MSG_lookup,x
	DEC $05AA : DEC !W_MSG_top
	DEX #2
	PHX
	TYX
	LDA $05A6 : SEC : SBC !W_MSG_bottom
	STA !W_MSG_lookup,x
	PLX
	INC $05A6 : INC !W_MSG_bottom
	INY #2
	DEC $14 : BNE -

	TYX
	LDA #$0000
	-
	STA !W_MSG_lookup,x
	INX #2 : CPX #$01E0 : BMI -
	PLP
	RTS
; ::::::::::::::::::::::::::::

; ::: functions for loading and processing the message box :::
.init_message
	REP #$30
	LDX !W_MSG_type
	LDA.w Message_box_data+2,x : STA !Border
	JSR .load_message
	JSR .handle_substitutions
	JSR .draw_border
	
	LDA !Border : BEQ +
	LDA !amt : CLC : ADC #$0080 : STA !amt
	+
	LDA !NumTiles
	SEC : SBC #$0060 : BPL +
	LDA #$0000
	+
	STA !NumTiles
	LDA #$01C0 : SEC : SBC !NumTiles
	CLC : ADC #$5800 : STA !dst

	;setup the hdma table settings
	SEP #$20
	LDA #$FF : STA $7E3380 : LDA #$00 : STA $7E3381
	LDA #$30 : STA $7E3382 : LDA #$E1 : STA $7E3383
	LDA #$FE : STA $7E3384 : LDA #$30 : STA $7E3385
	LDA #$00 : STA $7E3386
	LDA #$42 : STA $4360 : LDA #$12 : STA $4361
	LDA #$80 : STA $4362 : STA $4365
	LDA #$33 : STA $4363 : STA $4366
	LDA #$7E : STA $4364 : STA $4367
	STZ $4368 : STZ $4369 : STZ $436A
	JSR .write_hdma_table
	SEP #$20 : LDA #$40 : STA !R_HDMA : REP #$20

	;flip it all to vram
	LDA #$3200 : STA !src
	LDA #$007E : STA !bnk
	JSR .update_vram
	RTS

.load_message
	JSR .wait_for_nmi
	JSL !Handle_music_queue
	JSL !Handle_sounds
	REP #$30
	
	LDA #$0070 : STA $05A6
	LDA #$007C : STA !W_MSG_bottom
	STZ !W_MSG_percent

	LDX #$00E0
	LDA #$0000
	-
	STA !W_MSG_lookup,x
	DEX #2 : BPL -

	LDX !W_MSG_type									;tilemap = header+4
	LDA.w Message_box_data+4,x : STA !Tilemap		;size of tilemap = next tilemap - current tilemap - 2 (if substitution)
	LDA.w Message_box_data+10,x	: STA !TilemapNext	;size of dma transfer = size of tilemap + (border*2)
	LDA.w Message_box_data,x : AND #$00FF : ASL : STA !NumTiles
	LDA !TilemapNext : SEC : SBC !Tilemap : SBC !NumTiles
	LSR : STA !NumTiles : PHA
	ASL : STA !amt

	LDX #$0000
	LDA !Border : BEQ +
	LDX #$0040
	+
	STZ !Index

	LDY #$0000
	-
	LDA (!Tilemap),y : PHA
	AND #$0F00 : CMP #$0100 : BEQ .substitution
				 CMP #$0200 : BEQ .button
	PLA : BRA .store_tile

.button
	PLA : JSR .draw_button_symbol : BRA .store_tile

.substitution
	PLA
	BIT #$0001 : BEQ +++
   !phxy
	INY #2 : LDA (!Tilemap),y : BIT #$0004 : BNE ++		;function = 04
								BIT #$0002 : BNE +		;tilemap = 02
	INC !W_MSG_return
	TXA : ORA #$2000 : TAX : BRA ++	;option = 08 (MSG_return acts as a counter for how many options are in the message)
	+
	TXA : ORA #$1000 : TAX
	++
	TXA : LDX !Index : STA !W_MSG_subs,x
	INX #2 : STX !Index
   !plxy
	+++
	LDA !Blank							;for the substitution characters, we're just drawing a regular blank tile

.store_tile
	STA !W_MSG_tilemap,x
	INX #2 : INY #2
	DEC !NumTiles : BNE -
	PLA
	STA !NumTiles
	RTS

.draw_button_symbol
   !phxy
	AND #$00FF : TAX
	LDA $7E0900,x
	LDY #$0000 : BIT #$0080 : BNE +			;jump
		   INY : BIT #$8000 : BNE +			;run
		   INY : BIT #$0040 : BNE +			;shoot
		   INY : BIT #$4000 : BNE +			;cancel
		   INY : BIT #$2000 : BNE +			;select
		   INY : BIT #$0020 : BNE +			;aim down
		   INY : BIT #$0010 : BNE +			;aim up
		   INY
	+
   %asy(1)
	LDA .button_symbols,y
   !plxy
	RTS

.button_symbols
	;A (purple), B (yellow), X (blue), Y (grey), SEL (grey), L (grey), R (grey), blank
	dw $28E0, $3CE1, $2CF7, $38F8, $38D0, $38EB, $38F1, $28FB

.handle_substitutions
	LDX !W_MSG_type
	LDA.w Message_box_data,x : AND #$00FF : BEQ +++ : STA !NumSubs
	TYA : CLC : ADC !Tilemap : TAY
	LDX #$0000
	-
   !phxy
	LDA !W_MSG_subs,x : PHA
	AND #$F000 : BEQ +						;0xxx = function, don't draw a tilemap, >0xxx = tilemap or option, either way draw normally
	PLA : AND #$0FFF : STA !Index
	LDA $0000,y : TAX : JSR Message_box_method_draw_tilemap
	BRA ++
	+
	PLA : TYX
	STA !Index : JSR ($0000,x)
	++
   !plxy
	INX #2 : INY #2
	DEC !NumSubs : BNE -
	+++
	RTS

.draw_border
	LDA !Border : BNE + : RTS
	+
	LDY #$003F
	LDA (!Border),y : AND #$00FF : STA !BorderType : DEY
	-
	TYX : LDA (!Border),y : STA !W_MSG_tilemap,x
	DEY #2 : BPL -
	LDA !amt : CLC : ADC #$0040 : TAX
	LDA !BorderType : BEQ +
	INC !Border
	LDY #$0041
	-
	LDA (!Border),y : STA !W_MSG_tilemap,x
	INX #2 : INY #2
	CPY #$0081 : BMI -
	RTS

	+
	LDY #$0000
	-
	LDA (!Border),y : BIT #$8000 : BNE +
	ORA #$8000 : BRA ++
	+
	AND #$8000
	++
	STA !W_MSG_tilemap,x
	INX #2 : INY #2
	CPY #$0040 : BMI -
	RTS
; ::::::::::::::::::::::::::::

; ::: functions relating to input once the box is open :::
;
;there are a number of ways to handle the delay, but I think this is probably best
;you can make the confirmation message delay one 10th of the normal delay like vanilla
;with only a single value, which is nice for quick adjustments. However I think since it's
;only 1 extra constant to adjust, the added flexability of any message being able
;to have it's own delay timer is best long term
.handle_input
	LDX !W_MSG_type
	LDA.w Message_box_data,x : AND #$FF00	;grab the delay argument in the header
	XBA : BNE +							;if the delay index is not default (0), then just use it
	LDA !W_Item_sfx : BEQ +				;if it is the default, then check if the item sfx toggle is set to fanfare
	LDA #$0002							;if so, we're grabbing a separate fanfare delay from the table instead
	+
	ASL : TAX : LDA .delays,x : TAX
	++
	JSR .wait_frames					;wait the number of frames dictated by the delay found in the delay table
	
	LDA !W_MSG_return : BNE .handle_options

	-
	LDA !R_PPU_status					;can we check for input yet?
	BIT #$01 : BNE -
	
	SEP #$20
	LDA !R_JOY1_low  : BNE +			;a, x, l, r?
	LDA !R_JOY1_high : BEQ -			;dpad, start, select, b, y?
	+
	REP #$30

	LDA #$0037 : JSL $809049			;plays a sound
	RTS

.handle_options
!Options = $18							;total options allowed = 3, 18-1C
!NumOptions = $00
!TilePal = $0A
!YLen = $10
!XLen = $12

	LDA !W_MSG_return : DEC : STA !NumOptions
	STZ !W_MSG_return
	JSR .unpack_options
	-
	LDA !R_PPU_status					;can we check for input yet?
	BIT #$01 : BNE -
	LDA !R_JOY1_low  : BNE +			;a, x, l, r?
	LDA !R_JOY1_high : BEQ -			;dpad, start, select, b, y?
	+

	-
	JSR .wait_2_frames
	JSL !Update_input
	REP #$30
	LDA !W_Pressed : BEQ -				;if no input, check again
	BIT !C_B_A : BNE ++					;if input is confirmation, end the box
	BIT !C_B_left+!C_B_up_dup : BNE .handle_options_left
	BIT !C_B_right+!C_B_down_dup : BEQ -	;if input is not left/right, check again

.handle_options_right
	LDA !W_MSG_return : INC : CMP !NumOptions : BEQ + : BMI +
	LDA #$0000 : BRA +

.handle_options_left
	LDA !W_MSG_return : DEC : BPL +
	LDA !NumOptions
	+
	JSR .highlight_option : BRA -
	++
	RTS

.unpack_options
	LDX !W_MSG_type									;tilemap = header+4
	LDA.w Message_box_data+4,x : STA !Tilemap		;size of tilemap = next tilemap - current tilemap - 2 (if substitution)
	LDA.w Message_box_data+10,x	: STA !TilemapNext	;size of dma transfer = size of tilemap + (border*2)
	LDA.w Message_box_data,x : AND #$00FF : ASL : STA !NumTiles
	LDA !TilemapNext : SEC : SBC !Tilemap
	SBC !NumTiles : CLC : ADC !Tilemap : TAY
	LDA !NumTiles : LSR : STA !NumSubs
	LDX #$0000 : STX !Index
	-
   !phxy
	LDA !W_MSG_subs,x
	AND #$F000 : CMP #$2000 : BNE +		;0xxx = function, 1xxx = tilemap, 2xxx = option
	LDX !Index
	LDA $0000,y : STA !Options,x
	INC !Index : INC !Index
	+
   !plxy
	INX #2 : INY #2
	DEC !NumSubs : BNE -
	RTS

.highlight_option						;dehighlight everything other than the current selection, which is highlighted
	STA !W_MSG_return
	LDA !NumTiles : LSR : STA !NumSubs
	LDX #$0000 : TXY
	-
	PHX
	LDA !W_MSG_subs,x : STA !Index
	AND #$F000 : CMP #$2000 : BNE +++
	PHY
	LDA !Index : AND #$0FFF : DEC #4 : STA !Index
	TYX : LDA !Options,x : TAX
	TYA : LSR : CMP !W_MSG_return : BNE +
	JSR .draw_arrow
	LDA #$3C00 : JSR .draw_option : BRA ++
	+
	JSR .clear_arrow
	LDA #$2C00 : JSR .draw_option
	++
	PLY : INY #2
	+++
	PLX
	INX #2 : DEC !NumSubs : BNE -
	JSR .update_vram
	RTS

.draw_arrow
	PHX
	LDX !Index
	LDA #$3CCD : STA !W_MSG_tilemap,x : INX #2
	LDA #$3CCE : STA !W_MSG_tilemap,x
	BRA +

.clear_arrow
	PHX
	LDX !Index
	LDA #$2CFB : STA !W_MSG_tilemap,x : INX #2
	LDA #$2CFB : STA !W_MSG_tilemap,x
	+
	INX #2
	STX !Index
	PLX
	RTS

.draw_option
	STA !TilePal
	LDA $0000,x : AND #$00FF : STA !YLen
	LDA $0001,x : AND #$00FF : DEC : PHA
	INX #2 : TXY
	LDA !YLen : BEQ +
	DEC !YLen
	LDX !Index
	--
	PLA : STA !XLen : PHA
	-
	LDA $0000,y : AND #$E3FF
	ORA !TilePal : STA !W_MSG_tilemap,x
	INY #2 : INX #2 : DEC !XLen : BPL -
   %inc(!Index, #$0040) : TAX
	DEC !YLen : BPL --
	+
	PLA
	RTS
; ::::::::::::::::::::::::::::

; ::: functions called from substitutions :::
Message_box_method:
!YLen = $1A
!XLen = $1C
!TilePal = $18

.draw_4_digits
!Q = $1A
!R = $1C

   %divide(#$64, !Q, !R)
	LDA !Q : JSR .draw_2_digits : INX #4
	LDA !R : JSR .draw_2_digits
	RTS

.draw_3_digits
   %divide_alt(#$64)
	AND #$000F : TAY 
	LDA .digits,y : AND #$00FF : ORA !TilePal : STA !W_MSG_tilemap,x : INX #2
	LDA !R_Remainder
	
.draw_2_digits
   %divide_alt(#$0A)
	AND #$000F : TAY
	LDA .digits,y : AND #$00FF : ORA !TilePal : STA !W_MSG_tilemap,x
	LDA !R_Remainder
	
.draw_1_digit
	AND #$000F : TAY					;the number should be from 0 - 9, but we can at least prevent it from going above F with a simple AND
	LDA .digits,y : AND #$00FF : ORA !TilePal : STA !W_MSG_tilemap+2,x
	RTS
	
.digits
	db $09, $00, $01, $02, $03, $04, $05, $06, $07, $08
	db $08, $08, $08, $08, $08, $08

.draw_2_big_digits
   %divide_alt(#$0A)
	AND #$000F : TAY
	LDA .big_digits,y : AND #$00FF : ORA !TilePal : STA !W_MSG_tilemap,x
	CLC : ADC #$0010 : STA !W_MSG_tilemap+$40,x
	INX #2
	LDA !R_Remainder
.draw_big_digit
	AND #$000F : TAY
	LDA .big_digits,y : AND #$00FF : ORA !TilePal : STA !W_MSG_tilemap,x
	CLC : ADC #$0010 : STA !W_MSG_tilemap+$40,x
	RTS

.big_digits
	db $60, $61, $62, $63, $64, $65, $66, $67, $68, $69
	db $68, $68, $68, $68, $68, $68

.missile_counter
	LDX !Index
	LDA #$2C00 : STA !TilePal
	LDA !W_Missiles_max : JSR .draw_3_digits
	RTS

.super_counter
	LDX !Index
	LDA #$2C00 : STA !TilePal
	LDA !W_Supers_max : JSR .draw_2_digits
	RTS

.power_counter
	LDX !Index
	LDA #$2C00 : STA !TilePal
	LDA !W_Powers_max : JSR .draw_2_digits
	RTS

.draw_tilemap
	LDA $0000,x : AND #$00FF : STA !YLen
	LDA $0001,x : AND #$00FF : DEC : PHA
	INX #2 : TXY
	LDA !YLen : BEQ +
	DEC !YLen
	LDX !Index
	--
	PLA : STA !XLen : PHA
	-
	LDA $0000,y : STA !W_MSG_tilemap,x
	INY #2 : INX #2 : DEC !XLen : BPL -
   %inc(!Index, #$0040) : TAX
	DEC !YLen : BPL --
	+
	PLA
	RTS
; ::::::::::::::::::::::::::::

; ::: all the message box data :::
Message_box_data:
.headers
;format = db delay index, substitutions : dw border, tilemap

; ::: headers :::
	; --- vanilla headers ---
	incsrc data/message_boxes/vanilla_headers.asm
	; --- extra misc headers ---
	dw $0000, .short, .dash_ball					;1D
	; --- end of headers ---
	dw $0000, $0000,  .end

; ::: data :::
	; --- vanilla data ---
	incsrc data/message_boxes/vanilla_data.asm
	; --- extra misc data ---
.dash_ball
   %text_purple()
	dw "______#####dash#ball#####_______"
	; --- end of data ---
.end
	dw $000E

;borders
;format = dw "tilemap", XX
;by default, the top border is flipped for the bottom border, and XX = 00
;however, if a unique bottom border is needed, XX = 01
%text_purple()
.short 		 : dw "______###################_______" : db $00
.mid   		 : dw "_____#####################______" : db $00
.wide  		 : dw "___##########################___" : db $00
;.full  		 : dw "################################" : db $00
;.fancy 		 : dw "______###################_______" : db $00

;message box text tilemaps
.select
	dw $0301
	dw $28B7,$28B8,$28B9
.setitwith
	dw $0601
	dw $28BA,$28BB,$28C9,"#",$28C2,$28C3
.press
	dw $0301
	dw $28B2,$28B3,$28B4
.press_hold
	dw $0801
	dw $28B2,$28B3,$28B4,"#&#",$28B5,$28B6
.hold
	dw $0201
	dw $28B5,$28B6
.the
	dw $0301
	dw $28C4,$28C5,$28C6
.button
	dw $0401
	dw $28BC,$28BD,$28BE,$28BF
.to_run
	dw $0401
	dw $28CA,"#",$28CB,$28CC
.samus
	dw $0203
	dw $3CB0,"#"
	dw $3CC0,$3CC1
	dw $3CD0,"#"
.morphball
	dw $0101
	dw $3CD1
.arrow
	dw $0201
	dw $3CCD, $3CCE

.missile_icon
	dw $0302
	dw $3490, $3491, $7490
	dw $34A0, $34A1, $74A0
.super_icon
	dw $0202
	dw $3492, $7492
	dw $34A2, $74A2
.power_icon
	dw $0202
	dw $3493, $7493
	dw $34A3, $74A3
.grapple_icon
	dw $0202
	dw $3494, $7494
	dw $34A4, $74A4
.xray_icon
	dw $0202
	dw $3495, $7495
	dw $34A5, $74A5

%text_yellow()
.option_yes
	dw $0301
	dw "yes"
.option_save
	dw $0401
	dw "save"

%text_blue()
.option_no
	dw $0201
	dw "no"
.option_ok
	dw $0201
	dw "ok"
.option_refill
	dw $0601
	dw "refill"
.option_exit
	dw $0401
	dw "exit"
%text_purple()
; ::::::::::::::::::::::::::::

print "End of free space (85FFFF): ",pc