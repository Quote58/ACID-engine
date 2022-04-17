lorom

; ::: FOR QUICKMET :::
; I want this to work with smile 2.5 and smilerf, which means it needs to work with quickmet
; which happens to overwrite a good chunk of code for opening the game to avoid having to run
; the original game opening sequence. This is fine, except that it means the routines in bank 81
; for creating a new save file do not get run. As a result, we need to set up some memory that
; would normally be set up when making a new save file.
; One thing quickmet does is call the original hud init routine, and that's where we'll put this
; because we need to have it call the new hud instead anyway.
; tl;dr don't touch this unless you know what you're doing
org $809A79
	REP #$30

	; handle the reserve tanks
	LDA !W_Reserves_max : BEQ +
	LDA !W_Reserves_type : BNE +
	LDA #$0001 : STA !W_Reserves_type
	+
	
	; this lets you set spazer and plasma to both be aquired for quickmet but not both be equipped
	; it defaults to spazer disabled plasma enabled
	LDA !W_Beams_equip : BIT !C_I_plasma : BEQ +
						 BIT !C_I_spazer : BEQ +
	LDA !C_I_spazer : TRB !W_Beams_equip
	+
	
	; set defaults
	LDA !C_D_Pause : STA !W_Pause_default
	LDA !C_D_Item  : STA !W_Item_sfx
	LDA !C_D_Hud   : STA !W_Hud_type
	
	; clear the minimap tiles
	LDA #$2C1F : LDX #$001E
	-
	STA !W_Mini_map_tiles,x
	DEX #2 : BPL -
	LDA #$0001 : STA !W_Mini_map_mirror

	; set the main config variables
	LDA !Main_Config_Acquired_1 : STA !W_Options_collect
	LDA !Main_Config_Acquired_2 : STA !W_Options_collect+2
	LDA !Main_Config_1 : STA !W_Options_equip
	LDA !Main_Config_2 : STA !W_Options_equip+2

	; init the modular hud
	JSL Hud_init
	RTL
; :::::::::::::::::::::

org $809065 : JSR Check_sfx
org $8090E7 : JSR Check_sfx
org $809169 : JSR Check_sfx
org $808F24 : JSR Check_music : NOP #3

; :::								 :::
; ::: IRQ Interrupt Command Routines :::
; :::								 :::
Interrupt:
org $809616
; notes:
; the vram update routine has been moved to free space so that more commands can be placed contiguously for consistency
; you could give these commands names instead of command_n, but it's easy to reference them like this
; an irq command must end with the V counter in Y, the H counter in X, and the next IRQ command in A

.commands
	dw .command_0, .command_2, .command_4, .command_6, .command_8, .command_A, .command_C
	dw .command_E, .command_10, .command_12, .command_14, .command_16, .command_18, .command_1A

.command_0								;command 0 does nothing, and is called by the IRQ routine
	LDA !W_Interrupt_next : BEQ +
	STZ !W_Interrupt_next : BRA ++
	+
	LDA #$0000
	++
	LDX #$0000 : LDY #$0000				;IRQ h/v counters = 0
	RTS

.command_2								;command 2 disables h/v counter interrupts
	LDA #$0030 : TRB $84
	LDA #$0000
	TAX : TAY
	RTS

.command_4								;main gameplay, begin HUD drawing
	SEP #$20
	LDA #$5A : STA $2109
	STZ !R_Colour_add : STZ !R_Colour_math
	LDA #$04 : STA $212C
	REP #$20
	LDA #$0006							;next interrupt command = 6
	LDY #$001F : LDX #$0098				;IRQ v counter = 1F, h counter - 98
	RTS

.command_6								;main gameplay, end hud drawing
   %gameplay_screen_regs()
	LDA !W_Interrupt_next : BEQ +
	STZ !W_Interrupt_next : BRA ++
	+
	LDA #$0004
	++
	LDY #$0000 : LDX #$0098
	RTS

.command_8								;start of door transition, begin HUD drawing
	SEP #$20
	LDA #$5A : STA $2109
	LDA #$04 : STA $212C
	STZ !R_Colour_add : STZ !R_Colour_math
	REP #$20
	LDA #$000A
	LDY #$001F : LDX #$0098
	RTS

.command_A								;start of door transition, end of HUD drawing
   %door_screen_regs()
	LDA !W_Interrupt_next : BEQ +
	STZ !W_Interrupt_next : BRA ++
	+
	LDA #$0008
	++
	LDY #$0000 : LDX #$0098
	RTS

.command_C								;draygon's room, begin HUD drawing
	SEP #$20
	LDA #$04 : STA $212C
	STZ !R_Colour_add : STZ !R_Colour_math
	REP #$20
	LDA #$000E
	LDY #$001F : LDX #$0098
	RTS
	
.command_E								;draygon's room, end HUD drawing
	SEP #$20
	LDA $5B : STA $2109
	LDA $70 : STA !R_Colour_add
	LDA $73 : STA !R_Colour_math
	REP #$20
	LDA !W_Interrupt_next : BEQ +
	STZ !W_Interrupt_next : BRA ++
	+
	LDA #$000C
	++
	LDY #$0000 : LDX #$0098
	RTS

.command_10								;vertical door transition, begin hud drawing
	SEP #$20
	LDA #$04 : STA $212C
	STZ !R_Colour_add : STZ !R_Colour_math
	REP #$20
	LDA #$0012
	LDY #$001F : LDX #$0098
	RTS

.command_12								;vertical door transition, end hud drawing
   %door_screen_regs()
	LDX $05BC : BPL +
	JSR .VRAM_update
	+
	LDA $0931 : BMI +
	JSL $80AE4E
	+
	LDA #$0014
	LDY #$00D8 : LDX #$0098
	RTS

.command_14								;vertical door transition, end drawing
	LDA !W_Interrupt_next : BEQ +
	STZ !W_Interrupt_next : BRA ++
	+
	LDA #$0010
	++
	LDY #$0000 : LDX #$0098
	STZ !W_NMI_request
	INC !W_NMI_request
	RTS

.command_16								;horizontal door transition, begin HUD drawing
	SEP #$20
	LDA #$04 : STA $212C
	STZ !R_Colour_add : STZ !R_Colour_math
	REP #$20
	LDA #$0018
	LDY #$001F : LDX #$0098
	RTS

.command_18								;horizontal door transition, end HUD drawing
   %door_screen_regs()
	LDA $0931 : BMI +
	JSL $80AE4E
	+
	LDA #$001A
	LDY #$00A0 : LDX #$0098
	RTS
	
.command_1A								;horizontal door transition, end drawing
	LDX $05BC : BPL +
	JSR .VRAM_update
	+
	LDA !W_Interrupt_next : BEQ +
	STZ !W_Interrupt_next : BRA ++
	+
	LDA #$0016
	++
	LDY #$0000 : LDX #$0098
	STZ !W_NMI_request
	INC !W_NMI_request
	RTS

print "interrupt command space ends at 982A: ",pc

org $80CD8E
; ::: Free space in bank $80 :::

; --- Quote58 ---
; this is called from the gameplay game state, and will run every frame during normal gameplay
; use this to run code that has to run every frame but doesn't fit in a specific area of the game engine
Run_every_frame:
   !phb

	; don't touch this little bit of code unless you know what you're doing
	; it's just a precaution, but should make debugging easier
	LDA !W_Stack_end : BEQ +			;to ensure that code never causes the stack to unintentionally go past it's end point
	LDA #$FFFA : STA $00				;we're just going to mark the start of ram so it's easy to see in a debugger
	LDA #$FFFB : STA $02
	LDA #$FFFC : STA $04
	LDA #$FFFD : STA $06
	- JMP -								;and then loop forever to make sure the game crashes
	+

	JSR DEBUG							;all sorts of debug functions

	; here is where you can put routines that run every frame
	JSR Morph_flash						;gives samus' palette a flash when morphing/unmorphing with an index in !Morph_flash

   !plb
	RTL

; --- DEBUG routines ---
DEBUG:
	;JSR .nocash
	RTS

.nocash
; nocash is the fucking worst and I need to set static values so samus doesn't die and also has button values

	LDA #$0063 : STA !W_Health
	LDA #$0050 : STA !W_Missiles
	LDA #$0050 : STA !W_Supers
	LDA !C_B_up   : STA !W_B_up   : LDA !C_B_down  : STA !W_B_down
	LDA !C_B_left : STA !W_B_left : LDA !C_B_right : STA !W_B_right
	LDA !C_B_A    : STA !W_B_jump : LDA !C_B_B : STA !W_B_run
	LDA !C_B_X    : STA !W_B_shoot
	LDA !C_B_R    : STA !W_B_aim_up : LDA !C_B_L : STA !W_B_aim_down
	LDA !C_B_Y    : STA !W_B_cancel : LDA !C_B_select : STA !W_B_select
	RTS

.draw_sprite_from_outside
	LDA $18 : PHA
	LDA $16 : PHA
	LDA $14 : PHA
	LDA $12 : PHA
	JSR .draw_sprite
	PLA : STA $12
	PLA : STA $14
	PLA : STA $16
	PLA : STA $18
	RTL

.draw_sprite							;this routine will draw a generic sprite from the enemy projectile sprite index at a given location
	PHX : PHY
	JSL Find_xy
	TXA : CLC : ADC #$0004 : STA $12
	TYA : CLC : ADC #$0004 : STA $14
	LDA #$0000 : STA $16
	STZ $18
	JSL $B4BC26
	PLY : PLX
	RTS

.find_block_down						;this will find the block type underneath samus
	LDX !W_X_pos : LDA !W_Y_pos : CLC : ADC #$0010
	JSL Find_block
	AND #$F000 : XBA : LSR #4
	RTS

.find_bts_down
	LDX !W_X_pos : LDA !W_Y_pos : CLC : ADC #$0010
	JSL Find_bts
	RTS


; ********************************************************************
; *** Built in features controlled by the main configuration value ***
; ********************************************************************

; --- Quote58 (concept by Black Falcon (and zero mission)) ---
Morph_flash:
!Power   = $99
!Varia   = $9A
!Gravity = $9B
!Index	 = $00

	LDA !W_Morph_flash : BEQ .end : TAX
	LDA !W_Current_pose : AND #$00FF
	CMP #$0081 : BMI +
	CMP #$0083 : BPL +
	LDX #$0001 : STX !W_Morph_flash
	+

	STZ !Index							;this ensures you get 00C0 instead of XXC0
	SEP #$20
	
	LDA .palette,x : STA !Index
	LDA !W_Hyper_beam : BEQ +
	REP #$20 : LDA #$A340 : BRA ++		;if hyper beam is on, we'll use the rainbow palette for morph flash
	+
	LDA !W_Palette_index : LSR A : TAY	;palette index is 0/2/4, LSR is 1 byte, so using it saves 2 bytes in the table
	LDA .suit_type,y
	REP #$20
	XBA

	++
	SEC : SBC !Index : TAX				;0099 -> 9900 - C0 = 9840 -> X
	LDY #$C180 : LDA #$0020				;samus's palette is stored at 7EC180 and is $20 bytes long
	MVN $9B7E
	
	DEC !W_Morph_flash
	LDA !W_Morph_flash : BNE .end
	JSL !Update_palette

.end
	RTS

.suit_type
	db !Power,!Varia,!Gravity

.palette
	db $00								;this is just to save 1 byte and 2 cycles over decrementing a counter
	rep !C_F_speed : db $60
	rep !C_F_speed : db $40
	rep !C_F_speed : db $20
	rep !C_F_speed : db $00
	db $20,$20,$40,$40,$60,$60			;initial flash, can be longer or shorter if need be, but remember to change !Flash_amount if so

; --- Tewtal (slightly modified by Quote58) ---
Check_music:
	STZ $07F6
	PHA
	REP #$20
	LDA !W_Game_state : CMP #$0007 : BMI +		;the music and sfx toggles are only applicable to gameplay/pause screen, so this makes sure the title screen, etc. are uneffected
						CMP #$0025 : BPL +
	LDA !C_O_Music_toggle : JSL Check_option_bit : BCC .none
	+
	SEP #$20
	PLA : STA $2140
	RTS
.none
	SEP #$20
	PLA
	RTS

Check_sfx:
	PHA
	LDA !W_Game_state : CMP #$0007 : BMI +		;the music and sfx toggles are only applicable to gameplay/pause screen, so this makes sure the title screen, etc. are uneffected
						CMP #$0025 : BPL +
	LDA !C_O_Soundfx_toggle : JSL Check_option_bit : BCC .none
	+
	PLA
	LDX !W_Disable_sfx
	RTS
.none
	PLA
	LDX #$FFFF
	RTS

; **************************************
; *** These are general use routines ***
; **************************************

; called with a JSL (unless otherwise specified)

; --- Quote58 ---
Interrupt_VRAM_update:					;not called with JSL, only really used in interrupt commands for door transitions (but could be used elsewhere)
	SEP #$20
	LDA #$80   : STA !R_Screen_disp		;enable forced blank so we can transfer to vram
	LDX $05BE  : STX !R_VRAM_low
	LDX #$1801 : STX $4310
	LDX $05C0  : STX $4312
	LDA $05C2  : STA $4314
	LDX $05C3  : STX $4315
	LDA #$80   : STA !R_VPORT
	LDA #$02   : STA !R_DMA				;enable DMA
	LDA #$80   : TRB $05BD				;vram update flag = 0
	LDA #$0F   : STA !R_Screen_disp		;disable forced blank
	REP #$20
	RTS

VRAM_DMA:								;performs a DMA transfer to VRAM with the parametres in $00-$06
	PHP
	REP #$30
	LDX !W_D0_stack
	LDA !amt : STA $D0,x				;amount
	LDA !src : STA $D2,x				;source
	LDA !bnk : STA $D4,x				;bank
	LDA !dst : STA $D5,x				;destination
	TXA : CLC : ADC #$0007
	STA !W_D0_stack
	PLP
	RTL

Find_scroll:							;takes an X and Y position and returns the type of scroll (0 = red, 1 = blue, 2 = green) in that position
!ScrollTemp = $00

	AND #$FF00 : XBA : STA !ScrollTemp	;X position in X, Y position in A
	LDA !W_Room_width : LSR #4			;room width is in blocks, scrolls are 16 blocks each
   %multiply(!ScrollTemp) : STA !ScrollTemp
	TXA : AND #$FF00 : XBA
	CLC : ADC !ScrollTemp : TAX			;(y*width)+x = current scroll
	SEP #$30
	LDA !W_Room_scroll,x
	REP #$30
	RTL

Find_block:								;takes an X and Y position and returns the corrosponding block from the layer 1 tilemap
!YIndex = $00

	LSR #4 : %multiply(!W_Room_width)	;X position in X, Y position in A
	ASL A : STA !YIndex
	TXA
	LSR #3 : AND #$FFFE					;this can also be done with an extra LSR followed by an ASL. It's essentially just rounding to the nearest tile by removing the 1 bit
	CLC : ADC !YIndex : TAX
	LDA !W_Room_tilemap,x
	RTL

Find_xy:								;takes a block index in X and outputs an x (in x) and y (in y) rounded to the nearest block
	LDY #$0000
	TXA : LSR
	-
	CMP !W_Room_width : BEQ + : BMI +
	SEC : SBC !W_Room_width
	INY : BRA -
	+
	ASL #4 : TAX
	TYA : ASL #4 : TAY
	RTL
	
Find_bts:								;takes an X and Y position and returns the corrosponding block from the bts tilemap
	JSL Find_block						;X position in X, Y position in A
   %lsx(1)								;bts array is 8bit, so block index/2
	LDA !W_Room_bts,x
	AND #$00FF							;you could also use 8bit here, but it would waste cycles
	RTL

Is_heated:								;checks if the room has the heat bit set in it's FX header
	PHX
   %pea(83)
	LDX $1966
	LDA $000D,x : AND #$00FF
	STA $02
	PLB
	PLX
	LDA $02 : BIT #$0001 : BNE +
	CLC
	RTL
	+
	SEC
	RTL
	
Is_under_liquid_grav:					;just checks if samus is under the height of a liquid and if she has gravity
	LDA !W_FX3_type : CMP #$0006 : BNE +
	LDA !W_FX3_height : BRA ++			;water can change height, lava/acid just use a ypos
	+
	LDA !W_FX3_Ypos
	++
	CMP !W_Y_pos : BMI +				;if samus Y < water Y, she's under the liquid
	-
	CLC									;if she isn't under the liquid, gravity suit doesn't matter
	RTL
	+
	LDA !W_Items_equip
	BIT !C_I_gravity : BNE -			;if she has gravity, treat it like she's not underwater
	SEC
	RTL

Is_air_block:							;block index to check in X, counter set = air, counter clear = not air
	LDA !W_Room_tilemap,x
	AND #$F000 : BEQ .air				;0xxx means normal air block
	CMP #$5000 : BEQ .h_extend
	CMP #$D000 : BEQ .v_extend
	CMP #$2000 : BMI .not_air
	CMP #$8000 : BPL .not_air
.air
	SEC
	RTL
.not_air
	CLC
	RTL	
.h_extend								;extension blocks can extend any type of tile, so we need to trace them back to their root for the real block type
	JSR .get_bts : PHX : PHA
	LDA $00 : BRA .move_index
.v_extend
	JSR .get_bts : PHX : PHA
	LDA !W_Room_width : %multiply($00)
.move_index
	ASL A : STA $00
	PLA : CMP #$0081 : BMI .move_positive
.move_negative
	PLX : %dex($00) : JMP Is_air_block
.move_positive
	PLX : %inx($00) : JMP Is_air_block
.get_bts
	PHX
   %lsx(1)
	LDA !W_Room_bts,x : AND #$00FF : PHA
	CMP #$0081 : BMI +
	STA $00 : LDA #$0000 : SEC : SBC $00 : AND #$00FF
	+
	STA $00
	PLA : PLX
	RTS
	
Is_morphed:								;checks literally every possible pose where samus could be morphed, returns SEC if morphed. Much more accurate to gameplay than checking things like her vertical boundry
	SEP #$20
	LDA !W_Current_pose
	CMP #$1D : BMI .false
	CMP #$20 : BMI .true
	CMP #$31 : BMI .false : BEQ .true
	CMP #$32 : BEQ .true
	CMP #$3F : BMI .false
	CMP #$42 : BMI .true
	CMP #$79 : BMI .false
	CMP #$81 : BMI .true
	CMP #$C5 : BMI .false : BEQ .true
	CMP #$C6 : BEQ .true
	CMP #$DF : BMI .false : BEQ .true
	CMP #$FC : BMI .false
.true									;morphed
	REP #$20
	SEC
	RTL

.false
	REP #$20
	CLC
	RTL

Is_moonwalking:
	SEP #$20
	LDA !W_Current_pose
	CMP #$49 : BMI .false
	CMP #$4B : BMI .true
	CMP #$75 : BMI .false
	CMP #$79 : BMI .true
	CMP #$BF : BMI .false
	CMP #$C5 : BPL .false
.true									;currently moonwalking
	REP #$20
	SEC
	RTL

.false
	REP #$20
	CLC
	RTL

Is_spinning:
	SEP #$20
	LDA !W_Current_pose
	CMP #$19 : BMI .false				;19,1A,1B,1C = spin right, spin left, sj right, sj left
	CMP #$1D : BMI .true
	CMP #$81 : BMI .false				;81,82,83,84 = sa left, sa right, wj left, wj right
	CMP #$84 : BPL .false
.true
	REP #$20
	SEC
	RTL
	
.false
	REP #$20
	CLC
	RTL

Check_item_bit:							;this is a way to check any given item bit from a single routine call by using the bit checking method made for large scale bit arrays (like the item or door plm arrays)
   !phs									;this is probably only useful by the subscreen, but since it's still a general use routine it's staying in bank 80 for the moment
	JSL !Check_bit
	LDA $09A2,x : AND !W_Bit_check : BNE +
   !pls
	CLC
	RTL
	+
   !pls
	SEC
	RTL

Set_item_bit:
   !phs
	JSL !Check_bit
	LDA $09A2,x : ORA !W_Bit_check : STA $09A2,x
   !pls
	RTL

Clear_item_bit:
   !phs
	JSL !Check_bit
	LDA !W_Bit_check : EOR #$FFFF : STA !W_Bit_check
	LDA $09A2,x : AND !W_Bit_check : STA $09A2,x
   !pls
	RTL

Check_event_extra:						;this is an expansion on the event bit check routines for $7ED820, using $7ED830 for extra event bit space
   !phs
	JSL !Check_bit
	LDA $7ED840,x
	AND !W_Bit_check : BNE +
   !pls
	CLC
	RTL
	+
   !pls
	SEC
	RTL

Set_event_extra:
   !phs
	JSL !Check_bit
	LDA $7ED840,x : ORA !W_Bit_check : STA $7ED840,x
   !pls
	RTL

Clear_event_extra:
   !phs
	JSL !Check_bit
	LDA !W_Bit_check : EOR #$FFFF : STA !W_Bit_check
	LDA $7ED840,x : AND !W_Bit_check : STA $7ED840,x
   !pls
	RTL
	
Check_option_bit:						;this is an like the item bit check routine, but for option bits
   !phs
	JSL !Check_bit
	LDA !W_Options_equip,x
	AND !W_Bit_check : BNE +
   !pls
	CLC
	RTL
	+
   !pls
	SEC
	RTL

Set_option_bit:
   !phs
	JSL !Check_bit
	LDA !W_Options_equip,x : ORA !W_Bit_check : STA !W_Options_equip,x
   !pls
	RTL

Clear_option_bit:
   !phs
	JSL !Check_bit
	LDA !W_Bit_check : EOR #$FFFF : STA !W_Bit_check
	LDA !W_Options_equip,x : AND !W_Bit_check : STA !W_Options_equip,x
   !pls
	RTL
	
Check_pause_bit:
	PHA
	LDA !W_Pause_screen : CMP #$0001 : BEQ .equip
.options	
	PLA : JSL Check_option_bit : BRA .end
.equip
	PLA : JSL Check_item_bit
.end
	RTL
	
Set_pause_bit:
	PHA
	LDA !W_Pause_screen : CMP #$0001 : BEQ .equip
.options	
	PLA : JSL Set_option_bit : BRA .end
.equip
	PLA : JSL Set_item_bit
.end
	RTL

Clear_pause_bit:
	PHA
	LDA !W_Pause_screen : CMP #$0001 : BEQ .equip
.options	
	PLA : JSL Clear_option_bit : BRA .end
.equip
	PLA : JSL Clear_item_bit
.end
	RTL
	
Play_morph_sound:						;this just plays a sound from scyzer's expanded sound library stuff, used for morphing/unmorphing
	LDA #$0002 : STA !W_Item_clip
	LDA #$0004
	JSL $80914D
	RTL

Pause_game:								;this will freeze the game in place for A frames but continue to play sounds, using !Wait_for_vblank to wait until the frame has been drawn each iteration
   !phxy
	LDX $00 : PHX						;$00-$01 is used by the routines that keep sounds playing, so it needs to be preserved
	REP #$30
	-
	PHA
	JSL $808F0C : JSL $8289EF			;keep sounds playing
	JSL !Wait_for_vblank				;make sure we're looping per frame
	PLA
	DEC : BNE -
	PLX : STX $00
   !plxy
	RTL

Get_hyper_index:						;[Return: Index into hyper beam's palette glow in Y]
;this routine is used because the hyper beam is normally handled as an FX glow object even though it's applied to samus' sprite (!)
;so this gets you an index to use on that glow if you want to use it elsewhere, or in the correct palette routines, etc.
!CycleSpeed = #$0400					;the first byte of this is the delay for increasing the colour index, so increasing this makes the visor cycle colour slower

	LDA !W_Hyper_index : AND #$00FF	;the second byte of this address is the index into hyper_table
	CMP #$0009 : BMI +					;which has 10 colour offsets
	TRB !W_Hyper_index				;this resets the bits on the address that are held in A, effectively STZ just the second byte
	+
	TAX
	LDA .hyper_table,x : AND #$00FF : TAY
	LDA !W_Hyper_index : AND #$FF00 ;the first byte acts as a delay for the second byte to increase
	CMP !CycleSpeed : BMI +				;this is in 16bit instead of 8bit because it doesn't save much if any space and wastes cycles
	TRB !W_Hyper_index				;same trick with TRB here but with only the first byte
	INC !W_Hyper_index
	+
   %inc(!W_Hyper_index, #$0100)
	RTL

.hyper_table
	db $08, $1C, $30, $44, $58, $6C, $80, $94, $A8, $BC

; --- FelicityVi (reformatted and slightly modified by quote58) ---
; this will correctly get the percentage to the hundreths in the form of individual digits for drawing to the screen
;- collected * 100
;	- product / total
;		- remainder -> decimal
;		- quotient / 10
;			- remainder -> Ones
;			- quotient / 10
;				- quotient -> Hundreds
;				- remainder -> Tens
;- decimal * 10
;- product / total
;	- quotient -> Tenths
;	- remainder * 10
;		- product / total
;			- quotient -> Hundredths

Get_percent_digits:						;A = current, X = total, return: percent as digits in 06-0E
!Total 		 = $00						;this uses 06-0E instead of starting at 00 or 10 because the sprite drawing routines use 03 and 12-18
!Ones 		 = $06
!Tens  		 = $08
!Hundreds 	 = $0A
!Tenths 	 = $0C
!Hundredths  = $0E
!Decimal	 = $10

	STX !Total : %multiply(#$64)						; c * 100
   %divide_mod(!Total) : STA !Decimal					;(c * 100) / total -> Percentage, Q: whole number, R: decimal
	LDA !R_Quotient : %divide_mod(#$0A) : STA !Ones		; Q / 10, R: ones
	LDA !R_Quotient : %divide(#$0A, !Hundreds, !Tens)	; Q / 10, Q: hundreds, R: tens

	LDA !Decimal : %multiply(#$0A)						; d * 10
   %divide_alt(!Total) : STA !Tenths					;(d * 10) / total -> Q: tenths
	
	LDA !R_Remainder : %multiply(#$0A)					; r * 10
   %divide_alt(!Total) : STA !Hundredths				;(r * 10) / total -> Q: hundredths
	RTL


; ::::::::::::::::::::::::::::::::
; ::: Modular Heads-Up Display :::
; ::::::::::::::::::::::::::::::::

; --- Quote58 ---
; the aim of this hud is to be completely modular, with an hud 'style' being represented by an object in rom (it could always be in ram if you wanted to make one editable in game)
; the hud is given a pointer to the object's location in bank $80, and the hud will use this data to construct the hud
; this is done so that there is maximum versatility in how the hud style is designed while also being easy to edit for all skill levels
; the hud also no longer draws an initial tilemap. Instead, you can give the hud style a tilemap list to draw during init
;
; the hud follows this format:
; Hud_style:
; ...
; .name : dw <pointer to tilemap list>
;		  db <number of modules to process>
;		  db <module 0>
;		  db <module 1>
;		  ...
;
; .name_tiles : db <number of tilemaps to draw>
;				db <location of first tilemap> : dw <pointer to tilemap>
;
;
; the hud is made up of modules and tilemaps, as referenced by the table that constructs each hud
; and they follow distinct formats, with the tilemaps being the same as is used in other parts of this code base
;
; Hud modules are defined as follows:
; Hud_module:
; .name : dw <initial_condition>, <initial_tilemap>
;		  dw <update_flag>
;		  dw <update_method>, <method_arguments>
;
; Hud tilemaps are defined the same way as elsewhere in this code base, which is like so:
; Hud_tilemap:
; .name : dw XXYY	XX = size in tiles horizontally, YY = size in tiles vertically
;		  dw <tile_0>, <tile_1>
;		  dw ...
;
; -------------
; -- Example --
; -------------
;Hud_style:
;.types : dw .default
;
;.default : dw .default_tiles
;			db $0b
;			db $10 : dw Hud_module_reserves
;			db $14 : dw Hud_module_missiles_icon	<-- this is the one used for the example module
;			db $1c : dw Hud_module_supers_icon
;			db $22 : dw Hud_module_powers_icon
;			db $28 : dw Hud_module_grapple_icon
;			db $2e : dw Hud_module_xray_icon
;			db $34 : dw Hud_module_mini_map
;			db $42 : dw Hud_module_etanks
;			db $8c : dw Hud_module_health
;			db $94 : dw Hud_module_missiles_counter
;			db $9c : dw Hud_module_supers_counter
;			db $a2 : dw Hud_module_powers_counter
;
;.default_tiles
;	db $00
;	db $82 : dw Hud_tilemaps_energy
;
; Hud_module:
; .missiles_icon
;	dw Hud_condition_missiles, Hud_tilemaps_missiles_icon
;	dw !C_H_Select, Hud_method_toggle, $01
;
; Hud_tilemaps:
;.energy
;	dw $0401
;	dw $2C30, $2C31, $2C32, $2C33

Hud:
!Num		= $00
!Index      = $02
!XLen       = $04
!YLen       = $06
!ExpectedFlags = $08	;which update flags the specific hud style cares about
!TilePal	= $18

.update_vram							;tilemap
	LDX !W_D0_stack
	LDA #$00C0 : STA $D0,x				;amount
	LDA #$C608 : STA $D2,x				;source
	LDA #$007E : STA $D4,x				;bank
	LDA #$5820 : STA $D5,x				;destination
	TXA : CLC : ADC #$0007
	STA !W_D0_stack
	RTS

.init_specific							;this is a version of the init that will only refresh a single or set of single elements on the hud, it will *not* refresh the entire thing (this is for plms etc.)
   !phb
   !phxy
	STA !ExpectedFlags
	TSB !W_Hud_expect_flags : TSB !W_Hud_update_flags	;this probably actually only needs to TSB the update flags, but I might as well do the expect as well

	LDA !W_Hud_type : ASL : TAY
	LDA Hud_style_types,y : TAX

	LDA $0002,x : AND #$00FF : STA !Num
	-
	LDA $0003,x : AND #$00FF : STA !Index
	LDA $0004,x
	PHX : TAX
	LDA !ExpectedFlags : BIT $0004,x : BEQ ++
	LDA $0000,x : BEQ + : JSR ($0000,x) : BCC ++
	+
	LDA $0002,x : BEQ ++ : TAX
	JSR Hud_method_draw_tilemap
	++
	PLX
	INX #3
	DEC !Num : BPL -
	JSL .running_init
   !plxy
   !plb
	RTL

.init
   !phb
   !phxy

	LDX #$00C0							;clear the base tilemap for the hud
	-
	LDA #$0C0F : STA !W_HUD_tilemap,x
	DEX #2 : BPL -

	LDA #$5800 : STA !R_VRAM_low
	LDA #$0080 : STA !R_VPORT
	JSL !HDMA_Transfer					;this transfer is to clear the top line of the hud, if you're not using it
	db $01, $01, $18					;instead of pulling a static line from rom, we're just going to use the fact that the start of the tilemap is clear currently
	dl $7EC608							;and then pull from that instead, since we'll be clearing the tilemap later anyway
	dw $0040

	SEP #$20 : LDA #$02 : STA !R_DMA : REP #$20

	LDA #$0001 : STA !W_Mini_map_mirror
	LDA #$0461 : STA !W_Hud_update_flags
	
	LDA !W_Hud_type : ASL : TAY
	LDA Hud_style_types,y : TAY : STA !W_Hud_style

	; first 2 bytes pointer points to static tiles
	; this loop draws the static tilemaps into the hud
	LDA $0000,y : BEQ + : TAX
	LDA $0000,x : AND #$00FF : STA !Num
	-
	LDA $0001,x : AND #$00FF : STA !Index
	PHX
	LDA $0002,x : TAX : JSR Hud_method_draw_tilemap
	PLX
	INX #3
	DEC !Num : BPL -

	+
	; this handles setting the expected flags base, as well as drawing any base tilemaps for modules
	STZ !ExpectedFlags
	LDA !W_Hud_style : TAX
	LDA $0002,x : AND #$00FF : STA !Num
	-
	LDA $0003,x : AND #$00FF : STA !Index
	LDA $0004,x
	PHX : TAX
	LDA $0000,x : BEQ + : JSR ($0000,x) : BCC ++
	+
	LDA $0004,x : BEQ + : TSB !ExpectedFlags
	+
	LDA $0002,x : BEQ ++ : TAX
	JSR Hud_method_draw_tilemap
	++
	PLX
	INX #3
	DEC !Num : BPL -
	LDA !ExpectedFlags : STA !W_Hud_expect_flags

	JSL !Init_mini_map
	JSL .running_init

   !plxy
   !plb
	RTL

.running
   !phb
	STZ !W_Hud_update_flags
	; --- the address mirrors with their update flag changes go here ---
	incsrc Code/data/hud/hud_mirrors.asm
	; ------------------------------------------------------------------

	LDA !W_Hud_update_flags : AND !W_Hud_expect_flags : BEQ .end
	BRA +

.running_init							;extra branch so the init can skip the update flag stuff
   !phb
	+
	LDA !W_Hud_style : TAY
	LDA $0002,y : AND #$00FF : STA !Num
	-
	LDA $0004,y : TAX
	LDA $0004,x : BEQ + : BIT !W_Hud_update_flags : BEQ ++
	+
	LDA $0003,y : AND #$00FF : STA !Index
	PHY : JSR ($0006,x) : PLY
	++
	INY #3
	DEC !Num : BPL -
	JSR .update_vram
.end
   !plb
	RTL

.toggle_click							;this will make a click sound if any weapon toggle icon needs to be updated
	PHA
	LDA !W_Move_type : AND #$00FF
	CMP #$0003 : BEQ +					;if samus is not spin jumping
	CMP #$0014 : BEQ +					;or wall jumping
	LDA $0D32 : CMP #$C4F0 : BNE + 		;has started grapple
	LDA !W_Pause_time : BNE + 			;and time isn't paused
	LDA #$0039 : JSL $809049			;then play click sound
	+
	PLA
	RTS

; ::: data for the hud skeleton like the module list and static tiles pointer go here :::
Hud_style:
; the default is a single hud, with default tile data
; however, to add another hud, it's as easy as adding it to the table the same way it's set up here

; 'types' is the table of pointers for the huds
.types : dw .default

; here you would put the hud referenced in 'types'
.default : dw .default_tiles : incsrc Code/data/hud/default.asm

; and this is where the tile data table referenced in the individual hud table goes
.default_tiles
	db $01
	db $82 : dw Hud_tilemaps_energy
	db $3E : dw Hud_tilemaps_minimap_side

; ::: the data for all the modules goes here :::
Hud_module:
incsrc Code/data/hud/module_data.asm

; ::: this is where all the tilemaps are stored :::
Hud_tilemaps:
incsrc Code/data/hud/hud_tilemaps.asm

; ::: all methods used by the modules go here :::
Hud_method:
incsrc Code/data/hud/hud_methods.asm

; ::: methods for checking conditions go here :::
Hud_condition:
.missiles
	LDA !W_Missiles_max : BEQ .clear
	SEC
	RTS
.supers
	LDA !W_Supers_max : BEQ .clear
	SEC
	RTS
.powers
	LDA !W_Powers_max : BEQ .clear
	SEC
	RTS
.grapple
	LDA !W_Items_equip : BIT !C_I_grapple : BEQ .clear
	SEC
	RTS
.xray
	LDA !W_Items_equip : BIT !C_I_xray : BEQ .clear
	SEC
	RTS
.reserves
	LDA !W_Reserves_type : CMP #$0001 : BNE .clear
	SEC
	RTS
.charge
	LDA !W_Beams_equip : BIT !C_I_charge : BEQ .clear
	SEC
	RTS
.speed
	LDA !W_Items_equip : BIT !C_I_speed : BEQ .clear
	SEC
	RTS
.clear
	CLC
	RTS

print "End of free space (80FFFF): ",pc







