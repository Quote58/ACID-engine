; ::: Generic functions used by the modules :::
.draw_4_digits
!Q = $12
!R = $14

   %divide(#$64, !Q, !R)
	LDA !Q : JSR .draw_2_digits : INX #2
	LDA !R : JSR .draw_2_digits
	RTS

.draw_3_digits
   %divide_alt(#$64)
	AND #$000F : TAY 
	LDA .digits,y : AND #$00FF : ORA !TilePal : STA !W_HUD_tilemap,x : INX #2
	LDA !R_Remainder
	
.draw_2_digits
   %divide_alt(#$0A)
	AND #$000F : TAY
	LDA .digits,y : AND #$00FF : ORA !TilePal : STA !W_HUD_tilemap,x : INX #2
	LDA !R_Remainder
	
.draw_1_digit
	AND #$000F : TAY					;the number should be from 0 - 9, but we can at least prevent it from going above F with a simple AND
	LDA .digits,y : AND #$00FF : ORA !TilePal : STA !W_HUD_tilemap,x
	RTS
	
.digits
	db $09, $00, $01, $02, $03, $04, $05, $06, $07, $08
	db $08, $08, $08, $08, $08, $08		;which will give us a 9 if it's anything over what it should be. If space is an issue, remove this stuff, it's not super important

.draw_2_big_digits
   %divide_alt(#$0A)
	AND #$000F : TAY
	LDA .big_digits,y : AND #$00FF : ORA !TilePal : STA !W_HUD_tilemap,x
	CLC : ADC #$0010 : STA !W_HUD_tilemap+$40,x
	INX #2
	LDA !R_Remainder
.draw_big_digit
	AND #$000F : TAY
	LDA .big_digits,y : AND #$00FF : ORA !TilePal : STA !W_HUD_tilemap,x
	CLC : ADC #$0010 : STA !W_HUD_tilemap+$40,x
	RTS

.big_digits
	db $50, $51, $52, $53, $54, $55, $56, $57, $58, $59
	db $58, $58, $58, $58, $58, $58

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
	LDA $0000,y : STA !W_HUD_tilemap,x
	INY #2 : INX #2 : DEC !XLen : BPL -
   %inc(!Index, #$0040) : TAX
	DEC !YLen : BPL --
	+
	PLA
	RTS

; ::: Weapon select related modules :::
.toggle
	LDA $0008,x : AND #$00FF
	CMP !W_Auto_cancel_item : BNE +++
	LDA !W_Frame_counter : BIT #$0010 : BEQ +
	LDA #$1000 : BRA ++
	+
	LDA #$1400 : BRA ++
	+++
	CMP !W_HUD_select : BEQ +
	CMP !W_HUD_select_mirror : BNE .toggle_no_mirror
	LDA !W_HUD_select : STA !W_HUD_select_mirror
	LDA #$1400 : BRA ++	
	+
	LDA #$1000
	++
	STA !TilePal
	LDA $0002,x : TAX
	LDA $0000,x : AND #$00FF : STA !YLen
	LDA $0001,x : AND #$00FF : DEC : PHA
	INX #2 : TXY
	LDA !YLen : BEQ +
	DEC !YLen
	LDX !Index
	--
	PLA : STA !XLen : PHA
	-
	LDA $0000,y
	AND #$E3FF : ORA !TilePal : STA !W_HUD_tilemap,x
	INY #2 : INX #2 : DEC !XLen : BPL -
   %inc(!Index, #$0040) : TAX
	DEC !YLen : BPL --
	+
	PLA
	RTS

.toggle_no_mirror
	LDA !W_HUD_select_mirror : BNE +
	LDA !W_HUD_select : STA !W_HUD_select_mirror
	+
	RTS

; ::: Fancy input display modules :::
.draw_input_display
!Mask = $12
	LDA #$8000 : STA !Mask
	LDY #$000B
	-
	LDA .draw_input_loc,y : AND #$00FF
	CLC : ADC !Index : TAX
	LDA !W_Held : BIT !Mask : BEQ +
	LDA #$1000 : BRA ++
	+
	LDA #$1400
	++
	STA !TilePal
	LDA .draw_input_gfx,y : AND #$00FF
	ORA !TilePal : STA !W_HUD_tilemap,x
	LDA !Mask : LSR : STA !Mask
	DEY : BPL -
	RTS
	;RLXA RLDU StSeYB
.draw_input_gfx : db $7D,$7C,$6C,$6A,$5D,$5C,$5B,$5A,$7B,$7B,$6D,$6B
.draw_input_loc : db $0A,$00,$08,$4A,$44,$40,$82,$02,$86,$84,$46,$88

.draw_magic_display
	LDA !W_Items_collect : BIT !C_I_speed : BNE +
	RTS
	+
	LDA !W_Spark_timer : BEQ + : JMP .draw_magic_metre
	+
	STZ !TilePal
	LDA !W_Animation_frame : CMP #$0007 : BMI +
	LDA $0B3C : BEQ +
	LDA $8B : BIT $09B6 : BEQ +
	LDA $0A1F : AND #$00FF : CMP #$0001 : BNE +
	LDA $09A2 : BIT #$2000 : BNE ++
	+
	LDA #$1400 : STA !TilePal
	++

	LDY #$000C
	-
	TYA : CLC : ADC !Index : TAX
	LDA !W_HUD_tilemap,x : AND #$E3FF : ORA !TilePal : STA !W_HUD_tilemap,x
	DEY #2 : BPL -

	LDA !W_Move_type : AND #$00FF : CMP #$0001 : BEQ +
	RTS

	+
	LDA !TilePal : AND #$FBFF : STA !TilePal
	LDA !W_Animation_frame : AND #$000E : STA $0A : STA $0C
	LDA !W_X_direction : AND #$00FF : CMP #$0008 : BEQ +
	LDY #.left
	LDA !Index : CLC : ADC #$000C : STA !Index
	LDA #$0000 : SEC : SBC $0A : STA $0A : BRA ++
	+
	LDY #.right
	++
	LDA $0C : CMP #$0002 : BMI +
	LDA $0A : CLC : ADC !Index : CLC : ADC $0000,y : TAX
	LDA !W_HUD_tilemap,x : AND #$E3FF : ORA !TilePal : STA !W_HUD_tilemap,x
	+
	LDA $0C : CMP #$0006 : BPL +
	LDA $0A : CLC : ADC !Index : CLC : ADC $0002,y : TAX
	LDA !W_HUD_tilemap,x : AND #$E3FF : ORA !TilePal : STA !W_HUD_tilemap,x
	+
	RTS

.right : dw $FFFE, $0008
.left  : dw $0002, $FFF8

.draw_magic_metre
!Len = #$07
!Len_dup = $07
!Total = $12
!DivA = $12
!DivB = $14

	STA !DivA
	LDA !C_Full_spark : STA !DivB
	-
	LSR !DivA : LSR !DivB
	LDA !DivB : CMP #$0100 : BPL -

	LDA !DivA : %multiply(!Len)
   %divide_alt(!DivB) : STA !Total
	LDX !Index
	LDY #$0000+!Len_dup-1
	-
	LDA !Total : BMI +
	LDA #$0000 : BRA ++
	+
	LDA #$1400
	++
	STA !TilePal
	LDA !W_HUD_tilemap,x : AND #$E3FF
	ORA !TilePal : STA !W_HUD_tilemap,x
	DEC !Total
	INX #2 : DEY : BPL -
	RTS

; ::: Counter related modules :::
.health
	LDX !Index
	LDA #$2C00 : STA !TilePal
	LDA !W_Health
   %divide_alt(#$64) : LDA !R_Remainder : JSR .draw_2_digits
	RTS

.health_big
	LDX !Index
	LDA #$2C00 : STA !TilePal
	LDA !W_Health
   %divide_alt(#$64) : LDA !R_Remainder : JSR .draw_2_big_digits
	RTS

.draw_game_time
	LDX !Index
	LDA #$2C00 : STA !TilePal
	LDA !W_Time_minutes : JSR .draw_2_digits : INX #4
	LDA #$2C0C : STA !W_HUD_tilemap,x : INX #2
	LDA !W_Time_seconds : JSR .draw_2_digits : INX #4
	RTS

.draw_item_percentage
;this should use the new item percentage routine you dummy
	RTS

.draw_reserves
	LDA #$000E : BRA .draw_reserves_tilemap
.draw_reserves_small
	LDA #$000A
.draw_reserves_tilemap
!Diff = $12

	STA !Diff
	LDA !W_Reserves_type : CMP #$0001 : BNE ++
	LDA $0002,x : TAX
	LDA !W_Reserves : BEQ +
   %inx(!Diff)
	+
	JSR .draw_tilemap
	++
	RTS

.draw_counter_prep
	LDA $0007,x : AND #$FF00 : STA !TilePal
	LDA $000A,x : TAX
	LDA $7E0000,x : LDX !Index
	RTS

.draw_counter_4
	JSR .draw_counter_prep
	JSR .draw_4_digits
	RTS

.draw_counter_3
	JSR .draw_counter_prep
	JSR .draw_3_digits
	RTS
	
.draw_counter_2
	JSR .draw_counter_prep
	JSR .draw_2_digits
	RTS

; ::: etank related modules :::
.etanks_dynamic_draw
	LDA !W_Health_max : CMP #$0320 : BPL +
	JMP .etanks_draw
	+
	LDX !Index
	LDY #$0006
	-
	LDA #$000E : STA !W_HUD_tilemap,x
	INX #2 : DEY : BPL -
	JMP .etanks_small_draw

.etanks_draw
!TanksPerRow = #$0007
!Difference = $12
!Total = $16
!Current = $14
!TilePal2 = $1A
!FullTank  = #$2041
!EmptyTank = #$2040

	LDA !W_Health
   %divide_alt(#$64) : STA !Current
	LDA !W_Health_max : %divide_alt(#$64) : BEQ +++
	DEC : STA !Total
	INC : SEC : SBC !TanksPerRow : STA !Difference
	LDX !Index
	-
	LDA !Current : BEQ +
	DEC !Current : LDA !FullTank : ORA !TilePal : BRA ++
	+
	LDA !EmptyTank : ORA !TilePal2
	++
	STA !W_HUD_tilemap,x : INX #2
	LDA !Total : CMP !Difference : BNE +
	LDA !Index : SEC : SBC #$0040 : TAX
	+
	DEC !Total : BPL -
	+++
	RTS

.etanks_small_draw
!EmptyNone = #$2042
!EmptyEmpty = #$2044
!Tile = $12

	LDA !W_Health
	LDA !EmptyEmpty : ORA !TilePal : STA !Tile
	LDX !Index : LDA !W_Health_max : JSR +
	STZ !Tile : LDX !Index : LDA !W_Health
	+
   %divide_alt(#$64) : TAY
	AND #$0001 : BNE ++
	-								;even branch
	TYA : BEQ +++
	LDA !Tile : BNE +
	LDA !W_HUD_tilemap,x : INC #2
	+
	STA !W_HUD_tilemap,x
	DEY #2 : INX #2
	BRA -
	++								;odd branch
	PHX
	DEY : TYA : CLC : ADC !Index : TAX
	LDA !Tile : BNE +
	LDA !W_HUD_tilemap,x : INC : BRA ++
	+
	LDA !EmptyNone
	++
	ORA !TilePal
	STA !W_HUD_tilemap,x
	PLX : BRA -
	+++
	RTS

.etanks
	LDA #$0800 : STA !TilePal
	LDA #$3400 : STA !TilePal2
	JMP .etanks_draw

.etanks_small
	LDA #$0800 : STA !TilePal
	JMP .etanks_small_draw

.etanks_retro
	LDA #$2C00 : STA !TilePal : STA !TilePal2
	JMP .etanks_dynamic_draw

.etanks_dynamic
	LDA #$0800 : STA !TilePal
	LDA #$3400 : STA !TilePal2
	JMP .etanks_dynamic_draw

; ::: Mini-map related modules :::
.draw_mini_map
!MaxX = $12
!MaxY = $14
!LenX = $16
!LenY = $18
!Diff = $1A
!EndDiff = $1C
!MaxLen = #$0005

	LDA $0008,x : AND #$00FF : STA !MaxY
	LDA $0009,x : AND #$00FF : STA !MaxX
	LDA !W_Mini_map_mirror : CMP #$0001 : BNE .draw_mini_map_cursor
	LDA #$0000 : STA !W_Mini_map_mirror

	LDA !MaxLen : SEC : SBC !MaxX
	LSR : ASL : STA !Diff
	STZ !LenY

   %pea(7F)
	LDY !Diff
	LDX !Index
	--
	LDA !MaxX : DEC : STA !LenX
	-
	LDA.w !W_Mini_map_tiles,y : STA !W_HUD_tilemap,x
	INX #2 : INY #2
	DEC !LenX : BPL -
	TXA
	CLC : ADC #$0040
	SEC : SBC !MaxX : SBC !MaxX
	TAX
	LDA !MaxLen : SEC : SBC !MaxX : ASL : SEC : SBC !Diff
	STA !EndDiff
	TYA : CLC : ADC !Diff : ADC !EndDiff : TAY
	LDA !LenY : INC : CMP !MaxY : BEQ + : STA !LenY : BRA --
	+
	PLB

.draw_mini_map_cursor
	LDA !MaxX : LSR : ASL : STA !MaxX
	LDA !MaxY : LSR : %multiply(#$40) : CLC : ADC !MaxX
	ADC !Index : TAX
	LDA !W_HUD_tilemap,x : AND #$E3FF : PHA
	LDA !W_Frame_counter : AND #$000F : CMP #$0008 : BPL +
	PLA : ORA #$1C00 : BRA ++
	+
	PLA : ORA #$0800
	++
	STA !W_HUD_tilemap,x
	RTS

; ::: Bar related modules :::
.draw_bar
!Content = $12
!Len = $14
!Total = $12
!Final = $14
!Max = $16
!Vert = $1A

;-> content address * bar_len
;-> product / max_value, quotient = number of full tiles
;-> remainder * increment_size
;-> product / max_value, quotient = tile to use

	STA !Content : LDX !Index	
	LDY !Len : DEY
	-
	LDA !Vert : BNE + : LDA #$0088 : BRA ++
	+
	LDA #$0078
	++
	ORA !TilePal : STA !W_HUD_tilemap,x
	LDA !Vert : BNE + : INX #2 : DEY : BPL -	;one byte extra but it looks nicer
	+
   %dex(#$0040) : DEY : BPL -

	LDA !Content : %multiply(!Len)
   %divide_alt(!Max) : STA !Total
	
	LDA !R_Remainder : %multiply(#$09)
   %divide_alt(!Max) : STA !Final
	
	LDX !Index : LDY !Vert
	-
	DEC !Total : BMI ++
	LDA .draw_bar_tilemaps+8,y : AND #$00FF : ORA !TilePal : STA !W_HUD_tilemap,x
	LDA !Vert : BNE + : INX #2 : BRA -
	+
   %dex(#$0040) : BRA -

	++
	LDA !Final : BEQ + : CLC : ADC !Vert : TAY		;if the remainder is 0, don't draw anything, because it could be full
	LDA .draw_bar_tilemaps,y : AND #$00FF
	ORA !TilePal : STA !W_HUD_tilemap,x
	+
	RTS

.draw_bar_tilemaps
	db $88,$87,$86,$85,$84,$83,$82,$81,$80	;horizontal
	db $78,$77,$76,$75,$74,$73,$72,$71,$70	;vertical

.draw_health_bar
	STZ !Vert
	LDA #$0063 : STA !Max
	LDA #$0007 : STA !Len
	LDA #$2C00 : STA !TilePal
	LDA !W_Health : %divide_alt(#$64)
	LDA !R_Remainder : JSR .draw_bar
	RTS

.draw_charge_bar_prime
	LDA !Index : CLC : ADC #$0040 : STA !Index
	LDA #$0009 : STA !Vert
	LDA !C_Max_charge : STA !Max
	LDA #$0002 : STA !Len
	LDA #$2C00 : STA !TilePal
	LDA !W_Charge : JSR .draw_bar
	RTS

.draw_reserves_retro
	LDA !W_Reserves_type : CMP #$0001 : BNE ++
	INC !Index : INC !Index
	LDA #$0009 : STA !Vert
	LDA #$0001 : STA !Len
	LDA #$2800 : STA !TilePal
	LDA !W_Reserves : STA !Content
	LDA !W_Reserves_max : STA !Max
	-
	LDA !Max : CMP #$00FF : BMI +
	LSR : STA !Max
	LDA !Content : LSR : STA !Content
	BRA -
	+
	LDA !Content : JSR .draw_bar
	++
	RTS

.draw_charge_bar
!Grey = #$1400
!Green = #$1000
!Yellow = #$0000

	STZ !Vert
	LDA !C_Max_charge : STA !Max
	LDA #$0006 : STA !Len
	STZ !TilePal
	LDA !W_Charge : CMP !C_Max_charge : BEQ ++
					CMP !C_Full_charge : BPL +
	LDA !Grey : BRA +++
	+
	LDA !Green : BRA +++
	++
	LDA !Yellow
	+++
	STA !TilePal
	LDX !Index							;just making sure the charge icon thing reflects the state of the bar
	LDA !W_HUD_tilemap,x : AND #$E3FF : ORA !TilePal : STA !W_HUD_tilemap,x
	INX #2 : STX !Index
	LDA !W_Charge : JSR .draw_bar
	RTS