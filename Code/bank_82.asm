lorom

; because the arrangement of sprite gfx in vram during the pause screen has changed, the sprites needed to be adjusted
incsrc Code/data/subscreens/pause_sprites_vanilla.asm

; --- Quote58 ---
; this is misc stuff that needed to be adjusted for various reasons for BE
org $82F088 : dw $F08E, Moonwalk_option, $F0B2
org $828FE4 : STA !W_CGRAM_Backup,x		;in vanilla, this is stored to and loaded from 7E:3300, which is also used by message boxes
org $82A2EE : LDA !W_CGRAM_Backup,x		;this was fine, because message boxes couldn't be used on the subscreen. However, now that they can, this ram has been changed to 7F
org $82965F								;because of moving gfx around, the tilemaps for the area names need to be rewritten
table Code/data/subscreens/text_subscreen.txt
Map_names: : dw .crateria, .brinstar, .norfair, .w_ship, .maridia, .tourian, .ceres, .tourian
.crateria : dw "__crateria__"			;it's also now convenient to change them though
.brinstar : dw "__brinstar__"
.norfair  : dw "__norfair___"
.w_ship   : dw "wrecked_ship"
.maridia  : dw "__maridia___"
.tourian  : dw "__tourian___"
.ceres    : dw "___ceres____"
org $82B634 : NOP #3					;this was to prevent the subscreen from indexing something, but is it still required??
org $82D961 : LDA !C_Colour_speed		;speed that the gradual colour change routine uses when moving to/from black
org $828063 : JSL Hud_init				;initialise HUD
; end of misc stuff

; :::						   :::
; ::: Start of Game State code :::
; :::						   :::
org $82893D
; because of the debug stuff being removed from this routine,
; there are now 2 extra free bytes before the game state table
Game:
	PHK : PLB : REP #$20
	STZ !W_Game_state					;set the gamestate to default 0 before entering game loop for first time
	CLI									;ensures interrupt commands can still happen??
	
.loop
	PHP
	REP #$30							;preserve the processor state and set all registers to 16 bit before going into the main game functions
	JSL $8884B9							;hdma object handler
	JSL !Random_num						;generate a new random number
	JSL $808B1A							;clear OAM high X bits and sizes
	STZ !W_OAM_index					;clear OAM index
	STZ $071D : STZ $071F : STZ $0721	;clear samus sprite DMA data pointers
	
	LDA !W_Game_state
	AND #$00FF : ASL : TAX				;prep game state index for jump table
	JSR (Game_state,x)					;execute the current game state
	
	JSL !Handle_sounds					;handles all sound effects
	JSL $80896E							;finalize OAM (sprites to Y=0xF0)
	LDA !W_Held : STA !W_Held_last		;update previous controller 1 input
	JSL !Wait_for_NMI					;wait for IRQ interrupts
	PLP
	BRA .loop							;continue the game loop

org $828981
Game_state:
	dw .start_reset, .opening, .game_options, .null, .save_files, .loading_map
	dw $8000, $8B20, .gameplay, $E169, .load_new_room, .door_transition, .fade_to_subscreen
	dw .setup_subscreen, .load_subscreen, .subscreen, .fade_from_subscreen
	dw .load_gameplay, $93A1, $DC80, $DCE0, $DD71, $DD87, $DD9A, $DDAF, $DDC7, $89E0
	dw .reserve_tank_auto

org $8289DB
.debug_menu  : JSL $818CF4 : RTS		;game state $1D
.game_over   : JSL $8190AE : RTS		;game state $1A
.save_files  : JSL $8193FB : RTS		;game state $04
.loading_map : JSL $819E3E : RTS		;game state $05
org $828AE4 : .start_reset				;game state $00
org $82EB9F : .game_options				;game state $02
org $828B08
.opening : JSL $8B9A22 : RTS			;game state $01
.null    : RTS							;game state $03

org $828B44								;game state $08 (main gameplay)
; --- Quote58 ---
; this is the main game state for regular gameplay
; there is a bit of extra space from removing the debug stuff (about 25 bytes left currently)
; and if you want to view the performance of any of these routines, just use the %show_code() macro
; which takes a brightness and a string as arguments
; for ex. %show_code(6, "JSL Hud_running") in place of JSL Hud_running to view the performance of the hud

.gameplay
	PHP
	REP #$30
	JSL $A08EB6							;Determine which enemies to process
	JSL $8DC527							;Special background lighting. Very rarely used	; also used for updating heat palette?	
	JSL $90E692							;JSR ($0A42) - handles controller input for game physics
	JSL $A09785							;Samus Projectile handler (mostly for handling bomb jumping and reflected projectiles, but technically it's for any of her projectiles)	
	JSL $A08FD4							;Enemy routines (but can still be killed by power bombs)
	JSL $90E722							;Handles Samus' movements and pausing? JSR ($0A44)
	JSL $868104							;Handles enemy/room projectiles/objects
	JSL $8485B4							;Handles PLMs
	JSL $878064							;Handle misc. animations (spikes, FX1)
	JSL $A09894							;Enemy/Room projectiles/objects collisions with Samus. Only does default routine, no customizable options
	JSL $A0996C							;Enemy/Room projectiles/objects collisions with Samus' projectiles
	JSL $A0A306							;Process enemy power bomb interaction
	JSL $9094EC							;Room scrolling
	JSL $A0884D							;Something for sprites and sounds
	JSL $A09726							;Something for the graphic update table
	JSL Hud_running						;Hud running routine
	JSL Run_every_frame					;Misc routines that need to run every frame during the main gameplay state
	JSL $80A3AB							;Handles the movement of layer 1 and 2
	JSL $8FE8BD							;Runs 'room asm'
	JSR $DB69							;Handles game time. And kills Samus (!)
	JSL Screen_shake					;Handle room shaking (now with some extra stuff) <--this is in A0
	JSL $A09169							;Handles Samus getting hurt <--hook for backflip is here now
	PLP
	RTS

org $82DC10
; --- Quote58 ---
; reserve tanks no longer zero themselves when you reach full health
; this refill routine was also written horribly in vanilla and is now 36 bytes shorter
; it can also be accessed from outside this bank, in case other game states want to use it

.reserve_tank_auto						;game state $1B
	PHP
	REP #$30
	JSL .reserve_tank_refill : BCC +	;run reserve tank routine
	STZ !W_Pause_time					;unfreeze time
	LDA #$0008 : STA !W_Game_state		;make sure the game state is still main gameplay
	LDA #$0010 : JSL !Disable_samus		;unfreeze samus
	+
	JSR Game_state_gameplay				;run the main gameplay state
	JSL $90EAAB							;low health check
	PLP
	RTS

.reserve_tank_refill
   !phb
	LDA !W_Reserves : BEQ ++
	LDA !W_Current_frame : BIT #$0007 : BNE +
	LDA #$002D : JSL $809139
	+
	LDA !W_Health : CMP !W_Health_max : BEQ ++ : BPL ++
	INC !W_Health : DEC !W_Reserves : BEQ ++
   !plb
	CLC
	RTL
	++
   !plb
	SEC
	RTL

org $82E1B7
; --- Quote58 ---
; this is the game state entered when hitting a door transition block
; and this is where you can replace the vanilla door transition handling routines with PB's new ones, or your own

.load_new_room							;game state $0A
	PHP
	PHB
	REP #$30
	LDA #$0001
	STA $0797 : STA $0795				;set flag for door transitioning (a little weirdly)
	STZ !W_Disable_minimap				;in case the current room is a boss room and we need to re-enable it
	STZ !W_Save_used					;this isn't super important anymore actually with my new save station stuff
   %draw_samus_et_all()
	JSR $DDF1							;load destination room CRE bitset

   %pealt(7E)
	LDX #$00FE : LDA #$0000
	-
	STA $C200,x : STA $C300,x
	DEX #2 : BPL -
	
	LDA $C012 : STA $C212				;make sure the colours in the cre that are used for the doors and HUD are preserved
	LDA $C014 : STA $C214
	LDA $C01A : STA $C21A
	LDA $C01C : STA $C21C
	LDA $C022 : STA $C222
	LDA $C024 : STA $C224
	LDA $C026 : STA $C226
	LDA $C03A : STA $C23A

	LDA $07B3 : ORA $07B1				;special gfx bitflag for bosses that overwrite the cre
	BIT #$0001 : BNE +
	LDA $C028 : STA $C228
	LDA $C02A : STA $C22A
	LDA $C02C : STA $C22C
	LDA $C02E : STA $C22E
	LDA $C038 : STA $C238
	LDA !W_Timer_status : BEQ +			;why does the timer need to preserve colours that aren't sprite related?
	LDA $C1A2 : STA $C3A2
	LDA $C1A4 : STA $C3A4
	LDA $C1A8 : STA $C3A8
	LDA $C1BA : STA $C3BA
	JSL !Draw_timer
	+

	JSL $848250							;clear sounds
	LDA #$0071 : JSL $8090A3			;??
	LDA #$FFFF : STA !W_Disable_sfx		;disable sounds

	; If using the Project Base super fast door transitions
	; replace the following LDA with a reference to the new doors
	; like this: LDA Door_transition_main
	LDA #$E29E : STA !W_Transition_state
	INC !W_Game_state
	PLB
	PLP
	RTS

.door_transition						;game state $0B
	PHP
	PHB
	REP #$30
	PEA $E291
	JMP (!W_Transition_state)
	LDA !W_Timer_status : BEQ +
	JSL !Draw_timer
	+
	PLB
	PLP
	RTS

org $828CCF
; --- Quote58 ---
; this is where the subscreen game state code is handled
; much of it has been rewritten and reworked for the new subscreen

.fade_to_subscreen						;game state $0C
	PHP
	REP #$30
	JSR .gameplay						;main engine for main game
	JSL !Fade_out						;handle fading out
	LDA !W_Screen_disp
	AND #$000F : BNE +					;wait for screen to be fully dark before pausing
	JSL !Enable_NMI						;enable NMI with $84 options
	STZ $0723 : STZ $0725				;clear the frame delay and frame counter for screen brightness
	INC !W_Game_state
	+
	PLP
	RTS

.setup_subscreen						;game state $0D
   !phb
	JSL !Disable_hdma					;we're not using hdma in the subscreen
	SEP #$20
	LDA #$00 : STA !W_Active_HDMA		;clear any active hdma channels
			   STA !R_HDMA				;clear the hdma enable channel
	REP #$20
	JSL $87800B							;disables misc animations
	JSR $8D51							;sets up all the dma registers and vram designation
	
	PHP : PHB : PHK
	PEA $8D13
	JML [$0601]							;jumps to $88:83E1
	PLB : PLP
	
	JSL $82BE17							;cancels any sound effects
	JSR $8DBD							;setting up the mirror ram of all the main registers (screen designations, scrolls, and the scroll percentage $091B)
	JSL Subscreen_transfer_misc_gfx		;transfers the misc gfx used by all pause screens, as well as the HUD gfx, to vram
	JSR $8FD4							;backs up the current palette into 7E3300 and then loads the palette used by the pause screen from B6F000 into 7EC000
	JSR .prep_for_subscreen				;set up the addresses, tilemaps, scrolling, registers, etc.
	
	LDA !C_Fade_speed : STA $0723
						STA $0725
	STZ $074D							;probably an animation index or something related
	LDA #$0001 : STA $073B
	STZ $05FD  : STZ $05FF				;clear the direction for map scrolling and the timer for scrolling
	JSL !Clear_layer_3					;Add VRAM $5880..677F = 184Eh (clear layer 3) <-- because layer 3 is the **BACKGROUND** in the subscreen (what?!) <-- you could do some cool hdma shit with the background
	INC !W_Game_state
   !plb
	RTS

org $829009
.prep_for_subscreen
   !phb
	JSR $A09A							;set up the screen registers (this is especially important with kraid because the bg3 base address needs to be fixed)
	JSR $A0F7							;clear all the scroll registers
	JSR Subscreen_tilemap_transfer_buttons		;draw the buttons according to the subscreen
	JSR $9EC4							;set up the mini map??
   !plb
	RTS

org $8290C8
.load_subscreen							;game state $0E (this gamestate could be combined with the main subscreen one, but it would mess up the indexing and there's no real point in that)
	PHP
	REP #$30
	LDA !W_Pause_default : STA !W_Pause_screen	;set up which pause screen to start on
	STZ !W_Pause_screen_tar				;there is no target because it starts on the default
	STZ !W_Pause_index
	INC !W_Game_state
	+
	PLP
	RTS

.subscreen								;game state $0F
	PHB
	PHK
	PLB
	LDA #$0003 : JSL $808146			;update held input ([A] defines 'held' in the routine, so for this it's 3 frames)
	JSL Subscreen_main					;main pause routine
	JSL Hud_running						;HUD routine
	JSR $A92B							;cycle palette for the various objects on the pause screen
	PLB
	RTS

org $829324
.fade_from_subscreen					;game state $10 (this gamestate doesn't actually need to exist anymore, however there are parts of the game that check specific game state values, so there's no point removing it)
	PHP
	REP #$30
	INC !W_Game_state
	PLP
	RTS

org $829367
.load_gameplay							;game state $11
	PHP
	REP #$30
	JSR $A2BE							;load sprites
	JSR $A2E3							;loads the palettes, calculates bg scrolls, updates beam gfx, and more
	JSL $80A149							;set up: IRQ, NMI, tilesets, palette, library, plm gfx, display viewable room
	JSR $8E19							;backup of scrolls -> scrolls
	JSR $8D96							;dma transfer for tilemap maybe? something $1000 bytes large
	REP #$30
	LDA !C_Fade_speed : STA $0723
						STA $0725
	PHP : PHB : PHK
	PEA $938D
	JMP [$0604]
	JSL !Enable_hdma					;enable hdma
	JSL $878000							;enable animated tiles objects
	JSL $82BE2F							;queue samus movement sfx
	PLB : PLP
	INC !W_Game_state
	PLP
	RTS

; :::						 :::
; ::: End of Game State code :::
; :::						 :::



; :::									 :::
; ::: Start of Subscreen Processing Code :::
; :::									 :::

org $82AC4F
Subscreen:
.main
   !phb
	LDA !W_Pause_fade : CMP #$0001 : BEQ .fade_in
						CMP #$0002 : BNE .not_fading
.fade_out
	JSL !Fade_out
	SEP #$20
	LDA !W_Screen_disp : CMP #$80 : BNE .fading
	JSL !Enable_NMI
	REP #$20
	LDA #$0000 : STA !W_Pause_fade
	LDA !W_Pause_screen_tar : CMP #$FFFF : BNE +
	INC !W_Game_state : BRA .end
	+
	STA !W_Pause_screen
	STZ !W_Pause_index
	BRA .end

.fade_in
	JSL !Fade_in
	SEP #$20
	LDA !W_Screen_disp : CMP #$0F : BNE .fading
	JSR .draw_current_screen
	INC !W_Pause_index
	LDA #$0000 : STA !W_Pause_fade
	BRA .end

.fading
	LDA !W_Pause_screen_tar : BPL +
	JSL $82A5F1
	+
	JSR $A56D								;draw the flashing button sprite on a button according to 0751
	JSR .draw_current_screen : BRA .end

.not_fading
	REP #$30
	LDA !W_Pause_screen : ASL : TAX
	LDA .screen_type,x : STA !W_Screen_type
	JSR .draw_current_screen
.end
   !plb
	RTL

.draw_current_screen
	REP #$20
	LDA !W_Pause_index
	ASL : CLC : ADC !W_Screen_type : TAX
	JSR ($0000,x)
	RTS

.screen_type : dw .map_screen, .equip_screen, .options_screen,

.map_screen     : dw .map_load, .map_in, .map, .map_out
.equip_screen   : dw .equip_load, .equip_in, .equip, .equip_out
.options_screen : dw .options_load, .options_in, .options, .options_out

.check_input
	JSR $A59A								;draw the button sprites
	JSR .input_start : BCS +				;checks for start button input
	JSR .input_lr
	+
	RTS
	
.input_lr
	PHP
	REP #$30
	LDA !W_Pause_screen : ASL : TAX
	LDA $05E1 : AND #$0030 : BEQ .input_end
				CMP !C_B_L : BEQ .aim_down
				CMP !C_B_R : BNE .input_end
.aim_up
	LDA .move_right,x : BMI .input_end : STA !W_Pause_screen_tar
	LDA #$0002 : BRA +
.aim_down	
	LDA .move_left,x : BMI .input_end : STA !W_Pause_screen_tar
	LDA #$0001
	+
	STA $0751								;which button lights up for changing screens
	INC !W_Pause_index
	JSR Subscreen_tilemap_transfer_buttons
	LDA $C10A : STA $0729
	LDA #$0038 : JSL $809049
.input_end
	PLP
	RTS

.move_right : dw $0001, $FFFF, $0000
.move_left  : dw $0002, $0000, $FFFF

.input_start
	PHP
	REP #$30
	LDA $05E1 : AND !C_B_start : BEQ +
	LDA #$0039 : JSL $809049
	LDA !C_Fade_speed : STA $0723 : STA $0725
	JSR Subscreen_tilemap_transfer_unpausing
	LDA #$000B : STA $0729
	LDA #$FFFF : STA !W_Pause_screen_tar
	INC !W_Pause_index
	PLP
	SEC
	RTS
	+
	PLP
	CLC
	RTS
	RTS

.transfer_misc_gfx
	PHP
   %dma_vram(38,00, 80, $B6E000, 0800)		;transfer the initial pause screen tilemap for BG2 to vram
   %dma_vram(00,00, 80, !GFX_Main_T, 1A00)	;transfer the misc pause screen gfx (map tiles, L/R/EXIT, letters, pipes)
   %dma_vram(26,00, 80, !GFX_Main_S, 0E00)	;transfer the sprite gfx data (only half, because the other half is transfered based on the screen)
	PLP
	RTL

; ::: Map Screen handling routines :::
.map_load
	REP #$20
	JSR Subscreen_tilemap_transfer_map
	LDA #$0080 : JSR $9E27				;set up map scrolling
	JSR .setup_misc
	STZ $073F
	INC !W_Pause_index
	RTS
.map_in
	JSR .map_out						;map_out just draws the sprites so we can use that here too
	LDA #$0001 : STA !W_Pause_fade
	RTS
.map
	REP #$30
	JSR .check_input					;checks for L/R input
	;JSL Map_screen_draw_sprites <-- good place to draw extra sprites on the map
	JSL $82B934							;draw scroll arrows
	JSL $82925D							;main map scrolling routine
	JSR $B9C8							;draws cursor over position
	JSL $82B672							;draws icons for all the things
	JSL $82BB30							;draws map sprites
	RTS
.map_out
	;JSL Map_screen_draw_sprites <-- good place to draw extra sprites on the map
	JSL $82BB30
	JSR $B9C8
	JSL $82B672
	LDA #$0002 : STA !W_Pause_fade
	RTS

; ::: Equipment Screen handling routines :::
.equip_load
	REP #$20
	JSR Subscreen_tilemap_transfer_equip
	JSR .setup_misc
	JSL Equip_screen_init
	INC !W_Pause_index
	RTS
.equip_in
	LDA #$0001 : BRA .equip_end
.equip
	JSR .check_input					;checks for L/R input
	JSL Equip_screen_main				;main equip screen routine
	RTS
.equip_out
	LDA #$0002
.equip_end
	STA !W_Pause_fade
	JSL Equip_screen_draw_sprites
	RTS

; ::: Options Screen handling routines :::
.options_load
	REP #$20
	JSR Subscreen_tilemap_transfer_options
	JSR .setup_misc
	JSL Options_screen_init
	INC !W_Pause_index
	RTS
.options_in
	LDA #$0001 : BRA .options_end
	RTS
.options
	JSR .check_input					;checks for L/R input
	JSL Options_screen_main
	RTS
.options_out
	LDA #$0002
.options_end
	STA !W_Pause_fade
	RTS

; ::: misc :::
.setup_misc
	STZ $073F
	LDA $C10C : STA $072B
	LDA !C_Fade_speed : STA $0723 : STA $0725
	STZ !W_Pause_list : STZ !W_Pause_entry

.restore_palette
	LDX #$0200
	-
	LDA $B6F000,x : STA $7EC000,x
	DEX #2 : BPL -
	RTS

Subscreen_tilemap_transfer:
.map
   %dma_wram(7E,38,00, $B6E000, 0800)	;transfer the map BG2 tilemap into wram (it's the initial tilemap)
   %dma_vram(0D,00, 80, !GFX_Map_T, 2600)	;transfer the gfx for the item text, the samus sprite is transfered during init in equip
   %dma_vram(20,00, 80, !GFX_Map_S, 0C00)	;transfer the gfx for sprites (the line from list to samus), cylces, and reserves
	JSR Subscreen_tilemap_transfer_buttons
	JSL $8293C3								;this routine simultaniously clears layer 1 and draws the map tiles onto it
	RTS

.button_config
   %dma_wram(7E,39,00, Button_config_init_tilemap, 0700)
	BRA +

.equip
   %dma_wram(7E,39,00, Equip_init_tilemap, 0700)
   %dma_vram(0D,00, 80, !GFX_Equip_T, 0C00)	;transfer the gfx for the item text, the samus sprite is transfered during init in equip
   %dma_vram(20,00, 80, !GFX_Equip_S, 0C00)	;transfer the gfx for sprites (the line from list to samus), cylces, and reserves
	+
	BRA .end

.options
   %dma_wram(7E,39,00, Options_init_tilemap, 0700)
   %dma_vram(0D,00, 80, !GFX_Option_T, 2600) ;transfer the gfx for the options stuff
   %dma_vram(20,00, 80, !GFX_Option_S, 0C00) ;transfer the gfx for sprites, cycles, and other misc stuff
.end
	REP #$30
	LDX #$1000
	-
	LDA #$0000 : STA $7E4000,x
	DEX #2 : BPL -
   %dma_vram(30,00, 80, $7E4000, 1000)
	JSR Subscreen_tilemap_transfer_buttons
	LDA !W_BG1_X : STA !W_BG4_X
	LDA !W_BG1_Y : STA !W_BG4_Y
	STZ !W_BG1_X : STZ !W_BG1_Y
	STZ $0741 : LDA #$000F : STA $072D
	RTS

.unpausing
	LDA #Unpausing_tilemap_buttons : BRA +
	
.buttons
	LDA !W_Pause_screen : ASL : TAX
	LDA .source_tiles,x
	+
	STA !src
	LDA #$0080 : STA !amt
	LDA #$0083 : STA !bnk
	LDA $59 : AND #$00FC : XBA
	CLC : ADC #$0320 : STA !dst
	JSL VRAM_DMA
	RTS

.source_tiles
	dw Map_init_tilemap_buttons, Equip_init_tilemap_buttons, Options_init_tilemap_buttons, Unpausing_tilemap_buttons, Unpausing_tilemap_buttons

print "End of original equipment screen code (82B5E8): ",pc


org $82F710
; ::: free space in bank 82 :::

; --- Quote58 ---
Moonwalk_option:
	LDA !C_O_Moon_walk : PHA : JSL Check_option_bit : BCC +
	PLA : JSL Clear_option_bit
	LDA #$0000 : BRA ++
	+
	PLA : JSL Set_option_bit
	LDA #$0001
	++
	STA !W_Moon_walk
	JSR $F0B9								;this changes the palette for a given set of tiles on the options screen based on which menu item it is and if that item's bit is set or not
	RTS

print "End of free space (82FFFF): ",pc
























