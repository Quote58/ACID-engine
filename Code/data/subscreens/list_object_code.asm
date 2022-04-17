; --- Quote58 ---
Pause:
.bit_size 	   		 : dw $0000, $0010, $0040
.digits 	   		 : dw $3804, $3805, $3806, $3807, $3808, $3809, $380A, $380B, $380C, $380D
.digits_sprite 		 : dw $000E, $000F, $0010, $0011, $0012, $0013, $0014, $0015, $0016, $0017
.small_digits_sprite : dw $0020, $0021, $0022, $0023, $0024, $0025, $0026, $0027, $0028, $0029
					   ;dw $002A, $002B, $002C, $002D, $002E, $002F

.update_tilemap
	LDX !W_D0_stack
	LDA #$0500 : STA $D0,x
	LDA #$3900 : STA $D2,x
	LDA #$007E : STA $D4,x
	LDA #$3080 : STA $D5,x
	TXA : CLC : ADC #$0007
	STA !W_D0_stack
	RTS

.get_suit_type
	LDX #$0004							;!Palette_index is not updated during the pause screen, so we have to go through the checks
	LDA !W_Items_equip
	BIT !C_I_gravity : BNE + : DEX #2
	BIT !C_I_varia   : BNE + : DEX #2
	+
	RTS

.draw_cycler							;[A = address of cycler value, Y = location of table of pointers for tilemaps, X = index on screen]
!Tiles = $02

	ASL : STA !Tiles
   %iny(!Tiles) : LDA $0000,y : TAY
	LDA #$0003 : STA !Size
	STZ !TilePal
	JSR Pause_draw_tiles
	RTS

.draw_scroll_bar
!Len = $02
!Max = $04
!Total = $02
!Final = $04
!Xpos = $06
!Ypos = $08
;the scroll bar is basically constructed like a bar
;where the length of the bar is the size of the window, the content is the pos, and the max is the total number of entries

	LDA !W_Pause_list : JSR .get_header
	LDA !S_Type,x : BEQ + : RTS
	+
	LDA !S_Window_e,x : SEC : SBC !S_Window_s,x : STA !Len
	LDA !S_Size,x : AND #$00FF : STA !Max
	LDA !S_Sprite_pos,x : AND #$FF00 : XBA : CLC : ADC #$0070 : STA !Xpos
	LDA !S_Sprite_pos,x : AND #$00FF : STA !Ypos

	LDA !W_Pause_entry : %multiply(!Len)
   %divide_alt(!Max) : ASL #3 : STA !Total
	LDA !R_Remainder : ADC !Total : ADC !Ypos : TAY
	LDX !Xpos
	LDA #$0E00 : STA $03
	LDA #$002F : JSL Draw_pause_sprite_extra

	RTS

.draw_cursor
!Entry = $02
!WSize = $04
!Diff  = $06
!LenAb = $08

	LDA !W_Pause_list : JSR .get_header
	LDA !S_Sprite_type,x : AND #$00FF : PHA
	LDA !W_Pause_entry : STA !Entry
	LDA !S_Type,x : BNE +++
	JSR .len_absolute
	LDA !S_Window_e,x : SEC : SBC !S_Window_s,x : STA !WSize
	LDA !S_Window_e,x : CMP !LenAb : BMI +
	SEC : SBC !LenAb : BRA ++
	+
	LDA !LenAb : SEC : SBC !S_Window_e,x
	++
	STA !Diff
	LDA !WSize : SEC : SBC !Diff
	STA !Entry
	+++
	LDA !S_Sprite_type,x : AND #$FF00 : XBA
	CLC : ADC #$0008 : %multiply(!Entry)
	CLC : ADC !S_Sprite_pos,x
	PHA : AND #$FF00 : XBA : TAX
	PLA : AND #$00FF : TAY
	LDA #$0600 : STA $03
	PLA : JSL !Draw_pause_sprite
	RTS

.draw_tiles
   !phxy
	LDA !Size : PHA
	-
	LDA $0000,y : ORA !TilePal : STA $7E0000,x
	INX #2 : INY #2 : DEC !Size : BPL -
	PLA : STA !Size
   !plxy
	RTS

.draw_3_digits_sprite
   %divide_alt(#$64) : BEQ +
	JSR .draw_digit_sprite
	+
   %inx(#$0008)
	LDA !R_Remainder
	
.draw_2_digits_sprite
   %divide_alt(#$0A) : JSR .draw_digit_sprite : %inx(#$0008)
	LDA !R_Remainder
	
.draw_digit_sprite
   !phxy
	PHY : ASL : TAY : LDA .digits_sprite,y
	PLY : JSL Draw_pause_sprite_extra
   !plxy
	RTS

.draw_small_digits
   %divide_alt(#$0A) : BEQ +
	DEX #3 : JSR .draw_small_digit : INX #5
	+
	LDA !R_Remainder
.draw_small_digit
   !phxy
	PHY : ASL : TAY : LDA .small_digits_sprite,y
	PLY : JSL Draw_pause_sprite_extra
   !plxy
	RTS

.draw_3_digits
   %divide_alt(#$64) : BNE +
	LDA #$0000 : STA $7E0000,x : INX #2 : BRA ++
	+
	ASL : TAY
	LDA .digits,y : STA $7E0000,x : INX #2
	++
	LDA !R_Remainder
	
.draw_2_digits
   %divide_alt(#$0A) : ASL : TAY
	LDA .digits,y : STA $7E0000,x
	LDA !R_Remainder : ASL : TAY

.draw_digit
	LDA .digits,y : STA $7E0002,x
	RTS

.draw
!Bits 	= $02
!Tiles 	= $04
!LenMax = $06
!Len	= $08
!WStart = $0A
!WEnd	= $0C
!PScreen = $0E

	LDX !W_Pause_header
	LDA !S_Type,x : BEQ + : RTS
	+
	LDA !W_Pause_screen : ASL : STA !PScreen
	LDA !S_Size,x
	PHA : AND #$00FF : INC : STA !LenMax
	PLA : AND #$FF00 : XBA : STA !Size
	LDA !S_Tilemaps,x : STA !Tiles
	LDA !S_Bits,x : STA !Bits
	LDA !S_Window_e,x : INC : STA !WEnd
	LDA !S_Window_s,x : STA !WStart
	LDA !S_Tile_pos,x : TAX
	STZ !Len
	
.draw_next
	LDA !Len : CMP !WStart : BMI .draw_skip
			   CMP !WEnd : BPL .draw_skip
	STZ !TilePal
	LDY !PScreen : PHX
	LDA (!Bits) : AND #$00FF : CLC : ADC .bit_size,y : JSL Check_pause_bit : BCS +
	LDY !Size : INY
	-
	LDA #$0000 : STA $7E0000,x
	INX #2 : DEY : BPL -
	LDA !PScreen : CMP #$0004 : BMI ++
	LDA #$0000 : STA $7E0004,x
				 STA $7E0006,x
				 STA $7E0008,x
	BRA ++
	+
	TXY
	LDX !PScreen : JSR (.draw_flurish,x)
	LDY !Tiles : LDA $0000,y : TAY
	INX #2 : JSR Pause_draw_tiles
	++
	PLX
   %inx(#$0040)
   
.draw_skip
	INC !Tiles : INC !Tiles : INC !Bits
	LDA !Len : INC : CMP !LenMax : BEQ +
	STA !Len : BRA .draw_next
	+
	RTS
	
.draw_flurish
	dw $0000, .flurish_equip, $0000

.flurish_equip
	TYX
	LDA (!Bits) : AND #$00FF : JSL Check_pause_bit : BCS +
	LDA #$0C00 : STA !TilePal
	+
	LDA #$08E0 : ORA !TilePal : STA $7E0000,x
	RTS
	

; ::: initialize the list object :::
.get_header
   %multiply(#$14) : STA !W_Pause_header : TAX
	RTS

.init_all									;A: total number of lists on a given screen
	TAY										;this routine uses the Y register because DP ram is used in init and draw
	-
	PHY : TYA : JSR .init : JSR .draw
	PLY : DEY : BPL -
	RTS
	
.draw_all
	TAY
	-
	PHY : TYA : JSR .get_header : JSR .draw
	PLY : DEY : BPL -
	RTS

.init										;A: !W_Pause_list, Return: length of object
!List = $02
!Header = $04

	PHA : ASL : STA !List					;pause list is used to index the list from init_screen
	PLA : JSR .get_header
	LDA !W_Pause_screen : ASL : TAY
	LDA .init_screen,y : CLC : ADC !List : TAY
	LDA $0000,y : STA !Header : TAY
	LDA $0000,y : AND #$00FF
	STA !S_Type,x : ASL : TAX
	JSR (.init_type,x)
	JSR .get_len
	RTS

.init_screen
	dw $0000, Equip_lists, Options_lists, $0000

.init_type
	dw .init_list, .init_widget

.init_list
!MaxLen = $02

	LDX !W_Pause_header
	LDA $0001,y : PHA : AND #$00FF : STA !MaxLen
	LDA $0003,y : AND #$00FF : XBA : STA !S_Size,x
	LDA $0004,y : STA !S_Tile_pos,x
	LDA $0006,y : STA !S_Sprite_pos,x
	LDA $0008,y : STA !S_Dir,x
	LDA $000A,y : AND #$00FF : STA !S_Sprite_type,x
	LDA !Header : CLC : ADC #$000B : STA !S_Bits,x
			 ADC !MaxLen : INC : STA !S_Tilemaps,x
	PLA : AND #$FF00 : XBA : STA !S_Window_e,x
				LDA #$0000 : STA !S_Window_s,x
	LDA !S_Size,x : CLC : ADC !MaxLen : STA !S_Size,x
	RTS
	
.init_widget
	LDX !W_Pause_header
	LDA $0001,y : CMP #$8000 : BMI +
	TYA : INC
	+
	STA !S_Size,x
	LDA $0003,y : STA !S_Dir,x
	LDA $0005,y : STA !S_Sprite_pos,x
	LDA $0007,y : STA !S_Sprite_type,x
	LDA !Header : CLC : ADC #$0009 : STA !S_Bits,x
	RTS

.get_len
   !phxy
	LDX !W_Pause_header
	LDA !S_Type,x : ASL : TAX
	JSR (.len_type,x)
   !plxy
	LDA !W_Pause_len
	RTS
	
.len_type
	dw .len_bit_list, .len_widget
	
.len_bit_list
!Bits  = $02
!Len   = $04
!Max   = $06
!LenAb = $08

	LDX !W_Pause_header
	LDA !S_Bits,x : STA !Bits
	LDA !S_Size,x : AND #$00FF : STA !Len : STA !Max
	STZ !W_Pause_len
	-
	LDA !W_Pause_screen : ASL : TAX
	LDA (!Bits) : AND #$00FF : CLC : ADC .bit_size,x
	JSL Check_pause_bit : BCC ++
	LDA !W_Pause_len : CMP !W_Pause_entry : BNE +
	LDA !Max : SEC : SBC !Len : STA !LenAb
	+
	INC !W_Pause_len
	++
	INC !Bits : DEC !Len : BPL -
	RTS

.len_absolute
   !phxy
	JSR .len_bit_list
   !plxy
	LDA !LenAb
	RTS

.len_widget
	LDX !W_Pause_header
	LDA !S_Size,x : BEQ + : BPL +
	TAX : JSR ($0000,x)
	+
	STA !W_Pause_len
	RTS

;length over-ride routines go here
.len_reserves
	LDA !W_Reserves_type : BEQ +				;this actually should sort of never happen, but because SMILE doesn't take into account not using the original equipment screen code, we need to ensure this case is accounted for
	LDA !W_Reserves_max : BEQ +
	LDA !W_Reserves_type
	+
	RTS
; :::

; ::: handle all input :::
Pause_input:
!Down  = #$0F00
!Up    = #$F000
!Left  = #$00F0
!Right = #$000F

	LDA !W_Pause_list : JSR Pause_get_header
	LDA !W_Pressed : CMP !W_Pressed_prev : BEQ ++
	AND #$0F00 : BEQ + : CMP !C_B_right : BEQ .right
						 CMP !C_B_left : BEQ .left
						 CMP !C_B_down : BEQ .down
						 CMP !C_B_up : BEQ .up
	RTS
	+
	LDA !W_Pressed : AND #$00F0 : CMP !C_B_A : BNE +
	JSR .select
	+
	RTS

.right
	LDA !S_Dir,x : AND !Right : BRA +

.left
	LDA !S_Dir,x : AND !Left : LSR #4
	+
	CMP #$000F : BNE .lr
	RTS

.down
	JSR Pause_get_len : BEQ + : DEC
	+
	CMP !W_Pause_entry : BEQ .down_move
	INC !W_Pause_entry
	JSR .move_window_down
	BRA .success
.down_move
	LDA !S_Dir,x : AND !Down : XBA
	JSR .move : BCC ++
	LDA !S_Type,x : BNE +
	LDA #$0001 : JSR .find_real_entry : BRA .success
	+
	STZ !W_Pause_entry : BRA .success
	++
	RTS

.up
	LDA !W_Pause_entry : BEQ .up_move
	DEC !W_Pause_entry
	JSR .move_window_up
	BRA .success
.up_move
	LDA !S_Dir,x : AND !Up : XBA : LSR #4
	JSR .move : BCC ++
	LDA !S_Type,x : BNE +
	LDA #$0000 : JSR .find_real_entry : BRA .success
	+
	JSR Pause_len_widget : BEQ + : DEC
	+
	STA !W_Pause_entry : BRA .success
	++
	RTS

.success
	LDA #$0037 : JSL $809049
	RTS

.lr
!LenAb = $08

	PHA
	JSR .move : BCS +
	PLA : PHA : JSR Pause_get_header
	LDA !C_B_up : STA !W_Pressed : JSR .up_move : BCS +
	PLA : PHA : JSR Pause_get_header
	LDA !C_B_down : STA !W_Pressed : JSR .down_move : BCS +
	PLA
	CLC
	RTS
	+
	PLA
	LDX !W_Pause_header
	STZ !W_Pause_entry
	LDA !S_Type,x : BNE .success
	LDA #$0001 : JSR .find_real_entry
	BRA .success

.move
	JSR .check_list : BCC +
	STA !W_Pause_list : JSR Pause_get_header
	SEC
	RTS
	+
	CLC
	RTS

.find_real_entry
!BitSize = $02
!Bits = $04
!End = $06

	STA !End
	STZ !W_Pause_entry
	LDA !S_Bits,x : STA !Bits
	LDA !W_Pause_screen : ASL : TAY
	LDA Pause_bit_size,y : STA !BitSize
	LDY #$0000
	-
	LDA (!Bits) : AND #$00FF : CLC : ADC !BitSize : JSL Check_pause_bit : BCC +
	INC !W_Pause_entry
	LDA !End : BEQ +
	TYA : CMP !S_Window_s,x : BPL ++
	+
	INC !Bits
	INY : TYA : CMP !S_Window_e,x : BEQ - : BMI -
	++
	LDA !W_Pause_entry : BEQ +
	DEC !W_Pause_entry
	+
	RTS

.check_list
!NewList = $14
!Temp = $16

	STA !NewList
	--
	CMP #$000F : BEQ .dead_end
	JSR Pause_get_header : JSR Pause_get_len : BNE .available_list
	LDA !W_Pressed : AND #$0F00 : XBA : LSR : ASL : TAX
	LDA .dir_list,x : STA !Temp
	LDX !W_Pause_header : LDA !S_Dir,x : AND !Temp
	JSR .keep_moving
	BRA --
	
.dir_list
	dw !Right, !Left, !Down, $0000, !Up

.keep_moving
	LDX #$0003
	-
	CMP #$8000 : BPL +					;we're looking for something between 0 - 10, so BMI will only be useful after making sure it's not negative
	CMP #$0010 : BMI ++
	+
	LSR #4 : DEX : BPL -
	BRA .dead_end
	++
	STA !NewList
	RTS
	
.available_list
	LDA !NewList
	SEC
	RTS
	
.dead_end
	LDA !W_Pause_list
	CLC
	RTS

.move_window_up
!LenAb = $08
!Diff = $02

	JSR Pause_len_absolute
	LDA !S_Window_s,x : CMP !LenAb : BEQ + : BPL +
	RTS
	+
	SEC : SBC !LenAb
	++
	STA !Diff
	LDA !S_Window_s,x : SEC : SBC !Diff : STA !S_Window_s,x
	LDA !S_Window_e,x : SEC : SBC !Diff : STA !S_Window_e,x
	RTS
	
.move_window_down
	JSR Pause_len_absolute
	LDA !LenAb : CMP !S_Window_e,x : BEQ + : BPL +
	RTS
	+
	SEC : SBC !S_Window_e,x
	++
	STA !Diff
	LDA !S_Window_s,x : CLC : ADC !Diff : STA !S_Window_s,x
	LDA !S_Window_e,x : CLC : ADC !Diff : STA !S_Window_e,x
	RTS

; --- pressing the confirm button on a list item will turn it on or off ---
.select
!BitValue = $02

	LDA !S_Type,x : BNE .select_widget
	JSR Pause_len_absolute
	CLC : ADC !S_Bits,x : STA !BitValue
	LDA (!BitValue) : AND #$00FF
	STA !BitValue : JSL Check_pause_bit : BCC +
	LDA !BitValue : JSL Clear_pause_bit : BRA ++
	+
	LDA !BitValue : JSL Set_pause_bit
	++
	LDA !W_Pause_screen : ASL : TAX
	LDA .select_conflicts,x : BEQ +
	JSR (.select_conflicts,x)
	+
	JMP .success

.select_conflicts
	dw $0000, Equip_screen_item_conflicts, $0000, $0000, $0000
	
.select_widget
	LDA !W_Pause_entry : ASL
	CLC : ADC !S_Bits,x : TAX
	JSR ($0000,x)
	JMP .success

; ::: widget functions :::
Pause_widget:
.switch_reserves_type
	LDA !W_Reserves_type : CMP #$0001 : BEQ +
	LDA #$0001 : BRA ++
	+
	LDA #$0002
	++
	STA !W_Reserves_type
	JSL Hud_init							;this should be init_specific but iirc there was an issue doing that so for now it's just a full init to clear the tiles
	RTS

.refill_reserves
	LDA #$0001 : STA !W_Reserves_refill
	RTS

.hyper_beam
.none
	RTS