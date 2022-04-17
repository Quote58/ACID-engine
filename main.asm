lorom

; ---											 ---
; --- This is the main code file for ACID Engine ---
; A(rbitrarily) C(ompilable) I(mprovement) D(irectory)
; ---											 ---

; ****** MAIN CONFIGURATION ARRAY ******
; this is where you can define which of the built in patches will be active
; these option bits are defined as either aquired or equipped, just like items, but by default they are the same
; if a settings screen is used, you can always set some to be off by default but available to the player
; for example, this is vanilla:
; !Main_Config_1 = #%0100010001100110
; !Main_Config_2 = #%0000000001010000
!Main_Config_1 = #%0111011011011101
!Main_Config_2 = #%0000010111011110
!Main_Config_3 = #%0000000000000000
!Main_Config_4 = #%0000000000000000
!Main_Config_Acquired_1 = !Main_Config_1
!Main_Config_Acquired_2 = !Main_Config_2
; **************************************

;this is basically the header file for the project, where everything is imported and brought together
;but it is also a RAM map of commonly used addresses for WRAM, SRAM, VRAM, Hardware Registers, as well as constants
;addresses are denoted as such:
;W_ = WRAM address
; -> W_A_ = WRAM Area palette
; -> W_S_ = WRAM Sprite palette
; -> W_DGB_ = WRAM Debug related memory
;S_ = SRAM address
;V_ = VRAM address
;E_ = Enemy specific WRAM
;ER_= Enemy/Room projectile WRAM
;R_ = Register
;P_ = PLM specific WRAM
;C_ = Constant
; -> C_B_ = Hardware button value
; -> C_I_ = Item bit value in main items aquired/equipped array
; -> C_H_ = HUD update event bit
; -> C_O_ = Option bits
; -> C_E_ = Event bits
; -> C_D_ = Default value for a save file
;H_ = HDMA specific Constant
;GFX_ = location in rom of something that gets imported into the rom by the engine, so that it can be adjusted to fit the project
;
;***Any variable *without* a type identifier is treated as a local variable, and may be changed based on context***

; ---
; --- EXCEPTIONS TO ABOVE RULE:
; ---
; ::: General use definitions :::
!pha				= "PHP : REP #$30 : PHB : PHX : PHY"
!pla			 	= "PLY : PLX : PLB : PLP"
!phb		  		= "PHP : PHB : PHK : PLB : REP #$30" ;this is used at the start of a lot of routines that change the bank byte
!plb		  		= "PLB : PLP"
!phrb		  		= "PHA : PHX : PHY : PHB"
!plrb		  		= "PLB : PLY : PLX : PLA"
!phs		  		= "PHP : REP #$30 : PHX : PHY"
!pls		  		= "PLY : PLX : PLP"
!phxy		  		= "PHX : PHY"
!plxy		  		= "PLY : PLX"
!phr		  		= "PHA : PHX : PHY"
!plr		  		= "PLY : PLX : PLA"
!amt		  		= $02				;amount of data to transfer in a VRAM DMA
!src		  		= $04				;source of data within the bank
!bnk		  		= $06				;bank of source data (destination bank needed for VRAM)
!dst		  		= $08				;destination in VRAM
!wait_16 			= "PHA : PLA : PHA : PLA"
!wait_8 			= "PHA : PLA"		;just wastes 8 cycles

; ::: Important routines in ROM :::
;*called with a JSL unless otherwise specified*
!Angle_calc			 = $A0C0AE			;[$14 = Ypos, $12 = Xpos] rough calculation of an angle
!Sine_neg			 = $A0B0C6			;[A = angle, return: !Trig_result = new x value] negative sine multiplication 
!Cosine				 = $A0B0B2			;[A = angle, return: !Trig_result = new y value] regular cosine multiplication
!Absolute_value		 = $A0B067			;[A = input, return: !Trig_result = absolute value of A] Get the absolute value of A
!Multiply16			 = $A0B6FF			;[$26 = multiplandA, $28 = multiplandB, return: $2A = 32bit result] multiplies two 16 bit numbers with result in $2A
!Update_palette		 = $91DEBA			;[N/A] resets samus' palette depending on her suit
!Update_target		 = $91DEE6			;[N/A] resets samus' target palette depending on her suit
!Random_num			 = $808111			;[return: A = random number, $05E5 = random number] generates a new random number in A (and stored to 05E5)
!Draw_sprite		 = $81879F			;[$12 = Ypos, $14 = Xpos, $16 = palette, Y = pointer to tilemap] draws a sprite from misc vram
!Draw_pause_sprite	 = $81891F			;[Y = Ypos, X = Xpos, A = index for table of tilemap pointers in 82]
!Check_bit			 = $80818E			;[A = bit to check, return: $05E7 = bit (A&7), X = A>>3] masks the nth bit of an array (used for very large arrays such as plm array) ($05E7 = A % 8, x = A / 8 ??)
!Check_event		 = $808233			;[A = event bit to check, return: SEC = event is set, CLC = event is not set] checks an event bit against the event array
!Set_event			 = $8081FA			;[A = event bit to set]
!Clear_event		 = $808212			;[A = event bit to clear]
!Set_boss_bit		 = $8081A6			;[A = bit to set for current area]
!Clear_boss_bit		 = $8081C0			;[A = bit to clear for current area]
!Check_boss_bit		 = $8081DC			;[A = bit to check for current area, return: carry (set = alive, clear = dead)]
!Fade_out			 = $808924			;[N/A] Slowly fades the screen to black
!Fade_in			 = $80894D			;[N/A] Slowly fades the screen into the target palette
!Get_PLM_XY			 = $848290			;[X = plm index, return: updated !PLM_Xpos and !PLM_Ypos] multiplies PLM's location in blocks with the room width
!Make_simple_plm	 = $8484E7			;[A = plm header] creates a plm with no arguments and zero'd variables, at the location in !Current_block
!Message_box 		 = $858080			;[A = index of message box to create] when this routine is run, it's the only thing that runs, and handles input and everything itself
!Pause_sounds		 = $82BE17			;[N/A] stops all sounds
!Resume_sounds		 = $82BE2F			;[N/A] resumes all sounds
!Handle_sounds		 = $8289EF			;[N/A] handles all sound effects
!Handle_music_queue  = $808F0C			;[N/A]
!Update_input		 = $809459			;[N/A] updates !Held and !Pressed
!Wait_for_vblank	 = $8082C5			;[N/A] waits until the frame has been drawn and vblank is happening (the time when the electron gun is off while it moves back to the top of the screen)
!Wait_for_NMI		 = $808338			;[N/A] sets NMI request flag and then waits for a response
!Enable_NMI			 = $80834B			;[N/A] enable NMI with $84 options
!Disable_hdma		 = $888293			;[N/A] clears the hdma flag at $18B0
!Enable_hdma		 = $888288			;[N/A] sets the hdma flag at $18B0
!HDMA_Transfer		 = $8091A9			;Takes a parameter: first byte tells channel (0..7), next 7 are copied into 43x0-43x6
!Update_beam_gfx	 = $90AC8D			;refreshes what gfx are in the beam position in misc gfx in vram, but also updates the pause screen and it's palette for some reason
!Check_command_timer = $808EF4			;[return: carry clear = no timer, carry set = timer] checks if there's a command timer
!Draw_enemy_sprite 	 = $B4BC26			;[$12 = Xpos, $14 = Ypos, $16 = type, $18 = palette] draws a generic sprite from a list, used by enemies sometimes
!Write_block_bts	 = $82B4 			;*called with a JSR* [A = block value, X = PLM location] used by PLMs to write bts values to the blocks at it's location
!Gradual_pal_change  = $DA02			;*called with a JSR in Bank $82* [uses $7EC402 and $7EC400 as for speed properties] changes the palette to whatever is in palette target
!Save_game			 = $818000			;[A = current save slot] saves the game
!Create_palette_FX	 = $8DC4E9			;[Y = palette fx header in 8D] creates a palette FX object
!Init_mini_map		 = $90A8EF			;sets up the initial position and everything of the minimap based on samus' x/y pos (only called by init hud in vanilla)
!Disable_samus		 = $90F084			;[A = index for routine to use, 0 = disable samus, 1 = enable samus] This routine can be used for other stuff too, but I've only used it for this
!Draw_timer			 = $809F6C			;draws the timer sprite on screen
!Decompress			 = $80B0FF			;47 - 49 holds the source (48 is bank byte), 3 bytes following JSL are the destination
!IRQ_DMA_transfer	 = $E039			;*called with a JSR in Bank $82* sets up a dma tranfer that gets moved with IRQ interrupts
!Update_CGRAM		 = $808395			;unused in vanilla, but fully functional. It simply updates CGRAM without also updating OAM
!Update_BG_scrolls	 = $80A3A0			;used when scrolling to update the BG gfx when scrolling
!Enable_IRQ			 = $80982A			;enables h/v-counter interrupts by setting 4207/9 and $84
!Finalize_OAM		 = $80896E			;clears OAM data, normally used after finishing a frame and prepping for vblank
!Clear_layer_3		 = $80A211			;clears layer 3 at 7E4000, and then moves 7E4000 to vram (uses index 4E at PC D3200 as clear block instead of the established 0F because reasons...)
!Restore_health		 = $91DF12			;[A = amount to restore] restores amount of health in A with all the checks
!Restore_missiles	 = $91DF80			;[A = amount to restore] restores amount of missiles in A with all the checks
!Restore_supers		 = $91DFD3			;[A = amount to restore] restores amount of supers in A with all the checks
!Restore_powers		 = $91DFF0			;[A = amount to restore] restores amount of powers in A with all the checks
!Damage_samus		 = $91DF51			;[A = amount to damage] deals amount of damage in A to samus with all the checks

; ::: Important new routines :::
;*all found in bank $80, and all called with a JSL unless otherwise stated*
;VRAM_DMA			- $80xxxx			 performs a DMA transfer to VRAM with the parametres in $00-$06
;Find_block			- $80xxxx			 takes an X and Y position and returns the corrosponding block from the layer 1 tilemap
;Find_bts			- $80xxxx			 takes an X and Y position and returns the corrosponding block from the bts tilemap
;Is_morphed			- $80xxxx			 checks literally every possible pose where samus could be morphed, returns SEC if morphed
;Check_event_extra  - $80xxxx			 this is an expansion on the event bit check routines for $7ED820, using $7ED822 for extra event bit space
;Set_event_extra	- $80xxxx			 set bit in new event array
;Clear_event_extra	- $80xxxx			 clear bit in new event array
;Pause_game			- $80xxxx			 this will freeze the game in place for A frames but continue to play sounds, using !Wait_for_vblank to wait until the frame has been drawn each iteration

; ---
; --- END OF EXCEPTIONS
; ---

; ::: Constants :::
;defaults
!C_D_Health   		= #$0063			;how much health to give samus for a new save file
!C_D_Missiles 		= #$0000			; || missiles
!C_D_Supers	  		= #$0000			; || super missiles
!C_D_Powers   		= #$0000			; || power bombs
!C_D_Hud			= #$0000			;which hud should it default to
!C_D_Item			= #$0000			;whether the item sfx is a short click or a fanfare
!C_D_Pause    		= #$0000			;which pause screen to default to

;totals
!C_Item_total		= #$0064			;total number of items in the game (this includes all ammo and upgrades) [64h, 100d]
!C_Reserves_total	= 4					;total number of reserves tanks you can obtain in game. This is used primarily to determine how many empty shell tiles to draw

;general game constants
!C_Message_normal	= $0030				;how long the box waits before taking input on a normal message (vanilla is $0168)
!C_Message_short	= $000A				;how long it waits on a short message like map data aquired or health restored
!C_Message_fanfare	= $0168
!C_Open_speed		= $0001				;this controls the speed of every door type opening animation from a single value
!C_Close_speed		= $0002				;same for closing
!C_Flash_speed		= $0003				;how many frames to show the coloured door in between normal door after it's been hit
!C_Flash_wait		= $0008				;how many frames to wait before door starts closing after entering room			
!C_Hyper_beam		= #$1009			;what beam projectile hyper beam uses (vanilla is 1009, which is charged plasma)
!C_Refill_amt		= #$0002			;rate of ammo/health per frame refilled by the ship (and baby metroid if I remember to add that)
!C_Full_spark		= #$0120			;amount in frames for shinespark timer
!C_Fade_speed 		= #$0000			;universal speed of fading brightness in/out
!C_Colour_speed		= #$0004			;speed used by the gradual colour change routine when moving to/from black
!C_Scroll_speed		= #$0008 			;speed of scrolling during door transitions
!C_Transition_speed = #$03				;in vanilla it's 1px for alignment and 4px for transition so the ratio is 1:4, but I'm using 1:2 instead
!C_Full_charge  	= #$003C			;3A is more accurate but the game uses 3C which gives a couple of frames of leeway
!C_Max_charge   	= #$0078			;this is the max value that charge can get to, and is also the threashold for SBA's
!C_F_speed	  		= 4					;how fast you want the morph flash to be (2 = fast, 6 = slow) (must be XX not #$XX because of the rep command in xkas)
!C_Flash_amount 	= "#$!C_F_speed*$4+$6" ;table size = (speed * entries) + size of preflash
!C_Misc_palette 	= #$1A00			;palette for sprites using gfx from misc vram (used in conjunction with !Draw_sprite)
!C_Beam_palette 	= #$1C00			;palette for beam sprites

;the bit value of a given hardware button, used to check against input registers and their ram mirrors
!C_B_up				= #$0800
!C_B_down			= #$0400
!C_B_left			= #$0200
!C_B_right			= #$0100
!C_B_X				= #$0040
!C_B_A				= #$0080
!C_B_B				= #$8000
!C_B_Y				= #$4000
!C_B_select			= #$2000
!C_B_L				= #$0020
!C_B_R				= #$0010
!C_B_start			= #$1000

;the bit value of a given item in samus item array
!C_I_bombs			= #$1000
!C_I_gravity		= #$0020
!C_I_varia			= #$0001
!C_I_screw			= #$0008
!C_I_speed			= #$2000
!C_I_spring			= #$0002
!C_I_morph			= #$0004
!C_I_xray			= #$8000
!C_I_grapple		= #$4000
!C_I_spacejump		= #$0200
!C_I_hijump			= #$0100
!C_I_charge			= #$1000
!C_I_ice			= #$0002
!C_I_wave			= #$0001
!C_I_spazer			= #$0004
!C_I_plasma			= #$0008

;the bit value of a given hud modual in the modual update array
!C_H_Health			= #$0001
!C_H_Missiles		= #$0002
!C_H_Supers			= #$0004
!C_H_Powers			= #$0008
!C_H_Select			= #$0010
!C_H_Input			= #$0020
!C_H_Minimap		= #$0040
!C_H_Charge			= #$0080
!C_H_Magic			= #$0100
!C_H_Spark			= #$0200
!C_H_Reserves		= #$0400

;the bit value of options are single bytes because they are stored in the extra event bit array and 
!C_O_Auto_morph		= #$0000
!C_O_Beam_flicker	= #$0001
!C_O_Beam_trails	= #$0002
!C_O_Morph_flash	= #$0003
!C_O_Spark_exit		= #$0004
!C_O_Low_health	    = #$0005
!C_O_Screen_shake	= #$0006
!C_O_Keep_speed		= #$0007
!C_O_Quick_booster	= #$0008
!C_O_Charge_attract = #$0009
!C_O_Soundfx_toggle	= #$000A
!C_O_Backflip		= #$000B
!C_O_Respin			= #$000C
!C_O_Quickmorph		= #$000D
!C_O_Music_toggle	= #$000E
!C_O_Ball_spark		= #$000F
!C_O_Super_recoil	= #$0010
!C_O_Moon_walk		= #$0011
!C_O_Upspin			= #$0012
!C_O_Spark_move		= #$0013
!C_O_Speed_echoes	= #$0014
!C_O_Auto_save		= #$0015
!C_O_Screw_glow		= #$0016
!C_O_Water_walk		= #$0017
!C_O_Equip_mod		= #$0018
!C_O_Block_reveal	= #$0019
!C_O_Spark_restart	= #$001A

;register 43x0, (first byte) da-i | a = indirect read flag, d = direction, i/f always 0 for hdma
!H_Indirect			= 40				;4 = 0100, d = 0 (normal), a = indirect, - = 0, i = 0 (during hdma)
!H_Direct			= 00				;0 = 0000, d = 0, a = direct, - = 0, i = 0
;register 43x0, (second byte) fttt | i/f always 0 for hdma, ttt = transfer mode (HDMA_#registers_#writes)
!H_1_1				= 00
!H_2_1				= 01
!H_1_2				= 02
!H_2_2				= 03
!H_4_1				= 04
!H_2_2_alt			= 05
;!H_1_2				= 06				;duplicate
;!H_2_2				= 07				;duplicate

;register 21XX where XX is which of the layer scroll registers the hdma is using (or the fixed colour register in the case of 32) 
!H_Fixed_color	    = 32
!H_BG1_H			= 0D				;Background 1 Horizontal scroll register
!H_BG1_V 			= 0E				;Background 1 Vertical scroll register
!H_BG2_H 			= 0F
!H_BG2_V 			= 10
!H_BG3_H 			= 11
!H_BG3_V 			= 12
!H_BG4_H 			= 13				;not used in super
!H_BG4_V 			= 14

; ::: Registers :::
!R_Screen_disp		= $2100				;Screen display register [x---bbbb | x: 0 - screen on 1 = screen off, b = brightness (F = max, 0 = off)]
!R_OAM_desig		= $2101				;OAM Size and Data Area Designation | aaabbccc a = Size, b = Name Selection, c = Base Selection
!R_BG_mode			= $2015				;BG Mode and Tile Size Setting | abcdefff abcd = BG tile size (4321): 0 = 8x8 1 = 16x16, e = BG 3 High Priority, f = BG Mode

!R_CGRAM_addr		= $2121
!R_CGRAM_clr		= $2122
!R_Colour_add		= $2130
!R_Colour_math		= $2131
!R_Fixed_clr		= $2132

!R_MultiplicandA	= $4202				;this must be given an 8bit argument
!R_MultiplicandB	= $4203				;^
!R_Product			= $4216
!R_Dividend			= $4204
!R_Divisor			= $4206				;^
!R_Quotient			= $4214
!R_Remainder		= $4216

!R_BG1_H			= $210D
!R_BG1_V			= $210E
!R_BG2_H			= $210F
!R_BG2_V			= $2110
!R_BG3_H			= $2111
!R_BG3_V			= $2112
!R_VPORT			= $2115
!R_VRAM_low			= $2116
!R_VRAM_high		= $2117
!R_WRAM_low			= $2181
!R_WRAM_mid			= $2182
!R_WRAM_high		= $2183

!R_DMA				= $420B				;dma enable register
!R_HDMA				= $420C				;hdma enable register
!R_PPU_status		= $4212
!R_JOY1_low			= $4218				;this covers the bits for A, X, L, and R
!R_JOY1_high		= $4219				;this covers the bits for B, Y, D-pad, start and select

; ::: VRAM Addresses :::
!V_Layer1_gfx		= #$0000			;$0000 - $47FF = Area graphics
!V_Layer2			= #$2400			;$4800 - $4FFF = Layer 2 tilemap
!V_CRE_gfx			= #$2800			;$5000 - $7BFF = CRE graphics (4 bit)
!V_Layer1_pause		= #$3000			;$6000 - $6FFF = Layer 1 tilemap on pause screen (2x1)
!V_Layer2_pause		= #$3800			;$7000 - $77FF = Layer 2 tilemap on pause screen (1x1)
!V_PLM_gfx			= #$3E00			;$7C00 - $7FFF = Special PLM graphics
!V_Layer3_gfx		= #$4000			;$8000 - $8FFF = Layer 3 graphics
!V_Boss				= #$4800			;$9000 - $9FFF = Sometimes used for Layer 2 boss tilemaps, otherwise unused
!V_Layer1			= #$5000			;$A000 - $AFFF = Layer 1 tilemap
!V_HUD_top			= #$5800			;$B000 - $B03F = Top line of Status bar tilemap, never written to normally
!V_HUD			 	= #$5820			;$B040 - $B0FF = Layer 3 Status Bar tilemap
!V_Layer3			= #$5880			;$B100 - $B7BF = Top of layer 3 FX tilemap (not visible because of Status bar, set to 184E by certain FX, 0000 by rain)
!V_FX				= #$5BE0			;$B7C0 - $BFFF = Layer 3 FX tilemap

; ::: SRAM Addresses :::
;everything here is in bank 70
!S_B_shoot			= $0020
!S_B_jump			= $0022
!S_B_run			= $0024
!S_B_cancel			= $0026
!S_B_select			= $0028
!S_B_aim_down		= $002A
!S_B_aim_up			= $002B

; ::: General WRAM :::
;7E:0000 - 7E:0019 is misc. direct page addresses, used in different ways by different routines
;Common uses include:
;	7E:0012 - 7E:0013					 Horizontal subpixel value or X coordinate
;	7E:0014 - 7E:0015					 Vertical subpixel value or Y coordinate
;	7E:0016 - 7E:0015					 index or 'type of' value
;	7E:0018 - 7E:0019					 Palette value
;ex. Sprite drawing routine @ $81879F
;	7E:0012 - 7E:0013					 Y position of sprite
;	7E:0014 - 7E:0015					 X position of sprite
;	7E:0016 - 7E:0017					 Palette for sprite
;	Y Register							 Pointer to tilemap
!W_MultiplandA	 	= $26				;16bit multipland used by !Multiply16
!W_MultiplandB	 	= $28				;16bit multipland used by !Multiply16
!W_Product		 	= $2A				;Resulting 32bit product from !Multiply16
!W_Screen_disp  	= $51				;Screen display register $2100 [x---bbbb | x: 0 - screen on 1 = screen off, b = brightness (F = max, 0 = off)]
!W_Intp_enable		= $84				;Value for interrupt enable flags register $4200 [n-yx---a | n = NMI, x/y = IRQ, a = Auto-joypad read]
!W_Active_HDMA		= $85				;Which HDMA channels are currently active
!W_Held				= $8B				;Controller 1 buttons held this frame
!W_Held_prev		= $0A14				;held buttons from previous frame, used when 0A42 = #$E6C9
!W_Held_last		= $0DFE				;used to update 0A90, which is 8B from 2 frames ago
;7E:008C - 7E:008D						 Controller 2 buttons held this frame (never used in super metroid)
!W_Pressed			= $8F				;Controller 1 buttons newly pressed this frame
!W_Pressed_prev		= $0A16				;pressed buttons from previous frame, used when 0A42 = #$E6C9
;7E:0090 - 7E:0091						 Controller 2 buttons newly pressed this frame (never used in super metroid)
!W_Input_mirror		= $93				;Mirror of $8F/$8B (input, no new buttons held, $A3 was 1/is now 0)
;7E:0095 - 7E:0096						 Mirror of controller 2 input
!W_Input_prev		= $97				;Controller 1 input from previous frame (updated at end of button-updating routine - this will always mirror $8B except during the button-updating routine)
!W_Interrupt_next	= $A7				;Optional next interrupt jump index (must be multiple of 2, 0 = never used)
!W_Interrupt_option	= $A9				;An optional next index /for the optional next index/ (must be multiple of 2, 0 = never used)
!W_Interrupt		= $AB				;Interrupt jump index (must be multiple of 2)
!W_BG1_X			= $B1				;BG1 X scroll register $210D
!W_BG1_Y			= $B3				;BG1 Y scroll register $210E
!W_BG2_X			= $B5				;BG2 X scroll register $210F
!W_BG2_Y			= $B7				;BG2 Y scroll register $2110
!W_BG3_X			= $B9				;BG3 X scroll register $2111
!W_BG3_Y			= $BB				;BG3 Y scroll register $2112
!W_BG4_X			= $BD				;BG4 S scroll register $2113
!W_BG4_Y			= $BF				;BG4 Y scroll register $2114
!W_VRAM_update		= $D0				;Table of entries to update graphics in VRAM. [7 bytes: size (2 bytes), source (3), target (2)]
;7E:02D0 - 7E:02D1						 Something for Mode 7
!W_D0_stack			= $0330				;'stack' pointer for $00D0 table
;7E:0334 - 7E:0335						 Something for Mode 7
!W_VRAM_read		= $0340				;Table of entries to read from graphics in VRAM. [9 bytes: VRAM target (cannot be 0, 2 bytes), all other DMA data (7)]
;7E:035C - 7E:035D						 always 0000, garbage write for the end of the VRAM read table
!W_0340_stack		= $0360				;'stack' pointer for $0340 table
!W_OAM				= $0370				;All OAM data (according to routine @ $80933A)
!W_OAM_index		= $0590				;Index for $0370
!W_NMI_request		= $05B4				;1 = NMI has been requested (usually game code has finished, waiting for vblank), 0 = no NMI request this frame
!W_Frame_counter	= $05B5				;this is the 8bit part of the frame counter, because reasons?? A few different things use this half as an animation counter
!W_Current_frame	= $05B6				;incremented every NMI when processing has been completed
!W_NMI_counter		= $05B8				;incremented every NMI
!W_Weapons_swapped	= $05CF				;Top bit is set if weaponry is 'swapped' at the moment.
!W_Random			= $05E5				;updated during normal gameplay by !Random_num
!W_Bit_check		= $05E7				;Often used to check bits for completed tasks/picked up items
!W_Disable_sfx		= $05F5				;disables sfx
!W_Disable_minimap	= $05F7				;disables the minimap
!W_Command_timers	= $0629				;List of words: Timer till current command should process. Minimum of 8.
!W_Pause_index		= $0727				;00 = map screen or gameplay, 01 = equip screen, the other numbers are fading in/out between them
!W_Start_index		= $0727				;00 - 16 = game state moving through the hex map, square map, etc. after selecting start game
!W_Pause_screen 	= $0753				;map = 0, equip = 1, options = 2
!W_Pause_list		= $0755				;which list is currently selected
!W_Current_station	= $078B				;current save station samus is loaded from
!W_Explored_map 	= $07F7				;the actual data for the maps starts 2 bytes after this (?)
!W_Timer_status		= $0943				;0: Inactive, 1: Ceres start, 2: Mother Brain start, 3: Initial delay, 4: Timer running, movement delayed, 5: Timer running, moving into place, 6: Timer running, moved into place
!W_Save_slot		= $0952				;Save slot selected, 0 - 2 (or menu item on save slot screen, 0 - 5)
!W_Game_state		= $0998				;01 = Title screen, 04 = menus, 05 = Load area, 06 = Loading game, 07 = Samus being electrified in save capsule, 08 = normal gameplay, 0C = pausing, 0F = paused, 12 = unpausing, 15, 17, 18, 19, 1A = Dead or dying, 1E = intro cutscenes (white text, green text, demos), 23 = Timer up. 24 = blackout and gameover (Ceres explodes if not escaping Zebes). 2A = intro demos
!W_Transition_state	= $099C				;pointer to code to run for the current door transition state
!W_HUD_select		= $09D2				;currently selected item on the hud, 0 = beams, 5 = xray
!W_HUD_select_mirror = $0A0E			;mirror of $09D2, used to check to update select display
!W_Moon_walk		= $09E4				;0 = off, 1 = on
!W_Japanese_text	= $09E2				;0 = off, 1 = on
!W_Auto_cancel_item = $0A04				;item select for auto cancel
!W_Pause_time		= $0A78				;>0 = paused for xray, message boxes, item pickups, etc.
!W_Trig_result		= $0E36
!W_Multiplier		= $0E32				;multiplier for trig functions, limit is 8 (?) <--Raidus?????
!W_Scrn_shake_time	= $1840
!W_Scrn_shake_type	= $183E
!W_HDMA_flag		= $18B0				;this allows hdma to be turned on/off essentially (useful for going into subscreen and whatnot) 8000 = hdma active
!W_Intro_state		= $1F51				;contains a pointer to the current state of the intro, see reference document for more info
!W_HUD_tilemap		= $7EC608			;start of HUD tilemap in ram
!W_Cutscene_timer	= $1A49
!W_Ceres_state		= $093F				;0 = before escape, 1 = ridely escaping, 2 = ceres escape, 8000 = ceres elevator room is rotating
!W_Time_frames		= $09DA				;game time in frames
!W_Time_seconds		= $09DC				;game time in seconds
!W_Time_minutes		= $09DE				;game time in minutes
!W_Time_hours		= $09E0				;game time in hours
!W_Language			= $09E2				;game language

!W_Stack_end		= $1F90				;for ACID Engine, the lowest available stack position is 1F90

!W_SRAM_data		= $7ED7C0

!W_Explored_map_0	= $7ECD52			;Crateria
!W_Explored_map_1	= $7ECE52			;Brinstar
!W_Explored_map_2	= $7ECF52			;Norfair
!W_Explored_map_3	= $7ED052			;Wrecked Ship
!W_Explored_map_4	= $7ED152			;Maridia
!W_Explored_map_5	= $7ED252			;Tourian
!W_Explored_map_6	= $7ED352			;Ceres
!W_Explored_map_7	= $7ED452			;Debug

!W_Event_bit_array  = $7ED820
!W_Boss_bit_array   = $7ED828
!W_Item_bit_array   = $7ED870
!W_Door_bit_array	= $7ED8B0
!W_Extra_event_bits = $7ED840
!W_Options_equip    = $7ED830
!W_Options_collect  = $7ED838

; ::: WRAM Palette values copied directly to CGRAM :::

;W_A_Pal = Wram_Area_Palette = palette lines used by tiles
!W_A_Pal_0			= $7EC000			;area palette line 0 (16 bit), area palette lines 0-4 (8 bit)
!W_A_Pal_1			= $7EC020			;area palette line 1
!W_A_Pal_2			= $7EC040			;area palette line 2
!W_A_Pal_3			= $7EC060			;area palette line 3
!W_A_Pal_4			= $7EC080			;area palette line 4
!W_A_Pal_5			= $7EC0A0			;area palette line 5
!W_A_Pal_6			= $7EC0C0			;area palette line 6
!W_A_Pal_7			= $7EC0E0			;area palette line 7

;W_S_Pal = Wram_Sprite_Palette = palette lines used by sprites
!W_S_Pal_0			= $7EC100			;white flash for enemies and pickups
!W_S_Pal_1			= $7EC120			;enemy palette line 1
!W_S_Pal_2			= $7EC140			;enemy palette line 2
!W_S_Pal_3			= $7EC160			;enemy palette line 3
!W_S_Pal_4			= $7EC180			;samus palette
!W_S_Pal_5			= $7EC1A0			;misc palette (explosions, bombs, item drops, etc.)
!W_S_Pal_6			= $7EC1C0			;beam palette
!W_S_Pal_7			= $7EC1E0			;enemy palette line 7

; ::: WRAM parametres of current room :::
!W_Map_collected	= $0789
!W_Door_pointer		= $078D				;DDB pointer for current room transition
!W_Door_dir			= $0791				;Current room transition direction. 0 = right, 1 = left, 2 = down, 3 = up. +4 = Close a door on next screen. Also map station stuff??
!W_Room_mdb			= $079B				;current room mdb (room id in smile)
!W_Region			= $079F
!W_Room_state		= $07BB
!W_Room_level_data	= $07BD				;3 byte pointer from 07BD - 07BF, level data pointer for current roomstate
!W_Room_FX1			= $07CD
!W_Room_FX2			= $07DF
!W_Room_width		= $07A5				;measured in blocks (pixels^3). ASL A to get index into room tilemap
!W_Room_height		= $07A7				; ||
!W_Room_area		= $07B9				;!Room_width * !Room_height
!W_Room_tlmp_size	= $7F0000			;also the size of background tilemap, and 2x size of bts map.
!W_Room_tilemap		= $7F0002
!W_Room_bts			= $7F6402			;bts values are only 1 byte each, so remember to use $0DC4 and 8bit or AND #$00FF to get the correct byte
!W_Room_scroll		= $7ECD20			;scroll values are 1 byte each, rooms support up to 66 (?) scrolls
!W_Current_block	= $0DC4				;nth block in room

!W_Layer1_X			= $0911				;x pos of layer 1 in room
!W_Layer1_Y			= $0915				;y pos of layer 1 in room
!W_Layer2_X			= $0917				;x pos of layer 2 in room
!W_Layer2_Y			= $0919				;y pos of layer 2 in room
!W_Room_X			= $07A1				;aka automap x, holds the x position of the current room on the map
!W_Room_Y			= $07A3				;aka automap y, holds the y position of the current room on the map

!W_Room_X_enter		= $0927				;X offset of room entrance for room transition (multiple of 100, screens)
!W_Room_Y_enter		= $0929				;Y offset of room entrance for room transition (multiple of 100, screens. Adjusted by 20 when moving up)

!W_FX3_V_speed		= $197C
!W_FX3_Ypos			= $1978
!W_FX3_target_Ypos	= $197A
!W_FX3_move_delay	= $1980
!W_FX3_height		= $195E
!W_FX3_tilemap_src	= $1964				;source in 8A where the tilemap is (0009,x where X is the FX header)
!W_FX3_type			= $196E				;none, lava, acid, water, spores, rain, fog

!W_Save_used		= $1E75				;flag. Samus has used a save station in this room, cleared when leaving room

!W_Elevator_dir		= $0799				;direction of current elevator (0000 = down, 8000 = up)
!W_Elevator_state	= $0E16				;state of elevator during room transition, 8000 = transitioning, 01 = Standing on elevator, 00 = no longer standing on elevator?
!W_Enemy_last		= $0E4C				;index into enemy data of the last enemy in the room (index of last enemy) + 1((n+1)*40)
!W_Enemy_num		= $0E4E				;number of enemies in current room
!W_Enemy_killed		= $0E50				;number of enemies killed in current room
!W_Enemy_needed		= $0E52				;number of enemies needed to kill to clear current room
!W_Enemy_pop		= $07CF				;pointer to rom data for enemies to populate room at init
!W_Enemy_allowed	= $07D1				;pointer to rom data for the enemy name, palette, listing, etc.

; ::: WRAM used by Message boxes :::
!W_MSG_percent		= $05A2				;Percentage of message box currently open
!W_MSG_bottom		= $05A4				;Current vertical position of the message box top relative to the middle of the screen
;7E:05A6 - 7E:05A8						 Still unsure how this works, will update when I know more
!W_MSG_top			= $05A8				;Current vertical position of the message box bottom relative to the middle of the screen
;7E:05AA - 7E:05AB						 Still unsure how this works, will update when I know more
!W_MSG_return		= $05F9				;return value to be used by the function that spawns the message box, usually used as yes/no on save option (yes = 0, no = 2)
!W_MSG_type			= $1C1F				;index of message box to draw, multiplied by 3 to get index in header table
!W_MSG_lookup		= $7E3000			;start of hdma lookup table in ram
!W_MSG_tilemap		= $7E3200			;start of box tilemap in ram

; ::: WRAM used by Debug routines :::
!W_DBG_missiles		= $05C9
!W_DBG_supers		= $05CB
!W_DBG_powers		= $05CD
!W_DBG_swap_flag	= $05CF
!W_Debug			= $05D1
!W_DBG_perf_flag	= $0DF4				;*not used in BE* when set, will change the screen brightness when the frame has finished, to show the remaining time in the frame and therefor performance

; ::: Samus Specific WRAM :::
!W_Health			= $09C2
!W_Health_max		= $09C4
!W_Health_mirror	= $0A06
!W_Health_sub		= $0A4C

!W_Missiles			= $09C6
!W_Missiles_max		= $09C8
!W_Missiles_mirror	= $0A08

!W_Supers			= $09CA
!W_Supers_max		= $09CC
!W_Supers_mirror	= $0A0A

!W_Powers			= $09CE
!W_Powers_max		= $09D0
!W_Powers_mirror	= $0A0C

!W_Reserves_type	= $09C0				;0 = no reserves, 1 = auto, 2 = manual
!W_Reserves			= $09D6
!W_Reserves_max		= $09D4
!W_Reserves_mirror	= $09D8				;in vanilla this is actually the reserve missiles, but that was stupid so it's being repurposed here as a mirror

!W_Items_equip		= $09A2
!W_Items_collect	= $09A4
!W_Beams_equip		= $09A6
!W_Beams_collect	= $09A8

!W_B_up				= $09AA				;the bit value of what button is currently set to these actions
!W_B_down			= $09AC
!W_B_left			= $09AE
!W_B_right			= $09B0
!W_B_shoot			= $09B2
!W_B_jump			= $09B4
!W_B_run			= $09B6
!W_B_cancel			= $09B8
!W_B_select			= $09BA
!W_B_aim_down		= $09BC
!W_B_aim_up			= $09BE

!W_X_pos			= $0AF6				;samus' x position in room
!W_X_pos_sub		= $0AF8
!W_X_pos_screen	 	= $0B04				;samus' x position *on screen* (0AF6 - 0911)
!W_X_pos_prev		= $0B10				;samus' previous x position in room
!W_Y_pos			= $0AFA				;samus' y position in room
!W_Y_pos_sub		= $0AFC
!W_Y_pos_screen		= $0B06				;samus' y position *on screen* (0AFA - 0915)
!W_Y_pos_prev		= $0B14				;samus' previous y position in room (only used for scrolling?)
!W_X_radius			= $0AFE 			;samus's X radius
!W_Y_radius			= $0B00				;samus's Y radius

!W_Movement_pointer	= $0A58				;pointer to code to run (next frame) relating to samus movement type
!W_Input_pointer	= $0A60				;pointer to code to run (next frame) relating to input, #$E913 gives input back to the player
!W_Speed_flag		= $0B3C				;upper byte is flag to check speed, lower byte is speed counter
!W_Speed_counter	= $0B3E				;upper byte is speed counter, lower byte is animation thing related to speed
!W_Echoes_active	= $0B40				;echo sounds are only active while speed boosting, so it's useful for determing whether the speed boost palette is applied
!W_Spark_timer		= $0A68
!W_Spark_delay		= $0AA2				;this is how much time you have to choose where to spark

!W_H_speed 	  		= $0B42
!W_H_speed_sub 		= $0B44
!W_H_momentum 		= $0B46
!W_H_momentum_sub 	= $0B48
!W_V_speed	  		= $0B2E
!W_V_speed_sub 		= $0B2C
!W_Momentum_preserv	= $0B4A				;something to do with momentum and speed. Cause of mockball (set to 2 while in air, but not zeroed fast enough when mockballing). (0 on ground, 1 - 2 in air, 0 = gaining speed?)

!W_V_direction		= $0B36				;0 = on ground, 1 = moving up, 2 = moving down
!W_X_direction		= $0A1E				;AND #$00FF to get X direction if loading in 16 bit (4 = left, 8 = right)
!W_X_direction_mirror = $0A10			;mirror of 0A1E, used to check to update sound
!W_Move_type		= $0A1F

!W_New_pose			= $0A28				;pose that is being attempted by controller
!W_Current_pose		= $0A1C				;upper byte is current position, lower byte is current state
!W_Animation_frame	= $0A96
!W_Animation_delay	= $0A94				;frames until 0A96 is updated

!W_Charge			= $0CD0
!W_Bomb_charge		= $0CD4				;starts charging if at least full charge, morphed, and holding down (routine at $90C0AB)
!W_Bomb_counter		= $0CD2

!W_Collision_enemy	= $0DCE				;set if Samus collides with a solid enemy (Only read as a flag, written as a direction?)
!W_Collision_dir	= $0DC6				;0 = jumping up?, 1 = ground, 2 = moving down, 4 = hit head, 5 = walljump. Top byte is related but used seperately
!W_Collision_flag	= $0DD0				;0000 = Samus did not collide with anything. 0001 = Collision with block. FFFF = Collision with enemy? 0001 < 0DD0 < FFFF = something to do with collisions in air???
!W_Collision_type	= $0B02				;what kind of collision detection to use for Samus. 03 = below, 02 = above, 01 = right, 00 = left

!W_Hurt_flash		= $0A48				;this timer is used for lots of crap actually. $0 - $7 is used for hurt flash, $7 - $20 and $30 is used for other stuff (like periodic damage timers?)
!W_Invuln_timer 	= $18A8				;timer for samus' invulnerability when hurt
!W_Hurt_timer		= $18AA				;timer when samus is pushed back and can't move

!W_Pal_obj_index	= $1E7D
!W_Pal_fraction		= $7EC402			;Color palette change fraction, denominator (C000,X = (C200,X * C400 / C402) + (original C000,X * (C402 - C400) / C402))

!W_Heat_glow_index	= $1EED				;index for heat glow palette, 0-15
!W_Palette_index	= $0A74				;0 = power suit, 2 = varia, 4 = gravity
!W_Charge_index		= $0B62 			;palette index for samus' current charge, 0-10 (already multiplied by 2)

!W_Periodic_dmg_sub	= $0A4E				;damage dealt to samus at subpixel level (1/65536th)
!W_Periodic_dmg		= $0A50				;damage dealt to samus at pixel leve (1)
!W_Contact_dmg		= $0A6E				;1 = speed boosting, 2 = shinesparking, 3 = SA (?), 4 = psuedo SA

!W_Hyper_beam		= $0A76				;0 = off, 1+ = on

!W_Samus_palette	= $7EC180			;samus' current palette in wram

!W_Samus_push		= $0A62				;0 = not being pushed, 1 = error pushing?, 2 = being pushed
!W_Health_alert		= $0A6A				;0 = health warning isn't on, 1 = health warning is on

; ::: Samus Projectile WRAM :::
!W_Proj_index 		= $0DDE
!W_Proj_Xpos		= $0B64				;these addresses only apply to samus' projectiles (missiles/beams/supers) but *not* her bombs/powerbombs
!W_Proj_Xpos_sub	= $0B8C
!W_Proj_Ypos		= $0B78
!W_Proj_Ypos_sub	= $0BA0
!W_Proj_Xspeed		= $0BDC
!W_Proj_Yspeed		= $0BF0
!W_Proj_type		= $0C18				;8000+ = live, X0YY = beam, YY = beamtype, X1XX = missile, X2XX = super missile, X7XX = dead beam, X8XX = dead missile/super
!W_Proj_dir			= $0C04				;Ur, UR, R, DR, Dr, Dl, DL, L, UL, Ul. A - F = glitchy, 10+ = kill beam, including plasma (hit an enemy)
!W_Proj_cooldown	= $0CCC
!W_Proj_counter		= $0CCE

; ::: E/R Specific WRAM :::
!ER_proj_Xpos		= $1A4B				;x position in pixels
!ER_proj_Xpos_sub	= $1A6F				;x position in sub pixels
!ER_proj_Ypos		= $1A93				;y position in pixels
!ER_proj_Ypos_sub	= $1AB7				;y position in sub pixels

; ::: PLM Specific WRAM :::
;all of these generally need to be indexed by the PLM's index
!P_Headers			= $1C37				;table of headers for all the currently loaded plms
!P_Location			= $1C87				;nth block of room that PLM is on * 2 (ie. room tilemap index)
!P_Args				= $1DC7				;high/low of PLM
!P_Instr_next		= $1D27				;holds a pointer to the next instruction to execute
!P_pre_instr		= $1CD7				;kind of like an init instruction, one that happens before processing the main plm code (?)
!P_Index			= $1C27				;except these three, *DO NOT index these*, they are single words. This is the index of the plm currently being processed
!P_X_pos			= $1C29				;calculated X position from JSL !Get_PLM_XY (X position *in blocks*)
!P_Y_pos			= $1C2B				;calculated Y position (Y position *in blocks*)
!P_Respawn_value	= $1E17				;tile value to use when the tile respawns (kind of). Used with specific plms, not all respawning ones
!P_Frame_delay		= $7EDE1C			;number of frames to wait before moving to the next instruction (not usually adjusted manually)
!P_Tile_value		= $7EDE6C			;similar to respawn value, only used for specific types of plms
!P_Variable			= $1D77				;Variable use PLM value

; ::: Enemy Specific WRAM :::
!E_Index			= $0E54
;7E:0F78 - 7E:1777						Enemy data, $20 entries, $90 bytes per entry
!E_Header			= $0F78				;Pointer to enemy header
!E_Bank				= $0FA6				;Bank of enemy data (8bit)

!E_Health			= $0F8C				;Enemy HP
!E_Gfx				= $0F8E				;Main enemy graphics/hitbox pointer
!E_Palette			= $0F96				;Palette to use for enemy from enemy set number, ORA'd with data to use in OAM.
!E_Width			= $0F82				;Enemy width for collisions (1/2 pixel value from centre)
!E_Height			= $0F84				;Enemy height for collisions (1/2 pixel value from centre)

!E_Xpos				= $0F7A				;X position in pixels
!E_Xpos_sub			= $0F7C				;X position in sub-pixels (often unused)
!E_Ypos				= $0F7E				;Y position in pixels
!E_Ypos_sub			= $0F80				;Y position in sub-pixels

!E_Props			= $0F86				;Primary property bits for the enemy
!E_Prosp_extra		= $0F88				;Extra property bits for the enemy
!E_VRAM				= $0F98				;Index to graphics in VRAM
!E_Layer			= $0F9A				;Layer control

!E_Ai				= $0F8A				;Enemy AI handler. Lowest bit set determines which AI pointer in enemy data to use (None = 18, 1 = 1A, 2 = 1C, 4 = 1E, 8 = 20)
!E_Instr			= $0F92				;Enemy AI instruction pointer (similar to PLM instruction pointers). Positive Enemy instructions set delay timer and 0F8E, and highest bit of 0F88
!E_Delay			= $0F94				;Delay for $0F92

;7E:0FA2 - 7E:0FA3						A value that works concurrently with $0FA4 to modify vertical position of sprite
!E_V_adjust			= $0FA4				;Value that determines if sprite vertical position is raised or lowered (often used as a counter instead)

!E_Frozen			= $0F9E				;Enemy frozen timer
;7E:0FA8 - 7E:0FB3						General purpose variables used by enemy AI routines (6 total, 2 bytes wide each)
!E_ROM_Var1			= $0FB4				;Predetermined variable in rom, often used to set movement speed ('Speed' in SMILE)
!E_ROM_Var2			= $0FB6				; || ('Speed2' in SMILE)

;7E:0F90 - 7E:0F91						??? (Used by Mochtroid) (LN Chozo uses it as a loop counter)
;7E:0F9C - 7E:0F9D						Set to (0F78),#$0D + #$08 when shot? This - 8 = timer for using Hurt AI.
;7E:0FA0 - 7E:0FA1						Counter, forces a different kind of processing. Used when hit by Plasma Beam (powerbombs?)
;7E:0FA7 								04 during spore spawn fight, otherwise unknown

; --------------------------------------

; ---
; --- New WRAM Addresses
; ---
!W_Pressed_mirror	= $05C5				;05C5-05CF are debug addresses, so be careful with them. Being used as mirrors however, the worst case is the real address keeps updating
!W_Held_mirror		= $05C7
!W_Charge_mirror	= $05C9
!W_Collected_items_mirror = $05CB		;mirror of the collected items counter
!W_Enemy_health_mirror = $05CD			;mirror of the last enemy health

; *** the following addresses used to be part of the stack, but have since been repurposed ***
; as such, the end of ram before the stack is now 1F8E
; *** DO NOT USE 1F90 - 1FFF, it is entirely reserved for the stack ***
; lowest observed stack is 1FAF

!W_Ending_spark 	= $1F5E				;used for landing speed and backflip (scyzer)
!W_Ball_sparking	= $1F60				;flag for if currently in ball spark
!W_Auto_morph		= $1F62				;1 = automorph is happening this frame (cleared as soon as the speed check happens)

!W_Can_skip_intro	= $1F64				;flag for if pressing start will skip the intro
!W_Hud_update_flags = $1F64				;array for what mods need to be updated this frame

!W_Subscreen_samus	= $1F66				;0 = nothing being transfered, 1 = first half of the samus model gfx being moved, 2 = second half being moved
!W_Morph_flash		= $1F68				;index for what palette to use during morph flash
!W_Charged_beam		= $1F6A				;0 = uncharged beam gfx, 1 = charged beam gfx
!W_Spark_exit		= $1F6E				;flag for whether to half the V speed, used for shinespark exiting

!W_Pause_header		= $1F70				;LDX !W_Pause_header to get the current index into the header list
!W_Pause_screen_tar	= $1F72				;target pause screen to move to
!W_Pause_entry	    = $1F74				;entry in a given list type object on the pause screen
!W_Pause_fade		= $1F76				;0 = done fading, 1 = fading in, 2 = fading out
!W_Pause_len		= $1F78				;length of current pause list
!W_Spark_pal		= $1F7A				;palette timer for shinespark

!W_Screen_type		= $1F7C				;pointer to table of routines for the subscreen we're on

!W_Hud_expect_flags = $1F7E
!W_IRQ_DP1			= $1F80				;IRQ routines can't use DP memory so this is wram that is being used as if it were DP for a couple of routines
!W_IRQ_DP2			= $1F82
!W_Hyper_index		= $1F84
;_?					= $1F86

; ****																					****
; **** keep in mind that 7FFA02 - 7FFFFF is NOT safe to use during the credits sequence ****
; ****																					****

; ::: Extra $7E WRAM saved to SRAM :::
!W_Collected_items  = $7ED86E			;running sum of total items collected during the game

; ::: Extra WRAM *not* saved to SRAM :::
!W_Water_running	= $7FFA08			;1 = running on a liquid
!W_Force_echoes		= $7FFA0C			;1 = force echoes, 0 = normal
!W_Reserves_refill	= $7FFA0E			;0 = not refilling, 1 = refilling
; *** WRAM used for the Sub-screen List Objects ***
; all of these are indexed by current pause screen list object
; which means the total space alloted for a total of 7 lists at once is $7E bytes (FA10 - FA8E)
!S_Type				= $7FFA10			;[2 bytes] Type of list object, 00 = list, 01 = widget
!S_Size				= $7FFA12			;[2 bytes] [SSLL] SS = Size of tilemaps for the entries in a given list, LL = Max length of list
!S_Window_s			= $7FFA14			;[2 bytes] [SSSS] SS = Starting index of viewable window
!S_Window_e			= $7FFA16			;[2 bytes] [EEEE] EE = Ending index of viewable window
!S_Dir				= $7FFA18			;[2 bytes] [UDLR] Index of the list to move to based on direction
!S_Tile_pos			= $7FFA1A			;[2 bytes] Index of first tile of first entry in the list
!S_Sprite_pos		= $7FFA1C			;[2 bytes] [XXYY] X and Y Pixel positions on screen of first entry in the list
!S_Bits				= $7FFA1E			;[2 bytes] Offset to start of bit list
!S_Tilemaps			= $7FFA20			;[2 bytes] Offset to start of tilemap list
!S_Sprite_type		= $7FFA22			;[2 bytes] [DDCC] DD = Difference in pixels between items in a widget, CC = Sprite to use as cursor

;regular use ram starts again here
!W_Mini_map_tiles	= $7FFA90			;FA90 - FAAE are the tiles to be drawn on the mini map. They get updated from a number of situations (mostly movement) and are stored here to be drawn however you want
!W_Mini_map_mirror	= $7FFAB0
!W_Mini_map_temp	= $7FFAB2
!W_Still_fading		= $7FFAB4
!W_MSG_subs			= $7FFAB6			;7F:FACA - 7F:FAEA this can be as large or small as you need, but by default it will be 16 slots at 2 bytes each ($20 bytes total)
!W_Item_clip		= $7FFAD8			;what instruments to use when playing a sound from an item upgrade plm
;!W_?				= $7FFADA

!W_CGRAM_Backup		= $7FFB00			;7F:FB00 - 7F:FD00 this is a temporary storage for the CGRAM backup during the subscreen, so that message boxes can be used at the same time
;W_?				= $7FFD00

; ::: Extra WRAM saved Per File to SRAM in bank 7F :::
!W_Hud_style		= $7FFE00			;pointer to location in bank $80 where the style object's data is stored
!W_Pause_default	= $7FFE02			;0 = map, 1 = equip, 2 = options
!W_Hud_type			= $7FFE04			;0 = normal, 1 = pro, etc
!W_Item_sfx			= $7FFE06			;0 = short, 1 = fanfare

; ::: Extra WRAM saved to Global SRAM in bank 7F :::
;!W_???				= $7FFF00

; ------ all the graphical resources needed for the engine are imported here ------
; _S = sprites, _T = tiles, _SM = samus model
!GFX_Main_S   = $B6F200					;these gfx could be 600 bytes longer (3 full lines of tiles) but then you'd have to find another place for them
!GFX_Main_T   = $B69A00
!GFX_Equip_S  = $B88000					;the equip gfx stored here are actually smaller than the amount allocated
!GFX_Equip_T  = $B88C00					;and it is because by default this code base uses the new equipment screen samus model gfx
!GFX_Map_S    = $B89800					;which are loaded separately and take up most of the tile gfx allocated for the equipment screen
!GFX_Map_T    = $B8A400					;as such, that portion gets overwritten when importing the tile gfx in
!GFX_Option_S = $B8CA00					;and then the samus model gfx get stored in a different bank
!GFX_Option_T = $B8D600
!GFX_Equip_SM = $DF8000					;this is the equipment screen samus model gfx, and takes up about half a bank for maximum versatility
!GFX_Equip_SM_BNK = #$00DF				;the equipment screen needs to know just the bank on it's own and I don't remember if I can reference just the bank from a long in xkas
!GFX_Title_T  = $B68000
!GFX_Title_S  = $B6C000

org $9AB200 : incbin Gfx/Hud/Hud.gfx
org $9A8200 : incbin Gfx/Samus/Grapple.gfx	;this also includes the arm cannon opening sprite tiles
org $9A9A00 : incbin Gfx/Samus/Beams.gfx
org $9AD600 : incbin Gfx/Samus/Misc_Sprites.gfx
org $9C8000 : incbin Gfx/Samus/Morph_Ball.gfx

org $898000 : incbin Gfx/Misc/Items.gfx
org $85FB00 : incbin Gfx/Misc/Message_Boxes.gfx

org !GFX_Title_T  : incbin Gfx/Misc/Title_Tiles.gfx
org !GFX_Title_S  : incbin Gfx/Misc/Title_Sprites.gfx
org !GFX_Main_T   : incbin Gfx/Subscreen/Main_Tiles.gfx
org !GFX_Main_S   : incbin Gfx/Subscreen/Main_Sprites.gfx
org !GFX_Equip_S  : incbin Gfx/Subscreen/Equip_Sprites.gfx
org !GFX_Equip_T  : incbin Gfx/Subscreen/Equip_Tiles.gfx
org !GFX_Map_S    : incbin Gfx/Subscreen/Map_Sprites.gfx
org !GFX_Map_T    : incbin Gfx/Subscreen/Map_Tiles.gfx
org !GFX_Option_S : incbin Gfx/Subscreen/Options_Sprites.gfx
org !GFX_Option_T : incbin Gfx/Subscreen/Options_Tiles.gfx
org !GFX_Equip_SM : incbin Gfx/Subscreen/Equip_Samus.gfx

; --- Palettes ---
org $9B98A0 : incbin Gfx/Samus/Morph_Flash_P.bin
org $9B99A0 : incbin Gfx/Samus/Morph_Flash_V.bin
org $9B9AA0 : incbin Gfx/Samus/Morph_Flash_G.bin
org $90F63A : incbin Gfx/Samus/Beams.bin

; ------ all the code bank files are imported here ------
incsrc Code/macros.asm					;this file contains all the commonly used macros
incsrc Code/decompression.asm

incsrc Code/bank_80.asm
incsrc Code/bank_81.asm
incsrc Code/bank_82.asm
incsrc Code/bank_83.asm
incsrc Code/bank_84.asm
incsrc Code/bank_85.asm
incsrc Code/bank_86.asm
incsrc Code/bank_87.asm
incsrc Code/bank_88.asm
incsrc Code/bank_89.asm
incsrc Code/bank_8A.asm
incsrc Code/bank_8B.asm
incsrc Code/bank_8C.asm
incsrc Code/bank_8D.asm
incsrc Code/bank_8E.asm
incsrc Code/bank_8F.asm
incsrc Code/bank_90.asm
incsrc Code/bank_91.asm
incsrc Code/bank_92.asm
incsrc Code/bank_93.asm
incsrc Code/bank_94.asm
incsrc Code/bank_9B.asm
incsrc Code/bank_A0.asm
incsrc Code/bank_A2.asm
incsrc Code/bank_A3.asm
incsrc Code/bank_A7.asm
incsrc Code/bank_A9.asm
incsrc Code/bank_AA.asm

;82 < 80, 82, 87 (sort of)
;90 < 80, 94 < 84

incsrc Code/transition_table.asm		;new pose transition table (located in bank 91) - Quick morph, Upspin, Spinfall, Respin, Backflip

; ------ all the level headers, data, etc. are imported here ------



; ------ all the enemy headers, etc. are imported here ------


; ------ ROM Map ------
; 80 -  Many of the main system routines, including IRQ
;    -> 
; 81 - 
; DF -  Unused music bank in vanilla
;    -> equipment screen samus model gfx
; B8 -  Completely unused in vanilla
;    -> Most of the subscreen gfx
; 93 -  new beam animation stuff

; ------ Bit array's with new values ------
;HUD update flags
;  $1F69    $1F68
;0000 0000 0000 0000
;|||| |||| |||| |||\- health
;|||| |||| |||| ||\-- missile ammo
;|||| |||| |||| |\--- super ammo
;|||| |||| |||| \---- power bomb ammo
;|||| |||| ||||
;|||| |||| |||\------ item selection
;|||| |||| ||\------- input
;|||| |||| |\-------- minimap
;|||| |||| \--------- charge
;|||| ||||
;|||| |||\----------- magic display
;|||| ||\------------ shinespark
;|||| |\------------- reserve tanks
;|||| \-------------- 
;||||
;|||\---------------- 
;||\----------------- 
;|\------------------ 
;\------------------- 

;Item array
;  $09A3	$09A2
;0000 0000 0000 0000
;|||| |||| |||| |||\- Varia
;|||| |||| |||| ||\-- Spring Ball
;|||| |||| |||| |\--- Morphing Ball
;|||| |||| |||| \---- Screw Attack
;|||| |||| ||||
;|||| |||| |||\------ unused
;|||| |||| ||\------- Gravity Suit
;|||| |||| |\-------- unused
;|||| |||| \--------- unused
;|||| ||||
;|||| |||\----------- High Jump
;|||| ||\------------ Space Jump
;|||| |\------------- unused
;|||| \-------------- unused
;||||
;|||\---------------- Bomb
;||\----------------- Speed Booster
;|\------------------ Grapple
;\------------------- X-Ray

;Beam array
;  $09A6
;0000 0000
;|||| |||\- Wave
;|||| ||\-- Ice
;|||| |\--- Spazer
;|||| \---- Plasma
;||||
;|||\------ unused
;||\------- unused
;|\-------- unused
;\--------- unused
;  $09A7
;0000 0000
;|||| |||\- unused
;|||| ||\-- unused
;|||| |\--- unused
;|||| \---- unused
;||||
;|||\------ Charge
;||\------- unused
;|\-------- unused
;\--------- unused

;Event bit array
;  $D822		$D821	  $D820
;0000 0000 0000 0000 0000 0000
;|||| |||| |||| |||| |||| |||\- Zebes is awake
;|||| |||| |||| |||| |||| ||\-- Mother Brain's container has been destroyed
;|||| |||| |||| |||| |||| |\--- Zebetite bit #1 (five possible values for number of zebetites to spawn)
;|||| |||| |||| |||| |||| \---- Zebetite bit #2
;|||| |||| |||| |||| ||||
;|||| |||| |||| |||| |||\------ Zebetite bit #3
;|||| |||| |||| |||| ||\------- Phantoon statue cleared
;|||| |||| |||| |||| |\-------- Ridely   statue cleared
;|||| |||| |||| |||| \--------- Draygon  statue cleared
;|||| |||| |||| ||||
;|||| |||| |||| |||\----------- Kraid    statue cleared
;|||| |||| |||| ||\------------ Statue room completed (path to tourian now open)
;|||| |||| |||| |\------------- Maridia tube broken
;|||| |||| |||| \-------------- Space Jump chozo has lowered the lava
;|||| |||| ||||
;|||| |||| |||\---------------- Shaktool has cleared the path
;|||| |||| ||\----------------- Zebes timebomb set
;|||| |||| |\------------------ Animals rescued (not sure why this needs to be in sram, since you can't save during the escape)
;|||| |||| \------------------- ?
;|||| ||||
;|||| |||\--------------------- 1st metroid room cleared
;|||| ||\---------------------- 2nd metroid room cleared
;|||| |\----------------------- 3rd metroid room cleared
;|||| \------------------------ 4th metroid room cleared
;||||
;|||\-------------------------- ?
;||\--------------------------- Speed Booster lava escape cleared
;|\---------------------------- ?
;\----------------------------- ?
