lorom

; :::															   :::
; ::: Bank 87 free space is dedicated to individual subscreen code :::
; :::															   :::

; other than this little change
; dma entries for the animated tiles used in FX1
; they are repointed for the sake of more clear organisation of the HUD gfx
org $8782AB : dw $8293, $0040, $47D8		;lava
org $8782C9 : dw $82B1, $0040, $47D8		;acid
org $8782E7 : dw $82CF, $0050, $47D8		;rain
org $8782FD : dw $82ED, $0030, $47D8		;spores

org $87DF40
; free space in bank $87

; --- Quote58 (everything here) ---
; ::: Reference for subscreen code :::
; -----------------------------------
table Code/data/subscreens/text_subscreen.txt ;the position of letter has changed, so this is the new table
!Size 	   = $00						;often used to store the size of a given tilemap, especially when drawing the tilemap
!TilePal   = $18						;often used to store the palette index
; -----------------------------------

; :::						  	   :::
; ::: Individual Pause Screen code :::
; :::							   :::

; ::: Map Screen :::
Map_screen:

; ::: Options Screen :::
Options_screen:
.init
   !phb
	BRA .end
	
.main
   !phb

.end
	JSR Pause_update_tilemap
   !plb
	RTL

; ::: Equipment Screen :::
; --- Quote58 ---
Equip_screen:
!ReservesList = #$0000
!BeamsList    = #$0001
!SuitsList    = #$0002
!MiscList     = #$0003
!BootsList    = #$0004
!HyperList	  = #$0005						;hyper list needs to be the last entry, otherwise you can't use Pause_init_all or Pause_draw_all, since they are sequential

!BitVaria     = #$0000						;bit values of samus' equipment for use in the pause screen
!BitSpring    = #$0001
!BitMorph     = #$0002
!BitScrew     = #$0003
!BitGravity   = #$0005
!BitHijump 	  = #$0008
!BitSpace     = #$0009
!BitBombs  	  = #$000C
!BitSpeed     = #$000D
!BitGrapple	  = #$000E
!BitXray      = #$000F
!BitWave   	  = #$0020
!BitIce       = #$0021
!BitSpazer 	  = #$0022
!BitPlasma    = #$0023
!BitCharge 	  = #$002C

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

.draw_sprites							;this should add an x/y from a table to determine the new position instead of using the oam x/y <-- it does that now!
   !phb
	LDA !W_Pause_list : BMI ++
	PHA : ASL : TAX
	LDA .line_xy,x : AND #$FF00 : XBA : CMP #$0080 : BMI +
	CLC : ADC #$FF00
	+
	STA $12
	LDA .line_xy,x : AND #$00FF : CMP #$0080 : BMI +
	CLC : ADC #$FF00
	+
	STA $14
	PLA : JSR Pause_get_header
	LDA !S_Sprite_pos,x : AND #$00FF : CLC : ADC $14 : TAY
	LDA !S_Sprite_pos,x : AND #$FF00 : XBA : CLC : ADC $12 : TAX : PHX
	LDA #$0E00 : STA $03
	LDX !W_Pause_list : LDA .line_from_list,x : PLX
	AND #$00FF : CMP #$00FF : BEQ +		;unfortunately we can't just do XBA : BMI + because the negative flag isn't affected by AND/XBA, but *is* affected by PLX
	JSL Draw_pause_sprite_extra
	+
	JSR Pause_draw_cursor
	++
   !plb
	RTL

.line_from_list
	db $FF, $00, $01, $02, $03, $FF, $FF

.line_xy
	dw $FFFF,$2F0C,$B810,$B600,$C912

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
	LDA !GFX_Equip_SM_BNK : STA !bnk
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
	LDA #$0083 : STA !SuitBank
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
	
   %check_option(!C_O_Equip_mod)
	JSR .items
	JSR .cannon
	JSR .hyper_beam
.end
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
	
   %pea(83)
	
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

; :::									:::
; ::: Pause screen object handling code :::
; :::									:::

; this contains all the backend code that handles the list objects
; these are all referenced by Pause_ and a list of the routines with descriptions can be found at the top of this file
incsrc Code/data/subscreens/list_object_code.asm


; --- Quote58 ---
; ::: Subscreen List Objects :::

;these objects are set up in a couple of ways, but they're pretty simple
; * List *
;Example_list: .type 	: db $00
;			   .len  	: dw WWMM : db SS	[WW = window length, MM = max length, SS = size of tilemaps to draw]
;			   .pos  	: dw IIII, XXYY		[IIII = index into the layer tilemap, XXYY = X/Y position for cursor sprite]
;			   .dir		: dw UDLR : db CC	[UDLR = index of list to move going Up/Down/Left/Right, CC = sprite to use as cursor (index into sprite list)]
;			   .bits	: db BB				[BB = bit value to check, only single bytes needed]
;			   .tilemap : dw TTTT			[TTTT = address of tilemap in bank 82]
;
; * Widget *
;Example_widget: .type  : db $01
;				 .len	: dw LLLL			[LLLL < 8000 = static length of list, LLLL > 8000 = pointer to the over ride function for length of widget]
;				 .dir	: dw UDLR			[UDLR = index of list to move going Up/Down/Left/Right]
;				 .pos	: dw XXYY			[XXYY = X/Y position for cursor sprite]
;				 .typ	: dw DDCC			[DD = difference in pixels between list items, CC = sprite to use as cursor (index into sprite list)]
;				 .fun	: dw FFFF			[FFFF = pointers to functions for what each entry in the widget list should do]

; ::: Options screen :::
Options_lists:
; ---

; ::: Equip Screen :::
Equip_lists:   dw Reserves_list, Beam_list, Suits_list, Misc_list, Boots_list, Hyper_list
; ---
Reserves_list: %widget(Pause_len_reserves, $F1F2, $1A42, $0014)
	.fun		dw Pause_widget_switch_reserves_type, Pause_widget_refill_reserves
	
Hyper_list:    %widget($0000, $0FF3, $377B, $0014)
	.fun		dw Pause_widget_hyper_beam
	
Beam_list:	   %list($0404, $03, $3B8A, $3773, $0FF3, $15)
	.bits	  : db !BitCharge, !BitIce, !BitWave, !BitSpazer, !BitPlasma
	.tilemaps : dw Item_tilemaps_charge, Item_tilemaps_ice, Item_tilemaps_wave, Item_tilemaps_spazer, Item_tilemaps_plasma

Misc_list:	   %list($0303, $07, $3B2A, $CB63, $241F, $16)
	.bits	  : db !BitMorph, !BitBombs, !BitSpring, !BitScrew
	.tilemaps : dw Item_tilemaps_morph, Item_tilemaps_bombs, Item_tilemaps_spring, Item_tilemaps_screw

Suits_list:	   %list($0101, $07, $3A2A, $CB43, $F30F, $16)
	.bits	  : db !BitVaria, !BitGravity
	.tilemaps : dw Item_tilemaps_varia, Item_tilemaps_gravity

Boots_list:	   %list($0202, $07, $3CAA, $CB93, $3F1F, $16)
	.bits	  : db !BitHijump, !BitSpace, !BitSpeed
	.tilemaps : dw Item_tilemaps_hi_jump, Item_tilemaps_space_jump, Item_tilemaps_speed_booster

; ::: Tilemaps for list options and other stuff :::
Item_tilemaps:
incsrc Code/data/subscreens/equip_screen/equip_list_tilemaps.asm

print "End of free space (87FFFF): ",pc