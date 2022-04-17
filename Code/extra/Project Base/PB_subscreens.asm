
; Code for the subscreen states
; insert into space in bank 82, under the Subscreen: label
; or reference it with Subscreen_ if placed elsewhere

; ***remember to put the stats screen part bank in here***
.button_config_screen : dw .button_config_load, .button_config_in, .button_config, .button_config_out

; ::: Button Config Screen handling routines :::
.button_config_load
	REP #$20
	JSR Subscreen_tilemap_transfer_button_config
	JSR .setup_misc
	JSL Button_config_screen_init
	INC !W_Pause_index
	RTS
.button_config_in
	LDA #$0001 : BRA .button_config_end
.button_config
	JSR .input_start
	JSL Button_config_screen_main
	RTS
.button_config_out
	LDA #$0002
.button_config_end
	STA !W_Pause_fade
	JSL Button_config_screen_draw_sprites
	RTS

; put this in transfer_misc_gfx
	SEP #$30								;transfer the hud gfx (this works differently because kraid is a sonofabitch)
	LDA #$00 : STA !R_VRAM_low
	LDA #$40 : STA !R_VRAM_high
	LDA #$80 : STA !R_VPORT
	JSL HDMA_Transfer_alt
	db $01, $01, $18
	LDA #$02 : STA !R_DMA
	REP #$30

; Code for map/equip/options subscreens
; insert into free space in bank 87 (where it says to put inidividual subscreen code)

; --- Quote58 ---
; ::: Map Screen :::
Map_screen:
.draw_sprites
   !phb
	LDA !C_O_Time_attack : JSL Check_pause_bit : BCC +
	LDA #$0E00 : STA $03
	JSR .draw_timer
	JSR .draw_percent
	JSR .draw_tanks
	+
   !plb
	RTL

.draw_item_dots
	;this should only have the current regions x/y coordinates you idiot
	LDA !W_Item_dots : AND #$FF00 : XBA : STA $09C6 : ASL #3 : SEC : SBC !W_BG1_X : TAX
	LDA !W_Item_dots : AND #$00FF : STA $09CA : ASL #3 : SEC : SBC !W_BG1_Y : DEC : TAY
	LDA #$002E : JSL Draw_pause_sprite_extra
	RTS

.draw_tanks
!Ypos = $06
!Xpos = $08
!Index = $0A

	LDA !W_Region : %multiply(#$05) : STA !Index
	LDA #$0030 : STA !Ypos : LDA #$0014 : STA !Xpos
	JSR .draw_tank_number
	JSR .draw_tank_number
	JSR .draw_tank_number
	JSR .draw_tank_number
	JSR .draw_tank_number
	LDY #$0030 : LDX #$0009
	LDA #$001C : JSL Draw_pause_sprite_extra
	RTS

.draw_tank_number
	LDA #$0000 : LDX !Index
	SEP #$30 : LDA !W_Collected_tanks,x : REP #$30
	PHA
	LDY !Ypos : LDX !Xpos
	JSR Pause_draw_small_digits
	
	LDY !Ypos
	PLA : CMP #$000A : BMI +
	LDA !Xpos : CLC : ADC #$0007 : BRA ++
	+
	LDA !Xpos : CLC : ADC #$0006
	++
	TAX
	LDA #$002A : JSL Draw_pause_sprite_extra
	
	LDA #$0000 : LDX !Index
	SEP #$30 : LDA .tank_totals,x : REP #$30
	PHA : LDY !Ypos
	CMP #$000A : BMI +
	LDA !Xpos : CLC : ADC #$000D : BRA ++
	+
	LDA !Xpos : CLC : ADC #$000A
	++
	TAX
	PLA : JSR Pause_draw_small_digits

	LDX !Index
	LDA #$0000
	SEP #$30 : LDA .tank_totals,x : CMP !W_Collected_tanks,x : BNE +
	REP #$30
	LDY !Ypos : LDX #$0006
	LDA #$001D : JSL Draw_pause_sprite_extra
	+
	REP #$30
	
   %inc(!Ypos, #$0009)
	INC !Index
	RTS

.tank_totals
	db !C_Tanks_E_C, !C_Tanks_R_C, !C_Tanks_M_C, !C_Tanks_S_C, !C_Tanks_P_C
	db !C_Tanks_E_B, !C_Tanks_R_B, !C_Tanks_M_B, !C_Tanks_S_B, !C_Tanks_P_B
	db !C_Tanks_E_N, !C_Tanks_R_N, !C_Tanks_M_N, !C_Tanks_S_N, !C_Tanks_P_N
	db !C_Tanks_E_W, !C_Tanks_R_W, !C_Tanks_M_W, !C_Tanks_S_W, !C_Tanks_P_W
	db !C_Tanks_E_M, !C_Tanks_R_M, !C_Tanks_M_M, !C_Tanks_S_M, !C_Tanks_P_M
	db !C_Tanks_E_T, !C_Tanks_R_T, !C_Tanks_M_T, !C_Tanks_S_T, !C_Tanks_P_T
	db $00, $00, $00, $00, $00			;debug area just in case it's used in a hack
	
.draw_timer
	LDY #$00B8 : LDX #$0008
	LDA #$0019 : JSL Draw_pause_sprite_extra
	LDY #$00B8 : LDX #$0014
	LDA !W_Time_hours : JSR .draw_digits : JSR .draw_colon
	LDA !W_Time_minutes : JSR .draw_digits : JSR .draw_colon
	LDA !W_Time_seconds : JSR .draw_digits
	LDY #$00B8 : LDX #$0008
	LDA #$001E : JSL Draw_pause_sprite_extra
	RTS

.draw_digits
	JSR Pause_draw_2_digits_sprite : %inx(#$0008)
	RTS
	
.draw_colon
   !phxy
	LDA #$0018 : JSL Draw_pause_sprite_extra
   !plxy : %inx(#$0008)
	RTS

.draw_percent
!Ones 		 = $06
!Tens  		 = $08
!Hundreds 	 = $0A
!Tenths 	 = $0C
!Hundredths  = $0E

	LDX !C_Item_total
	LDA !W_Collected_items : JSL Get_percent_digits
	LDX #$00C0 : LDY #$002F
	LDA !Hundreds : BEQ +
	JSR Pause_draw_digit_sprite
	+
   %inx(#$0008)
	LDA !Tens : JSR Pause_draw_digit_sprite : %inx(#$0008)
	LDA !Ones : JSR Pause_draw_digit_sprite : %inx(#$0008)
   !phxy : LDA #$001A : JSL Draw_pause_sprite_extra
   !plxy : %inx(#$0008)
	LDA !Tenths : JSR Pause_draw_digit_sprite : %inx(#$0008)
	LDA !Hundredths : JSR Pause_draw_digit_sprite : %inx(#$0008)
	LDA #$001B : JSL Draw_pause_sprite_extra
	LDX #$00C2 : LDY #$002F
	LDA #$001F : JSL Draw_pause_sprite_extra
	RTS




; ::: Button Config Screen :::
Button_config_screen:
.init
   !phb
	LDA #$0001 : JSR Pause_init_all
	BRA .end
.main
   !phb
	LDA !W_Pressed : BEQ .end : AND #$0F00 : BNE +
	JSR .handle_input : BRA .end
	+
	JSR Pause_input		;if the movement is up/down/left/right, go to the normal input handler
.end
	JSL .draw_sprites
	JSR Pause_update_tilemap
   !plb
	RTL

.handle_input
	LDX !W_Pause_header
	LDA !W_Pause_entry : ASL
	CLC : ADC !S_Bits,x : TAX
	LDA !W_Pressed : JSR ($0000,x) : BCC +
	LDA #$0037 : JSL $809049
	+
	RTS

.draw_sprites
   !phb
	JSR Pause_draw_cursor
	LDA #$0000 : JSR Pause_get_header
	LDX #$000C
	--
	LDA $09B2,x : LDY #$000C
	-
	CMP .controller_bits,y : BEQ +
	DEY #2 : BMI ++ : BRA -
	+
   !phxy
	TXA : CMP #$000A : BMI +
	TYA : CMP #$0009 : BPL +
	LDY #$000E
	+
	LDA .controller_sprites,y : PHA
	JSR .draw_buttons_get_sprite
	PLA
	PHA
   !phxy
	AND #$FF00 : XBA : BEQ + : JSL Draw_pause_sprite_extra
	+
   !plxy
	PLA
	AND #$00FF : JSL Draw_pause_sprite_extra
   !plxy
	++
	DEX #2 : BPL --
	LDA !W_Pause_list : JSR Pause_get_header
   !plb
	RTL
	
.draw_buttons_get_sprite
	TXY : LDX !W_Pause_header
	LDA !S_Sprite_type,x : AND #$FF00 : XBA
	CLC : ADC #$0008 : STA $03
	TYA : LSR : %multiply($03)
	LDA !S_Sprite_pos,x : AND #$00FF
   %sbc(#$000D) : %adc(!R_Product) : TAY
	LDA !S_Sprite_pos,x : AND #$FF00 : XBA
   %adc(#$0068) : TAX
	LDA #$0E00 : STA $03
	RTS
	
.controller_bits
	dw !C_B_X, !C_B_A, !C_B_B, !C_B_Y, !C_B_select, !C_B_L, !C_B_R
	
.controller_sprites
	dw $0408, $0406, $0407, $0409, $000C, $050A, $050B, $000D


; ::: Stats Screen :::
Stats_screen:
.init
   !phb
	BRA .end
.main
   !phb
	LDA !W_Pressed : BEQ .end
	LDA #$0002 : STA !W_Pause_screen_tar
	INC !W_Pause_index
	;JSR Subscreen_tilemap_transfer_buttons
.end
	JSR Pause_update_tilemap
   !plb
	RTL


; ::: Options Screen :::
Options_screen:
!GameplayList 	  = #$0000
!SFXList		  = #$0001
!MiscList		  = #$0002
!VFXList		  = #$0003
!ItemSFX		  = #$0004

.init
   !phb
	LDA !ItemSFX : JSR Pause_init_all
	JSR .draw_sfx
	BRA .end
	
.main
   !phb
	JSR Pause_input
	LDA !ItemSFX : JSR Pause_draw_all

.end
	JSL .draw_sprites
	JSR .draw_cyclers
	JSR Pause_update_tilemap
   !plb
	RTL

.draw_cyclers
	LDY.w #Options_tilemaps_default_cycle : LDX #$3CB2
	LDA !W_Pause_default : JSR Pause_draw_cycler
	LDY.w #Options_tilemaps_hud_cycle : LDX #$3CF2
	LDA !W_Hud_type : JSR Pause_draw_cycler
	LDY.w #Options_tilemaps_item_cycle : LDX #$3B32
	LDA !W_Item_sfx : JSR Pause_draw_cycler
	RTS

.draw_sprites
   !phb
	JSR Pause_draw_cursor
	JSR Pause_draw_button_labels
	JSR Pause_draw_scroll_bar
   !plb
	RTL

.draw_sfx
	JSR .draw_sound
	JSR .draw_music
	RTS
	
.draw_sound
	LDX #$0030 : LDA !C_O_Soundfx_toggle : BRA .draw_sfx_icon
.draw_music
	LDX #$00B0 : LDA !C_O_Music_toggle
.draw_sfx_icon
	LDY #$28EE
	JSL Check_pause_bit : BCS +
	INY
	+
	TYA : STA $7E3A00,x : CLC : ADC #$0010 : STA $7E3A40,x
	RTS



Equip_screen:
!ReservesList = #$0000
!BeamsList    = #$0001
!SuitsList    = #$0002
!BombList	  = #$0003
!MiscList     = #$0004
!BootsList    = #$0005
!HyperList	  = #$0006						;hyper list needs to be the last entry, otherwise you can't use Pause_init_all or Pause_draw_all, since they are sequential

.init
   !phb
	LDA #$0002 : STA !W_Subscreen_samus		;this tells the game the update the samus model gfx
	JSR .update_samus_gfx					;but it needs to happen twice, once on each frame, because it's too much gfx to move in a single vblank
	
	LDA #$0000 : STA !W_Reserves_refill
	LDA !BootsList : JSR Pause_init_all
	
	LDA #$FFFF : STA !W_Pause_list
	LDY !BootsList
	-
	PHY
	TYA : JSR Pause_get_header : JSR Pause_get_len : BEQ +
	TYA : STA !W_Pause_list
	+
	PLY
	DEY : BPL -
	BRA .end

.main
   !phb
	LDA !W_Pause_list : CMP #$FFFF : BEQ .end_alt
	JSR .reserves_refill : BCC .end
	JSR Pause_input
	LDA !BootsList : JSR Pause_draw_all

.end
	JSL .draw_sprites
	JSR .reserve_tanks
	JSR .draw_bombs
.end_alt
	LDA !W_Hyper_beam : BEQ +
	JSR .draw_hyper_beam
	+
	JSR .update_samus_model
	JSR .update_pal
	JSR .update_samus_gfx
	JSR Pause_update_tilemap
   !plb
	RTL

.draw_sprites
   !phb
	LDA !W_Pause_list : BMI ++
	JSR Pause_get_header
	LDA !S_Sprite_pos,x : AND #$00FF : TAY
	LDA !S_Sprite_pos,x : AND #$FF00 : XBA : TAX : PHX
	LDA #$0E00 : STA $03
	LDX !W_Pause_list : LDA .line_from_list,x : PLX
	AND #$00FF : CMP #$00FF : BEQ +		;unfortunately we can't just do XBA : BMI + because the negative flag isn't affected by AND/XBA, but *is* affected by PLX
	JSL Draw_pause_sprite_extra
	+
	JSR Pause_draw_cursor
	JSR Pause_draw_button_labels
	++
   !plb
	RTL

.line_from_list
	db $FF, $00, $FF, $01, $02, $03, $FF

.reserves_refill
	LDA !W_Reserves_refill : BEQ ++
	LDA !W_Pressed : AND !C_B_B : BNE +
	JSL Game_state_reserve_tank_refill : BCC +++
	+
	LDA #$0000 : STA !W_Reserves_refill : STZ !W_Pause_entry
	++
	SEC
	RTS
	+++
	CLC
	RTS

.update_samus_gfx
	LDA !W_Subscreen_samus : BEQ +++
	PHA : JSR Pause_get_suit_type : PLA
				CMP #$0002 : BMI +
	LDA .update_gfx_src,x : STA !src
	LDA #$1400 : STA !dst
	DEC !W_Subscreen_samus
	BRA ++
	+
	LDA .update_gfx_src,x : CLC : ADC #$0C00 : STA !src
	LDA #$1A00 : STA !dst
	DEC !W_Subscreen_samus
	++
	LDA #$0C00 : STA !amt
	LDA #$00E4 : STA !bnk
	JSL VRAM_DMA
	+++
	RTS

.update_gfx_src
	dw !GFX_Equip_SM, !GFX_Equip_SM+$1800, !GFX_Equip_SM+$3000

.draw_hyper_beam
	LDA #$0003 : STA !Size
	LDX #$3BCA : LDA #$08E0 : STA $7E0000,x : INX #2
	LDY #Item_tilemaps_hyper : JSR Pause_draw_tiles
	RTS

.item_conflicts
!BitValue = $02

	LDA !BitValue : CMP !BitVaria : BEQ +++
					CMP !BitGravity : BEQ +++
					CMP !BitPlasma : BNE +
	LDA !BitSpazer : BRA ++
	+
	CMP !BitSpazer : BNE +
	LDA !BitPlasma
	++
	JSL Clear_pause_bit
	+
	RTS
	+++
	LDA #$0002 : STA !W_Subscreen_samus
	RTS

.draw_bombs
	LDA !W_Items_collect : AND !C_I_bombs : BEQ +
	LDA #$0002 : STA !Size : STZ !TilePal
	LDX #$3D08 : LDY.w #Item_tilemaps_timer : JSR Pause_draw_tiles
	LDX #$3D0E : LDY.w #Item_tilemaps_bomb_timer_cycle
	LDA !W_Bomb_timer : JSR Pause_draw_cycler
	LDA !W_Beams_collect : AND !C_I_charge : BEQ +
	LDX #$3D48 : LDY.w #Item_tilemaps_mode : JSR Pause_draw_tiles
	LDX #$3D4E : LDY.w #Item_tilemaps_bomb_mode_cycle
	LDA !W_Bomb_mode : JSR Pause_draw_cycler
	+
	RTS

.reserve_tanks
!TankFull  = #$0A3E
!TankEmpty = #$0A37
!TankEnd   = #$0A3F
!TankEndShell = #$0A34
!TankShell = #$0A35
!TanksX	   = #$3A86
!FTanks    = $14
!Remains   = $16
!ETanks	   = $18
!ArrowType = $18

	LDA !W_Reserves_max : BEQ +
	JSR .adjust_palette
	JSR .draw_tilemaps
	JSR .draw_counters
	+
	RTS
	
.adjust_palette
	LDA !W_Pause_list : CMP !ReservesList : BNE +
	LDA !W_Pause_entry : BEQ +
	LDA #$0010 : BRA ++
	+
	LDA #$0000
	++
	STA !ArrowType
	LDY #$000E
	-
	LDX .arrow_pos,y
	LDA .arrow_tiles,y : CLC : ADC !ArrowType : STA $7E0000,x
	DEY #2 : BPL -
	RTS
	
.arrow_tiles : dw $3A20,$3A21,$1A21,$1A21,$1A21,$1A21,$1A22,$1A23
.arrow_pos   : dw $3902,$3942,$3982,$39C2,$3A02,$3A42,$3A82,$3A84
	
.draw_counters
	LDX #$3A48 : LDA !W_Reserves : JSR Pause_draw_3_digits
	LDX #$3A4E : LDA #$380E : STA $7E0000,x : INX #2
	LDA !W_Reserves_max : JSR Pause_draw_3_digits
	RTS		
	
.draw_tilemaps
	LDA #$0002 : STA !Size : STZ !TilePal
	LDX #$3A08 : LDY.w #Item_tilemaps_mode : JSR Pause_draw_tiles
	
	LDY.w #Item_tilemaps_reserve_cycle : LDX #$3A0E
	LDA !W_Reserves_type : DEC : JSR Pause_draw_cycler		;reserves_type is 0 if no reserves, and 1/2 if there are
	
	LDA #$0000+!C_Reserves_total : STA !Size
	LDX !TanksX : LDY.w #$0007-!C_Reserves_total*2+#Item_tilemaps_shells
	JSR Pause_draw_tiles
	
	LDA !W_Reserves : %divide_alt(#$64) : STA !FTanks
	LDA !R_Remainder : %divide_alt(#$0A) : STA !Remains
	LDA !W_Reserves_max : %divide_alt(#$64) : STA !ETanks
	
	LDX !TanksX
	PHX : LDY !TankEmpty : LDA !ETanks : JSR .draw_tanks
	PLX : LDY !TankFull : LDA !FTanks : JSR .draw_tanks
	LDA !Remains : BEQ +
	ASL : TAY : LDA .tank_tilemaps,y : STA $7E0000,x
	+
	LDA !ETanks : SEC : SBC !FTanks : ASL : STA !ETanks
	TXA : CLC : ADC !ETanks : TAX
	LDA $7E0000,x : CMP !TankShell : BEQ +
	LDA !TankEnd : BRA ++
	+
	LDA !TankEndShell
	++
	STA $7E0000,x
	RTS
	
.draw_tanks
	-
	BEQ + : PHA
	TYA : STA $7E0000,x : INX #2
	PLA : DEC : BPL -
	+
	RTS

.tank_tilemaps : dw $0A37,$0A38,$0A38,$0A39,$0A3A,$0A3B,$0A3C,$0A3D,$0A3E,$0A3E

Equip_screen_update_pal:
!PalLine1 = 4							;lines 0-3 and 5-6 (7 is not used in vanilla) are used by the equip screen (8+ are only for sprites) but 4 is seemingly unused by anything
!PalLine2 = 7							;this is where the arm cannon palette will be stored, allowing us to change the inner lines without affecting the rest
!PalSrc   = #$9B00						;equip screen samus palette is in the same bank as all of samus' palette lines
!PalAddr  = $02
!PalBank  = $03
!Power    = $D060
!Wave 	  = $D068
!Ice 	  = $D070
!Spazer   = $D078
!Plasma   = $D0E0

   !phxy
	JSR Pause_get_suit_type
	LDA	!PalSrc 	  : STA !PalBank	;this is to form the 3 byte pointer to her palette (?? 00 bank_byte)
	LDA .suit_index,X : STA !PalAddr	;(xx yy bank_byte)
	
	LDY #$001E							;you can't lda [$00],x and you can't sta $000000,y, so we have to use both registers
	-
	TYX									;but that doesn't mean we need load or dec from both, when they're the same indexes
	LDA [!PalAddr],y : STA !PalLine1*32+$7EC000,x		;$C*$20 = $180 + 7EC000 = 7EC180
					   STA !PalLine2*32+$7EC000,x
	DEY #2 : BPL -
	
	JSR .arm_cannon
	JSR .hyper
	
   !plxy
	RTS

.suit_index
	dw $9400,$9520,$9800
	
.arm_cannon
	LDA !W_Beams_equip : AND #$0FFF
	ASL A : TAY
   %pea(90)
	LDA Beam_palette_pointers,y : TAY
	LDA $0004,y : STA $7EC0F2
	LDA $0006,y : STA $7EC0FC
	LDA $0008,y : STA $7EC0FE
	PLB
	RTS	

.hyper
	LDA !W_Hyper_beam : BEQ +
	JSL Get_hyper_index
   %pea(8D)
	LDA $D906,y : STA $7EC0F2
	LDA $D900,y : STA $7EC0FC
	LDA $D902,y : STA $7EC0FE
	PLB
	+
	RTS
	
Equip_screen_update_samus_model:
!NumBytes      = $12
!NumLines      = $14
!ModifyTilemap = $02
!SuitTilemap   = $02
!SuitBank	   = $04

	JSR Pause_get_suit_type
	LDA .suits,x : STA !SuitTilemap
	LDA #$00E4 : STA !SuitBank
	LDA #$000F : STA !NumLines
	LDY #$0000 : LDX #$01D6
.line_loop
	LDA #$0008 : STA !NumBytes			 ;there are 7 tiles per line
.tile_loop
	LDA [!SuitTilemap],y : STA $7E3842,x ;this loads the tilemap into it's temporary position in wram
	INX #2 : INY #2
	DEC !NumBytes : BNE .tile_loop

   %inx(#$0030)							 ;after each line, we need to add $30 bytes to get to the start of the next line
	DEC !NumLines : BNE .line_loop
	
	JSR .items
	JSR .cannon
	JSR .hyper_beam
	RTS

.hyper_beam
	LDA !W_Hyper_beam : BEQ +
	LDA #Equip_samus_modifier_charge : JSR .modify_tiles
	+
	RTS

.items
	LDX #$0006
	-
	PHX
	LDA .item_bits,x : JSL Check_pause_bit : BCC +
	LDA .item_tilemaps,x : JSR .modify_tiles
	+
	PLX
	DEX #2 : BPL -
	RTS

.item_bits : dw !BitCharge, !BitHijump, !BitSpace, !BitSpeed
.item_tilemaps : dw #Equip_samus_modifier_charge, #Equip_samus_modifier_hijump, #Equip_samus_modifier_spacejump, #Equip_samus_modifier_speed

.cannon
	LDA !W_HUD_select : BEQ +++				;if no weapon currently selected, normal cannon end
		   CMP #$0005 : BEQ +++				;if xray, normal end
		   CMP #$0003 : BEQ +++				;if power bombs, normal end
	LDA !W_Beams_equip : BIT !C_I_charge : BEQ +
	LDA #Equip_samus_modifier_cannon_charge : BRA ++
	+
	LDA #Equip_samus_modifier_cannon
	++
	JSR .modify_tiles
	+++
	RTS

.modify_tiles
!NumTiles  = $12
!NumGroups = $14

	STA !ModifyTilemap
	
   %pea(E4)
	
	LDA (!ModifyTilemap) : AND #$00FF : STA !NumGroups
	LDY #$0001							;grab the number of tiles for the first group
	--									;loop for the number of groups there are
	LDA !NumGroups : BEQ ++				;number of tiles to replace -> X, first tile value -> Y
	LDA (!ModifyTilemap),y : AND #$00FF : STA !NumTiles : INY
	LDA (!ModifyTilemap),y : TAX : INY #2
	-
	LDA !NumTiles : BEQ +				;loop over all the tiles, increasing the index to match
	LDA (!ModifyTilemap),y : STA $7E39D8,x
	INY #2 : INX #2
	DEC !NumTiles
	BRA -
	+
	DEC !NumGroups
	BRA --
	++
	PLB
	RTS

.suits
	dw Equip_samus_tilemaps_power, Equip_samus_tilemaps_varia, Equip_samus_tilemaps_gravity	






; ::: List object tables :::

; ::: Button Config screen :::
Button_config_lists: dw Button_list, Reset_list
; ---
Button_list:   %widget($0007, $FFF1, $1F42, $0814)
	.fun	  : dw Pause_widget_bshot, Pause_widget_bjump, Pause_widget_bdash, Pause_widget_bselect, Pause_widget_bcancel
				dw Pause_widget_bangleup, Pause_widget_bangledown

Reset_list:	   %widget($0003, $FF0F, $AF42, $0814)
	.fun	  : dw Pause_widget_reset_buttons, Pause_widget_default_buttons, Pause_widget_bend

; ::: Equip Screen :::
Equip_lists:   dw Reserves_list, Beam_list, Bomb_list, Suits_list, Misc_list, Boots_list, Hyper_list
; ---
Reserves_list: %widget(Pause_len_reserves, $F1F3, $1A42, $0014)
	.fun		dw Pause_widget_switch_reserves_type, Pause_widget_refill_reserves
	
Hyper_list:    %widget($0000, $02F4, $377B, $0014)
	.fun		dw Pause_widget_hyper_beam
	
Beam_list:	   %list($0404, $03, $3B4A, $376B, $02F4, $15)
	.bits	  : db !BitCharge, !BitIce, !BitWave, !BitSpazer, !BitPlasma
	.tilemaps : dw Item_tilemaps_charge, Item_tilemaps_ice, Item_tilemaps_wave, Item_tilemaps_spazer, Item_tilemaps_plasma

Misc_list:	   %list($0404, $07, $3B2A, $CB63, $351F, $16)
	.bits	  : db !BitMorph, !BitBombs, !BitSpring, !BitDash, !BitScrew
	.tilemaps : dw Item_tilemaps_morph, Item_tilemaps_bombs, Item_tilemaps_spring, Item_tilemaps_dash, Item_tilemaps_screw

Suits_list:	   %list($0101, $07, $3A2A, $CB43, $F40F, $16)
	.bits	  : db !BitVaria, !BitGravity
	.tilemaps : dw Item_tilemaps_varia, Item_tilemaps_gravity

Boots_list:	   %list($0202, $07, $3CEA, $CB9B, $4F2F, $16)
	.bits	  : db !BitHijump, !BitSpace, !BitSpeed
	.tilemaps : dw Item_tilemaps_hi_jump, Item_tilemaps_space_jump, Item_tilemaps_speed_booster

Bomb_list:	   %widget(Pause_len_bombs, $1FF5, $1AA2, $0014)
	.fun		dw Pause_widget_switch_bomb_timer, Pause_widget_switch_bomb_mode

; ::: Options screen :::
Options_lists: dw Gameplay_list, Sfx_list, Edit_list, Vfx_list, Item_sfx_list
; ---
Sfx_list:	   %widget($0002, $F402, $AB47, $0814)
	.fun		dw Pause_widget_switch_sfx, Pause_widget_switch_music

Item_sfx_list: %widget($0001, $1202, $AB64, $0014)
	.fun		dw Pause_widget_switch_item_sfx
	
Edit_list:	   %widget($0005, $4F31, $AB83, $0014)
	.fun		dw Pause_widget_buttons_config, Pause_widget_view_stats, Pause_widget_switch_default_screen, Pause_widget_switch_hud_type
				dw Pause_widget_save_settings
	
Gameplay_list: %list($050B, $08, $3A06, $1B43, $F331, $14)
	.bits 	  : db !C_O_Auto_morph, !C_O_Low_health, !C_O_Keep_speed, !C_O_Quick_booster, !C_O_Auto_run, !C_O_Backflip, !C_O_Respin, !C_O_Quickmorph
				db !C_O_Spark_exit, !C_O_Moon_walk, !C_O_Upspin, !C_O_Auto_save
	.tilemaps : dw Options_tilemaps_auto_morph, Options_tilemaps_low_health, Options_tilemaps_keep_speed, Options_tilemaps_quick_booster, Options_tilemaps_auto_run
				dw Options_tilemaps_backflip, Options_tilemaps_respin, Options_tilemaps_quickmorph, Options_tilemaps_shinespark_exit, Options_tilemaps_moon_walk
				dw Options_tilemaps_upspin, Options_tilemaps_auto_save

Vfx_list:	   %list($040A, $08, $3C46, $1B8B, $0F02, $14)
	.bits	  : db !C_O_Beam_flicker, !C_O_Beam_trails, !C_O_Screen_shake, !C_O_Morph_flash, !C_O_Cannon_tint, !C_O_Speed_echoes, !C_O_Flip_echoes, !C_O_Time_attack
				db !C_O_Clear_msg, !C_O_Screw_glow, !C_O_Spin_complex
				dw Options_tilemaps_beam_flicker, Options_tilemaps_beam_trails, Options_tilemaps_screen_shake, Options_tilemaps_morph_flash
				dw Options_tilemaps_cannon_tint, Options_tilemaps_speed_echoes, Options_tilemaps_flip_echoes, Options_tilemaps_time_attack
				dw Options_tilemaps_clear_msg, Options_tilemaps_screw_glow, Options_tilemaps_spin_complex

; ::: Tilemaps for list options and other stuff :::
Options_tilemaps:
incsrc code/data/subscreens/options_screen/options_list_tilemaps.asm




; ::: Changes/Additions to the base object handling code :::
.draw_button_labels
	LDA !W_Pause_list : JSR .get_header
	LDA !S_Type,x : BNE +++				;if the list is a widget list, don't draw the 'more info' button sprite
	JSR Pause_len_absolute
	CLC : ADC !S_Bits,x : STA !BitValue
	LDA (!BitValue) : AND #$00FF : TAY
	LDA !W_Pause_screen : CMP #$0002 : BEQ ++
	CPY #$0010 : BMI +
	TYA : SEC : SBC #$0010 : TAY
	+
	LDA .input_message_equip_table,y : BRA $03
	++
	LDA .input_message_options_table,y
	AND #$00FF : BEQ +++
	LDA #$0E00 : STA $03
	LDX #$00B7 : LDY #$00AF : LDA #$0008 : JSL Draw_pause_sprite_extra
	LDX #$00C5 : LDY #$00B7 : LDA #$0030 : JSL Draw_pause_sprite_extra
	+++
	RTS


.flurish_options
	TYX
	LDA (!Bits) : AND #$00FF : JSL Check_pause_bit : BCS +
	LDY #Options_tilemaps_off : BRA ++
	+
	LDY #Options_tilemaps_on
	++
	LDA $0000,y : STA $7E0016,x
	LDA $0002,y : STA $7E0018,x
	LDA $0004,y : STA $7E001A,x
	LDA #$28E7 	: STA $7E0000,x
	RTS

.len_bombs
	LDA !W_Items_collect : AND !C_I_bombs : BNE +
	LDA #$0000 : RTS
	+
	LDA #$0001 : RTS							;there's only one bomb mode currently so the mode part isn't being used

;	LDA !W_Beams_collect : AND !C_I_charge : BEQ +
;	LDA #$0002 : RTS
;	+
;	LDA #$0001 : RTS


Pause_input:
; --- pressing the message button (X) will spawn a message box for the item ---
.message
!BitValue = $02

	LDA !S_Type,x : BNE +++
	JSR Pause_len_absolute
	CLC : ADC !S_Bits,x : STA !BitValue
	LDA (!BitValue) : AND #$00FF : TAY
	LDA !W_Pause_screen : CMP #$0002 : BEQ ++
	CPY #$0010 : BMI +
	TYA : SEC : SBC #$0010 : TAY
	+
	LDA .message_equip_table,y : BRA $03
	++
	LDA .message_options_table,y
	AND #$00FF : BEQ +++
	JSL Message_box
	+++
	RTS

.message_options_table
;automorph, beam flicker, beam trails, morph flash, spark exit, low health altert, screen shake
;keep speed, quick booster, autorun, N/A, backflip, respin, quickmorph
;N/A, cannon tint, time attack, moonwalk, upspin, N/A, speed echoes
;N/A, auto save, clear msg boxes, screw attack glow
	db $23,$24,$25,$26,$27,$28,$29
	db $2A,$2B,$2C,$00,$2D,$2E,$2F
	db $00,$30,$31,$32,$33,$00,$34
	db $00,$35,$36,$37,$00

.message_equip_table
;varia, spring, morph, screw, dash, grav, N/A, N/A, hijump, space,
;N/A, N/A, bomb, speed, grapple, xray, wave, ice, spazer, plasma
;N/A, N/A, N/A, N/A, N/A, N/A, N/A, N/A, charge
	db $38,$39,$3A,$3B,$3C,$3D,$00,$00,$3E,$3F
	db $00,$00,$40,$41,$05,$06,$42,$43,$44,$45
	db $00,$00,$00,$00,$00,$00,$00,$00,$46



Pause_widget:
.switch_default_screen : %mod(!W_Pause_default, #$0002) : RTS
.switch_hud_type	   : %mod(!W_Hud_type, #$0007) : JSL Hud_init : JSL $90A91B : RTS
.switch_bomb_timer     : %mod(!W_Bomb_timer, #$0002) : RTS
.switch_bomb_mode 	   : %mod(!W_Bomb_mode, #$0000) : RTS
.switch_item_sfx 	   : %mod(!W_Item_sfx, #$0001) : RTS
.switch_music
	LDA !C_O_Music_toggle : PHA : JSL Check_pause_bit : BCC +
	PLA : JSL Clear_pause_bit
	LDA #$0000								;clearing out the music command queue
	STA $0629 : STA $062B : STA $062D : STA $062F
	STA $0631 : STA $0633 : STA $0635 : STA $0637
	STA $063F : STA $2140
	BRA ++
	+
	PLA : JSL Set_pause_bit
	LDA $07F5 : STA $2140					;reseting the music
	++
	JSR Options_screen_draw_music
	RTS

.switch_sfx
	LDA !C_O_Soundfx_toggle : PHA : JSL Check_pause_bit : BCC +
	PLA : JSL Clear_pause_bit : BRA ++
	+
	PLA : JSL Set_pause_bit
	++
	JSR Options_screen_draw_sfx
	RTS

.bshot
.bjump
.bdash
.bselect
.bcancel
	CMP !C_B_X : BEQ .set_button
	CMP !C_B_A : BEQ .set_button
	CMP !C_B_B : BEQ .set_button
	CMP !C_B_select : BEQ .set_button
	CMP !C_B_Y : BEQ .set_button
	CMP !C_B_L : BEQ .set_button
	CMP !C_B_R : BEQ .set_button
	BRA .set_button_fail
.bangleup
.bangledown
	CMP #$0021 : BPL .set_button_fail			;for consistency with the rest of the game, you can't set aim up/down to something other than shoulder buttons

.set_button
!ButtonPrev = $00

	LDA !W_Pause_entry : ASL : TAX
	LDA $09B2,x : CMP !W_Pressed : BEQ .set_button_fail
	STA !ButtonPrev
	LDY #$000C
	-
	LDA $09B2,y
	CMP !W_Pressed : BEQ +
	DEY #2 : BMI .set_button_fail : BRA -
	+
	LDA !W_Pressed : STA $09B2,x
	LDA !ButtonPrev : STA $09B2,y
	SEC
	RTS

.set_button_fail
	CLC
	RTS

.default_buttons
	LDA !C_B_up   : STA !W_B_up   : LDA !C_B_down  : STA !W_B_down
	LDA !C_B_left : STA !W_B_left : LDA !C_B_right : STA !W_B_right
	LDA !C_B_A    : STA !W_B_jump : LDA !C_B_B : STA !W_B_run
	LDA !C_B_X    : STA !W_B_shoot
	LDA !C_B_R    : STA !W_B_aim_up : LDA !C_B_L : STA !W_B_aim_down
	LDA !C_B_Y    : STA !W_B_cancel : LDA !C_B_select : STA !W_B_select
	RTS
.reset_buttons
   %pea(70)
	LDX #$000C
	-
	LDA !S_B_shoot,x : STA $7E09B2,x
	DEX #2 : BPL -
	PLB
	RTS

.buttons_config : LDA #$0004 : BRA .change_screen
.view_stats 	: LDA #$0003 : BRA .change_screen
.bend 			: LDA #$0002 : BRA .change_screen
.change_screen
	STA !W_Pause_screen_tar
	INC !W_Pause_index
	LDA $C10A : STA $0729 : STZ $0751
	;JSR Subscreen_tilemap_transfer_buttons
	RTS

.save_settings_SRAMAddr : dw $0010, $0A10, $1410
.save_settings
	LDA #$0022 : JSL !Message_box : CMP #$0001 : BEQ +
	;this does *not* include the checksum, it probably should...
	; *** also remember to include the practice hud in this later ***
   %pea(7E)
	LDA !W_Save_slot : AND #$0003 : ASL : TAX
	LDA .save_settings_SRAMAddr,x : PHA : CLC : ADC #$0070 : TAX
	LDY #$0010
	-
	LDA.w !W_Options_equip,y : STA $700010,x
	DEX #2 : DEY #2 : BPL -
	PLA
	PLB
	CLC : ADC #$085E : TAX
	LDA !W_Pause_default : STA $7000FE,x
	LDA !W_Hud_type      : STA $7000FC,x
	LDA !W_Bomb_timer    : STA $7000FA,x
	LDA !W_Bomb_mode     : STA $7000F8,x
	LDA !W_Item_sfx      : STA $7000F6,x
	+
	RTS

;.hud_list	<-- what was this used for????
;	LDA #$0001 : STA !W_Pause_hud_mode
;	RTS

