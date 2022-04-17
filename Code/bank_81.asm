lorom

; this is refering to bank $93, because it's for drawing samus projectiles
org $818A3F : LDY.w Flare_type,x

; these are all for the new save file routines that store extra data
org $81B2CB : JMP File_new_game
org $819A47 : LDA File_SRAMAddr,X : Skip 7 : LDA File_SRAMAddr,X : Skip 11 : CPY #$0A00
org $819CAE : LDA File_SRAMAddr,X : Skip 12 : CPY #$0A00
org $818000 : JMP File_save_game
org $818085 : JMP File_load_game

; these are for the new subscreen sprite and tile loading system
; the title screen essentially replicates the pause screen for the square map screen
; which means we need to make sure it loads in the right tiles and sprites before that happens
; but not before the hexagonal map is shown, because that uses a different set of data and sprites
org $81ADB7 : ADC #$000E						;this is for going backwards from the square map, so that it will reload the file select sprites
org $81AC6D : JSR Start_game_loop_to_square_map	;this is going forward to the square map, so that it loads the map sprites
org $81B14B : incsrc Code/data/subscreens/new_game_square_map.asm ;this is the tilemap under the square map ('map scroll', 'start', 'cancel')
org $819E3E
	REP #$30
	PHB : PHK
	PLB
	LDA !W_Start_index : ASL : TAX
	JSR (Start_game_loop_table,x)
	PLB
	RTL

org $81EF20
; ::: free space in bank 81 :::
; --- Quote58 ---
Start_game_loop:
.table : dw $A32A, $A37C, $A546, $A582, $A5B3, $A725, $A800, $AAAC, $AC66, $AD17, $AD7F
		 dw $AF5A, $AF5A, $AF66, $AF83, $AF97, $AFD3, $A546, $A578, $A5B3, $AFF6, $B0BB, $9E7B
		 dw .load_sprites_f, .load_sprites_b

.to_square_map
	LDA #$0017 : STA !W_Start_index
	RTS

.load_sprites_b
	LDA #$000F : STA !W_Start_index
   %dma_vram(60,00, 80, !GFX_Title_S, 2000)	;transfer the title screen gfx
	RTS

.load_sprites_f
	LDA #$0009 : STA !W_Start_index
   %dma_vram(60,00, 80, !GFX_Map_S, 0C00)	;transfer the top half of the area names and some other stuff that's swapped out for other screens
   %dma_vram(66,00, 80, !GFX_Main_S, 0E00)	;transfer the sprite gfx data (only half, because the other half is transfered based on the screen)
	RTS

; --- Quote58 ---
Draw_pause_sprite_extra:				;should this be in 80 and not 81? Look into that later...
   %pea(83)
	STY $12 : STX $14
	ASL A : TAX
	LDY.w Pause_spritemaps_extra,x
	JMP $892E

; --- Quote58 ---
File:
.new_game
	REP #$30
	LDA !C_D_Health 	: STA !W_Health   : STA !W_Health_max
	LDA !C_D_Missiles   : STA !W_Missiles : STA !W_Missiles_max
	LDA !C_D_Supers 	: STA !W_Supers   : STA !W_Supers_max
	LDA !C_D_Powers 	: STA !W_Powers   : STA !W_Powers_max
	LDA !C_D_Pause 	    : STA !W_Pause_default
	LDA !C_D_Hud	    : STA !W_Hud_type
	LDA !C_D_Item 		: STA !W_Item_sfx

	LDA !Main_Config_Acquired_1 : STA !W_Options_collect
	LDA !Main_Config_Acquired_2 : STA !W_Options_collect+2
	LDA !Main_Config_1 		    : STA !W_Options_equip
	LDA !Main_Config_2 		    : STA !W_Options_equip+2

	STZ !W_HUD_select
	STZ !W_Beams_collect : STZ !W_Beams_equip
	STZ !W_Items_collect : STZ !W_Items_equip
	STZ !W_Reserves_type
	STZ !W_Reserves : STZ !W_Reserves_max
	LDA !C_B_up   : STA !W_B_up   : LDA !C_B_down  : STA !W_B_down
	LDA !C_B_left : STA !W_B_left : LDA !C_B_right : STA !W_B_right
	LDA !C_B_A    : STA !W_B_jump : LDA !C_B_B : STA !W_B_run
	LDA !C_B_X    : STA !W_B_shoot
	LDA !C_B_R    : STA !W_B_aim_up : LDA !C_B_L : STA !W_B_aim_down
	LDA !C_B_Y    : STA !W_B_cancel : LDA !C_B_select : STA !W_B_select
	STZ !W_Time_frames : STZ !W_Time_seconds
	STZ !W_Time_minutes : STZ !W_Time_hours
	STZ !W_Language
	STZ $09E4 : STZ $09EA					;zero the moonwalk flag and hud auto-cancel
	LDA #$0001 : STA $09E6 : STA $09E8		;unknown
	
	LDX #$0000
	LDA #$0000
	-
	STA !W_Options_collect,x
	STA !W_Item_bit_array,x
	STA !W_Door_bit_array,x
	STA $7ED8F0,x
	STA $7ED908,x : STA $7ED8F8,x
	STA $7ED900,x : INX #2
	CPX #$0008 : BMI -
	
	LDA #$0000
	-
	STA !W_Options_collect,x
	STA !W_Item_bit_array,x
	STA !W_Door_bit_array,x
	INX #2
	CPX #$0040 : BMI -
	
	LDX #$0000
	LDA #$0000
	-
	STA $7ECD52,x : INX #2					;clear explored map for every area
	CPX #$0700 : BMI -
	RTS

; --- Scyzer (rewritten by Quote58 for readability) ---
!Checksum = $14
!SaveFile = $12
!SRAMAddr = $16

.SRAMAddr : dw $0010, $0A10, $1410

.add_checksum
	CLC : ADC !Checksum
	INC : STA !Checksum
	RTS

.save_game
   !pha
   %pealt(7E)
	STZ !Checksum
	AND #$0003 : ASL : STA !SaveFile
	
	;back up the current explored map
	LDA !W_Region : INC : XBA : TAX
	LDY #$00FE
	-
	LDA !W_Explored_map,y : STA.w !W_Explored_map_0-2,x
	DEX #2 : DEY #2 : BPL -
	
	;back up the items/beams acquired and equipped
	LDY #$005E
	-
	LDA !W_Items_equip,y : STA.w !W_SRAM_data,y
	DEY #2 : BPL -
	
	LDA !W_Current_station : STA $D916
	LDA !W_Region : STA $D918
	
	;move the plm bits, event bits, door bits, boss bits, and option bits to sram
	LDX !SaveFile : LDA .SRAMAddr,x : TAX
	LDY #$0000
	-
	LDA.w !W_SRAM_data,y : STA $700000,x : JSR .add_checksum
	INX #2 : INY #2
	CPY #$0160 : BNE -
	
	;move the explored maps to sram
	LDY #$06FE
	-
	LDA.w !W_Explored_map_0,y : STA $700000,x
	INX #2 : DEY #2 : BPL -
	
   %pea2(7F,7F)
	
	;move the extra ram for this file to sram
	LDY #$00FE
	-
	LDA $FE00,y : STA $700000,x
	INX #2 : DEY #2 : BPL -
	
	;move the extra global ram to sram
	LDX #$1E10
	LDY #$00FE
	-
	LDA $FF00,y : STA $700000,x
	INX #2 : DEY #2 : BPL -
	
	;save the checksum
	LDX !SaveFile
	LDA !Checksum : STA $700000,x : STA $701FF0,x
	   EOR #$FFFF : STA $700008,x : STA $701FF8,x

   !pla
	RTL

.load_game
   !pha
   %pealt(7E)
	STZ !Checksum
	AND #$0003 : ASL : STA !SaveFile : TAX
	
	;move the plm bits, event bits, door bits, boss bits, and option bits to wram
	LDA .SRAMAddr,x : STA !SRAMAddr : TAX
	LDY #$0000
	-
	LDA $700000,x : STA.w !W_SRAM_data,y : JSR .add_checksum
	INX #2 : INY #2
	CPY #$0160 : BNE -
	
	LDA $D916 : STA !W_Current_station
	LDA $D918 : STA !W_Region

	;move explored maps to wram backup
	LDY #$06FE
	-
	LDA $700000,x : STA.w !W_Explored_map_0,y
	INX #2 : DEY #2 : BPL -
	
   %pea2(7F,7F)
	
	;move extra ram for this file to wram
	LDY #$00FE
	-
	LDA $700000,x : STA $FE00,y
	INX #2 : DEY #2 : BPL -
	
	;move extra global ram to wram
	LDX #$1E10
	LDY #$00FE
	-
	LDA $700000,x : STA $FF00,y
	INX #2 : DEY #2 : BPL -
	
	-
	;see if the checksum matches up
	LDX !SaveFile
	LDA $700000,x : CMP !Checksum : BNE +
	EOR #$FFFF : CMP !Checksum : BEQ -
	LDA !Checksum
	+
	CMP $701FF0,x : BNE .load_game_bad_checksum
	EOR #$FFFF : CMP $701FF8,x : BNE .load_game_bad_checksum

   %pealt(7E)
   
	;move the item bits to wram
	LDY #$005E
	-
	LDA.w !W_SRAM_data,y : STA !W_Items_equip,y
	DEY #2 : BPL -

   !pla
	CLC
	RTL

.load_game_bad_checksum
	;checksum didn't match, clear sram
	LDX !SRAMAddr
	LDY #$09FE
	LDA #$0000
	-
	STA $700000,x
	INX #2 : DEY #2 : BPL -
	
   !pla
	SEC
	RTL

print "End of free space (81FFFF): ", pc
	
	
	
	
	
	
	
	
	