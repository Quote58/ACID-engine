lorom

; collect_tank makes sure the item percentage counts every tank
; collect beam makes sure the palette gets updated when you get a new beam <-- is this relevant if there is not cannon tint? Look into it later...
; --- Quote58 ---
org $84889F : JSL Collect_tank			;hijack of routine that sets the bit in the collected items array
org $8488DE : JSR Collect_beam			;hijack of routine that sets the bit, starts message box, toggles spazer/plasma, etc.

; quite a few plm instructions needed to be repointed so they could do a few extra things, specifically update the hud
org $84AD8D : dw Collect_map_data		;map station right access
org $84ADAF : dw Collect_map_data		;map station left access
org $84E0DB : dw Collect_missile		;missile plm - open
org $84E4A4 : dw Collect_missile		;missile plm - chozo orb
org $84E975 : dw Collect_missile		;missile plm - shot block
org $84E100 : dw Collect_super			;super plm - open
org $84E4D6 : dw Collect_super			;super plm - chozo orb
org $84E9AD : dw Collect_super			;super plm - shot block
org $84E125 : dw Collect_power			;power plm - open
org $84E508 : dw Collect_power			;power plm - chozo orb
org $84E9E5 : dw Collect_power			;power plm - shot block
org $84E442 : dw Collect_reserve_tank	;reserve plm - open
org $84E907 : dw Collect_reserve_tank	;reserve plm - chozo orb
org $84EE41 : dw Collect_reserve_tank	;reserve plm - shot block
org $84E20A : dw Collect_speed			;speed booster plm - open
org $84E62E : dw Collect_speed			;speed booster plm - chozo orb
org $84EB29 : dw Collect_speed			;speed booster plm - shot block
org $84E180 : dw Collect_charge			;charge beam plm - open
org $84E57D : dw Collect_charge			;charge beam plm - chozo orb
org $84EA66 : dw Collect_charge			;charge beam plm - shot block
org $84892C : JSR Collect_grapple_xray : NOP ;grapple
org $848953 : JSR Collect_grapple_xray : NOP ;xray

; repointing the init code for the different blocks so that power bombs/beams reveal the block type
org $84CF2E : JMP Power_bomb_block_init
org $84CF67 : JMP Super_missile_block_init
org $84CDEA : JMP Speedboost_block_init
org $84CEDA : JMP Bomb_block_init

; the save station just needed straight up new code, so the whole plm is repointed
org $84B76F : dw Save_station_init, Save_station_instr

; these are hijacks for the new soundfx instructions
; --- Scyzer ---
org $848BF2
Normal_clip:
	JSR Clip_set
org $82E126
	JSL Clip_check
	BRA $08

; :::::::::::::::::::::::
; ::: Door Animations :::
; :::::::::::::::::::::::
; --- Quote58 ---
; door animations can now be controlled from constants in the main file
; because they have been rewritten out here, in a form that's also easier to edit

; --- instructions ---
!ClearL 	= $A677
!ClearR 	= $A683
!ClearU 	= $A68F
!ClearD 	= $A69B
!Kill 		= $86BC

; --- Macros for door types ---
macro play_3(sound)
	dw $8C19 : db <sound>
endmacro

macro open(speed, f1, f2, f3, clear)
   %play_3($07)
	dw <speed>, <f1>
	dw <speed>, <f2>
	dw <speed>, <f3>
	dw $005E, <clear>
	dw !Kill
endmacro

macro close(wait, speed, f1, f2, f3, clear)
	dw <wait>, <clear>
	dw <speed>, <f1>
   %play_3($08)
	dw <speed>, <f2>
	dw <speed>, <f3>
endmacro

macro flash(speed, f1, f2)
	rep 3 : dw <speed>, <f1>, <speed>+1, <f2>
	skip 4
endmacro

org $84BE59
; ::: Regular door animations :::
Grey_door:
incsrc data/plm/grey_door.asm

Yellow_door:
incsrc data/plm/yellow_door.asm

Green_door:
incsrc data/plm/green_door.asm

Red_door:
incsrc data/plm/red_door.asm

Blue_door:
incsrc data/plm/blue_door.asm

org $84BA4C
; ::: Bomb Torizo door :::
Bomb_torizo_door:
.right_close
	dw !C_Close_speed, !ClearR
	skip 4
   %close($0028, !C_Close_speed, $A6FB, $A6EF, $A6E3,!ClearR)

;the bomb bit check happens in the space between right_close and right_flash

org $84BA9B
.right_flash
   %flash(!C_Flash_speed, $A9EF, $A6D7)
	skip 5

.right_open
   %open(!C_Open_speed, $A6E3, $A6EF, $A6FB, !ClearR)
; ::: ---------------- :::

; ::::::::::::::::::::::::::::::::::::::
; ::: PLMs (Post Load Modifications) :::
; ::::::::::::::::::::::::::::::::::::::
;
;PLMs are structured as:
;PLM_name:
;.header	<-- if it is placed through an editor, the header should be in a constant location at the top of the free space
;	dw .init, .instr
;
;.instr		[X = PLM index, Y = instruction index]
;	dw AAAA, BBBB		if AAAA < 8000, use as frame delay for BBBB, else Goto AAAA, then BBBB
;
;.init		[X = ?, Y = PLM index]
;
; *** example of equipment upgrade plm ****
; Item:
; .header
;	dw .init, .instr
; 
; .init
; 
;
; .instr
;	dw !InstrTransferGfx, [gfx]			<- pointer to start of gfx for PLM in bank $89, change this if you move the gfx
;	dw $0000,$0000						<- the palette for all of item PLM's is the same
;	dw $0000,$0000
;	dw !InstrCheckItemBit, .end
;	dw !InstrSetReturn,    .touch		<- sets the touch instructions as the instr list to go to if !ArgTouchAi is true
;	dw !InstrSetPreInstr,  !ArgTouchAi	<- checks if the plm has been touched by calculating the x and y of the plm, and checking against stuff
; .animate
;	dw !InstrDrawCustom, !InstrDrawCustom2
;	dw !InstrGoTo, .animate				<- if the plm hasn't been touched, it just goes through this animation loop and displays the PLM gfx
; .touch
;	dw !InstrSetItemBit
;	dw !InstrSoundFX : db [sound]		<- this is the sound it will use
;	dw $88F3, [bit]  : db [message]		<- $88F3 uses the first 2 bytes of the argument as a bit to set in !Items_equipped/collected and the 3rd byte as an index into the message box array
; .end
;	dw !InstrGoTo, !ArgKillPLM			<- draws the PLM and then kills it


; --- Common PLM instruction pointers ---
!InstrPlaySound2    = $8C46				;[args: sound index] plays a sound from library 2, max queue = 3 (JSL $8090C1)
!InstrTransferGfx   = $8764				;[args: gfx pointer] transfers gfx from bank $89
!InstrCheckItemBit  = $887C				;[args: instr pointer if bit is set] checks the item bit array (7ED870) with the PLM's index (low byte of !PLM_args) and goes to the argument if set
!InstrSetItemBit    = $8899				;[args: none] uses the low byte of !PLM_args to set a bit in the item bit array, aka sets item as picked up
!InstrGoTo		    = $8724				;[args: instr pointer to jump to] simple Goto command (LDA $0000,y : TAY : RTS)
!InstrGoToDec		= $873F
!InstrDrawCustom    = $E04F				;[args: ???] draws a custom-graphic PLM from a table depending on variable RAM with a 4 frame delay
!InstrDrawCustom2   = $E067				;[args: ???] pretty much the same as above?
!InstrSetPreInstr   = $86C1				;[args: pointer to PLM pre instruction code]
!InstrSetReturn	    = $8A24				;[args: instr pointer to jump to if pre instruction code says so]
!InstrSoundFX	    = #Clip_sound_fx	;these are only used if scyzer's new item pickup sound code is applied, as it points to the new routines
!InstrItemFX		= #Clip_item_sfx	;this is a custom one made for project base that will choose to do a short clip or the fanfare based on !W_Item_sfx
!InstrSpecialFX     = #Clip_special_fx
!InstrMiscFX	    = #Clip_misc_fx
!InstrNormalFX	    = #Normal_clip
!InstrKill			= $86BC				;STZ the plm header
!InstrDraw1E17		= $8B17				;draws a block onto the PLM's location using the block value in $1E17 (variable use PLM ram)
!InstrEquipInit		= $EE64				;this is a common init pointer for all equipment plms

; --- Common Arguments for the above instructions ---
!ArgBreakBlockSound = $0A
!ArgTouchAi		    = $DF89
!ArgKillPLM		    = $DFA9

; this imports a list of defines for all the sound indexes, along with comments that explain each one
; and then all the changes to the plm sounds
incsrc data/plm/item_sound_arguments.asm
incsrc data/plm/item_sounds.asm

org $84EFD4
; free space in bank 84
; :::											   			:::
; :::     Headers for PLMs that are placed by the user 		:::
; ::: *** Must keep this at the start of the free space *** :::
print "\n--- Headers for PLMs placed by user ---"
; Disappearing block (Kejardon)
print "Disappearing block: ", pc
dw Disappearing_block_init, Disappearing_block_instr_air

; Messenger (Quote58/JAM)
print "Messenger PLM: ", pc
dw Messenger_init, Messenger_instr

print "--- Headers for PLMs not placed by user ---"
print "--- End of PLM header list ---\n"

; :::																   :::
; ::: Code for new PLMs, most are placed by the user through an editor :::
; :::																   :::

; --- Kejardon ---
incsrc ../Plm/Disappearing_block/Disappearing_block.asm

; --- Quote58 (inspired by messanger patch by JAM) ---
incsrc ../Plm/Messenger/Messenger.asm


; :::																					 :::
; ::: Modification, addition, or extenstion of PLMs spawned by the block reaction tables :::
; :::																					 :::

; --- Quote58 ---
; ::: Missile blocks :::
Missile_block:
.header
	dw .init, .instr

.header_R
	dw .init, .instr_R
	
.instr_R
	dw !InstrPlaySound2 : db !ArgBreakBlockSound
	dw $0004, $A345
	dw $0004, $A34B
	dw $0004, $A351
	dw $0180, $A357						;wait a few seconds before respawning
	dw $0004, $A351
	dw $0004, $A34B
	dw $0001, $A345
	dw !InstrDraw1E17
	dw !InstrKill

.instr
	dw !InstrPlaySound2 : db !ArgBreakBlockSound
	dw $0004, $A345
	dw $0004, $A34B
	dw $0004, $A351
	dw $0001, $A357
	dw !InstrKill

.tile_instr
	dw $0001, #.tilemap					;draw the revealed block tilemap
	dw !InstrKill
	
.tilemap
	dw $0001, $C0BF						;which is just one tile with shotblock type and index BF (right under super missile blocks)
	dw $0000

.init
	LDX !W_Proj_index
	LDA !W_Proj_type,x : AND #$0F00		;check projectile type (only missiles included here)
	CMP #$0100 : BEQ .break_tile		;missiles destroy tile
	CMP #$0200 : BEQ .break_tile		;so do super missiles
	CMP #$0300 : BEQ .reveal_tile		;power bombs reveal tile
	CMP #$0500 : BEQ .reveal_tile		;bombs reveal tile
	PHA
   %check_option(!C_O_Block_reveal)
	PLA
	CMP #$0000 : BEQ .reveal_tile		;beams reveal tile <--shouldn't this be PLA : BEQ .reveal_tile??
	-
	LDA #$0000
	STA !P_Headers,y
	RTS
.end
	PLA : BRA -
	
.break_tile
	LDX !P_Location,y
	LDA !W_Room_tilemap,x : AND #$F000
	ORA #$00BF : STA !P_Respawn_value,y;this is the block value you want it to become after it respawns if it's respawning
	AND #$8FFF : STA !W_Room_tilemap,x ;turn block into air
	RTS

.reveal_tile
	LDA #.tile_instr
	STA !P_Instr_next,y
	RTS

; ::: Power bomb blocks :::
Power_bomb_block:
.init
	LDX !W_Proj_index
	LDA !W_Proj_type,x : AND #$0F00		;check projectile type (only missiles included here)
	CMP #$0300 : BEQ .break_tile		;power bombs break tile
	CMP #$0500 : BEQ .reveal_tile		;bombs reveal tile
	PHA
   %check_option(!C_O_Block_reveal)
	PLA
	CMP #$0000 : BEQ .reveal_tile		;beams reveal tile
	-
	LDA #$0000
	STA !P_Headers,y
	RTS
.end
	PLA : BRA -

.break_tile
	LDX !P_Location,y
	LDA !W_Room_tilemap,x : AND #$F000
	ORA #$0057 : STA !P_Respawn_value,y ;when the tile respawns, it'll use this tile value
	AND #$8FFF : STA !W_Room_tilemap,x	;but for now, it's air
	RTS
	
.reveal_tile
	LDA #$C91C : STA !P_Instr_next,y	;this instruction just changes the tile to it's revealed state and then kills the plm
	RTS

; ::: Super missile blocks :::
Super_missile_block:
.init
	LDX !W_Proj_index
	LDA !W_Proj_type,x : AND #$0F00		;check projectile type (only missiles included here)
	CMP #$0200 : BEQ .break_tile		;super missiles break tile
	CMP #$0500 : BEQ .reveal_tile		;bombs reveal tile
	CMP #$0300 : BEQ .reveal_tile		;power bombs reveal tile
	PHA
   %check_option(!C_O_Block_reveal)
	PLA
	CMP #$0000 : BEQ .reveal_tile		;beams reveal tile
	-
	LDA #$0000
	STA !P_Headers,y
	RTS
.end
	PLA : BRA -
	
.break_tile
	LDX !P_Location,y
	LDA !W_Room_tilemap,x : AND #$F000
	ORA #$009F : STA !P_Respawn_value,y ;when the tile respawns, it'll use this tile value
	AND #$8FFF : STA !W_Room_tilemap,x	;but for now, it's air
	RTS
	
.reveal_tile
	LDA #$C922 : STA !P_Instr_next,y	;this instruction just changes the tile to it's revealed state and then kills the plm
	RTS

; ::: Speedbooster blocks (rewritten to be not terrible by Quote58) :::
Speedboost_block:
.init									;these blocks were horribly written, so I rewrote them here even though I don't currently have any extra functionality to add
	LDA !W_Speed_counter : AND #$0F00
	CMP #$0400 : BEQ .break_block		;break the block if currently at speed booster speed
	LDA !W_Current_pose
	CMP #$00C9 : BMI .delete			;these are all the shinespark poses
	CMP #$00CE : BPL .delete
.break_block
	LDX !P_Location,y
	LDA !W_Room_tilemap,x : AND #$F000
	ORA #$00B6 : STA !P_Respawn_value,y	;use this tile if respawning later
	AND #$0FFF : STA !W_Room_tilemap,x
	CLC
	RTS

.delete
	LDA #$0000
	STA !P_Headers,y
	SEC
	RTS

; ::: Maridia glass tube trigger block :::
Maridia_glass_block:
.header
	dw .init, $C9CF
	
.init
	LDA !W_Current_pose
	CMP #$00CB : BMI .delete			;poses for vertical and diagonal shinesparks
	CMP #$00CF : BPL .delete
.break_block
	LDX #$004E							;max number of plms is 4E/2
	-
	LDA !P_Headers,x : CMP #$D70C : BEQ + ;loop through plm headers until it finds the glass breaking one
	DEX #2 : BPL -
	+
	LDA #$8300 : STA !P_Variable,x		;and tell it that it was hit with a power bomb so it'll wake up
	LDA #$D4FC : STA $7EDEBC,x			;when it wakes up, we want to skip the part where it waits and shows cracks
	LDA #$0000 : JSL !Disable_samus		;and because we're skipping that bit, we need to manually disable samus' movement
	CLC									;but we don't want her to lose her spark, so we need to remove this block even though the tube technically does it anyway
	RTS
	
.delete
	LDA #$0000
	STA !P_Headers,y
	SEC
	RTS

; ::: Bomb blocks :::
Bomb_block:
.init
	LDX !W_Proj_index
	LDA !W_Proj_type,x : AND #$0F00		;check projectile type (only missiles included here)
	CMP #$0500 : BEQ .break_tile		;bombs break tile
	CMP #$0300 : BEQ .break_tile_alt	;power bombs break tile
	PHA
   %check_option(!C_O_Block_reveal)
	PLA
	CMP #$0000 : BNE +
	LDA !W_Hyper_beam : BEQ .reveal_tile		;beams reveal tile
	BRA .break_tile
	+
	-
	LDA #$0000
	STA !P_Headers,y
	RTS
.end
	PLA : BRA -
	
.break_tile
	LDX !P_Location,y
	LDA !W_Room_tilemap,x : AND #$F000	;save the tile value to return the block to once respawned
	ORA #$0058 : STA !P_Respawn_value,y
	AND #$8FFF : STA !W_Room_tilemap,x	;and then turn the tile to air until that happens
	RTS
	
.break_tile_alt
   %inc("!P_Instr_next,y", #$0003)
	LDX !P_Location,y
	BRA .break_tile						;the rest of this is exactly the same as above, silly nintendo

.reveal_tile
	LDA !P_Location,y
	LSR : TAX
	LDA !W_Room_bts,x : AND #$0007		;the bts for bomb blocks, not including chain blocks, is 0-7
	ASL A : TAX
	LDA .bomb_type,x					;this table has the plms that reveal the tile type, normally only used when respawning the blocks
	STA !P_Instr_next,y					;but this way it'll just turn the block into the correct type and graphic if shot
	RTS

.bomb_type
	dw $C904, $C90A, $C910, $C916, $C904, $C90A, $C910, $C916

; --- Quote58 (inspired by chain block plm by Black Falcon) ---
; ***** this needs an explanation so people know what the fuck to put in smile you god damn idiot ******

Chain_block:
.bomb_header							;the normal chain block is a shot block, but bombs can make it as well, which means they need their own header to check the projectile
	dw Bomb_block_init, .instr
	
.super_header
	dw Super_missile_block_init, .instr
	
.missile_header
	dw Missile_block_init, .instr
	
.power_header
	dw Power_bomb_block_init, .instr
	
.header
	dw .init, .instr

.instr
	dw !InstrPlaySound2 : db !ArgBreakBlockSound
	dw $0004, $A345						;frame delay, tilemap
	dw .continue_chain					;find new blocks in the chain and spawn a new plm at all of them
	dw $0004, $A34B						;animation of a block breaking
	dw $0004, $A351
	dw $0001, $A357
	dw !InstrKill						;deletes the plm header and PLA to end instructions

.init
	LDX !P_Location,y
	LDA !W_Room_tilemap,x
	AND #$8FFF : STA !W_Room_tilemap,x	;just turns the tile into air by removing everything but property bits
	RTS

.continue_chain
; *** make this main routine less shitty *** <-- okay past me, I'll try! Don't fuck it up future me!

   !phxy
	TXY									;used to get P_Location,y later
	LDA !P_Location,x : LSR : TAX
	LDA !W_Room_bts,x : AND #$00FF
	CMP #$0011 : BMI .end
	CMP #$0018 : BMI .normal_chain_block
	CMP #$001B : BMI .super_missile_block
	CMP #$001E : BMI .power_bomb_block
	CMP #$0020 : BPL .end
.missile_block
	SEC : SBC #$000D : BRA .normal_chain_block
.power_bomb_block
	SEC : SBC #$000A : BRA .normal_chain_block	;super missile chain blocks are stored after the normal chain blocks
.super_missile_block	
	SEC : SBC #$0007
.normal_chain_block
	DEC : AND #$0007					;11 - 17 are the different ways the block can move, DEC just allows the table to start at 0
	ASL A : TAX
	LDA !P_Location,y : PHA
	LSR : TAY
	PLA : JSR (.move_type,x)
.end
   !plxy
	RTS

.move_type
	dw .move_h, .move_v, .move_all, .move_right, .move_left, .move_up, .move_down

.make_plms
	LDA !W_Room_tilemap,x					;make sure the block we're destroying is solid/crumble/grapple/etc. and not air or something
	AND #$F000 : CMP #$8000 : BMI +
				 CMP #$9000 : BEQ +
				 CMP #$D000 : BEQ +
   %lsx(1)
	LDA !W_Room_bts,x
	AND #$00FF : CMP #$0011 : BMI +		;make sure the blocks we want to spawn a plm at are using the right bts value
				 CMP #$0018 : BPL +
	STY !W_Current_block
	LDA #.header : JSL Make_simple_plm_alt
	SEC
	RTS
	+
	CLC
	RTS

.move_right
	TAX : INY
   %right()
	JSR .make_plms : BCC +
	DEY : STY !W_Current_block
	+
	RTS

.move_left
	TAX : DEY
   %left()
	JSR .make_plms : BCC +
	INY : STY !W_Current_block
	+
	RTS

.move_up
	TAX
   %dey(!W_Room_width)
   %up() : JSR .make_plms : BCC +
	TYA : CLC : ADC !W_Room_width
	STA !W_Current_block
	+
	RTS

.move_down
	TAX
   %iny(!W_Room_width)
   %down() : JSR .make_plms : BCC +
	TYA : SEC : SBC !W_Room_width
	STA !W_Current_block
	+
	RTS

.move_h
   !phr : JSR .move_right
   !plr : JSR .move_left
	RTS
	
.move_v
   !phr : JSR .move_up
   !plr : JSR .move_down
	RTS

.move_all
   !phr : JSR .move_h
   !plr : JSR .move_v
	RTS

; :::										  :::
; ::: Various routines used by specific plms  :::
; :::										  :::

; --- Quote58 ---
Collect:
.tank									;hijack point from scyzer
   !phr
	LDA !W_Collected_items				;simply INC's this address every time you collect any kind of item
	INC A
	STA !W_Collected_items
	JSL !Get_PLM_XY
   !plr
	JSL !Check_bit
	RTL

.beam
   !phr
	JSL !Update_palette
   !plr
	LDA #$0168
	RTS

.grapple_xray
	LDA !C_H_Select : JSL Hud_init_specific
	RTS

.charge
	JSR $88B0
	LDA !C_H_Charge : JSL Hud_init_specific
	RTS

.speed
	JSR $88F3								;finish the normal routine to set the equipment bit
	LDA !C_H_Magic+!C_H_Spark_dup : JSL Hud_init_specific		;and then refresh the hud to make sure the speed metre will show up
	RTS

; these ammo routines could be combined, especially if you don't include the hud init stuff
; but it's not worth the effort right now since PB also called different message boxes
.missile
   %inc(!W_Missiles_max, "$0000,y")
   %inc(!W_Missiles, "$0000,y")
	LDA !C_H_Select+!C_H_Missiles_dup : JSL Hud_init_specific
	LDA #$0002 : BRA ++

.super
   %inc(!W_Supers_max, "$0000,y")
   %inc(!W_Supers, "$0000,y")
	LDA !C_H_Select+!C_H_Supers_dup : JSL Hud_init_specific
	LDA #$0003 : BRA ++

.power
   %inc(!W_Powers_max, "$0000,y")
   %inc(!W_Powers, "$0000,y")
	LDA !C_H_Select+!C_H_Powers_dup : JSL Hud_init_specific
	LDA #$0004 : BRA ++

.reserve_tank
	LDA !W_Reserves_type : BNE +
	INC !W_Reserves_type
	+
	LDA !C_H_Reserves : JSL Hud_init_specific	;make sure the hud updates the icon for the reserves
	LDA !C_H_Health : JSL Hud_init_specific	;make sure the hud updates the etanks in case the reverse just drew over them with a blank tile (very specific I know)
   %inc(!W_Reserves_max, "$0000,y")
   %inc(!W_Reserves, "$0000,y")			;only thing added here is that the reserves now add a filled tank instead of an empty one
	LDA #$0019
	++
	PHA : LDA #$0168 : JSL $82E118		;restart the room music after n frames (length of message box)
	PLA : JSL !Message_box
	INY #2
	RTS

.map_data								;this was originally in the message box routines, but that was stupid so now it's here like you would expect it to be
   !phxy
	LDX $079F
	LDA $7ED908,x : ORA #$00FF : STA $7ED908,x
	LDA #$0014 : JSL !Message_box
	LDA #$000C : STA $0998
	LDA #$0001 : STA $0789
   !plxy
	RTS

; :::							:::
; ::: New Save station routines :::
; :::							:::

; --- Quote58 ---
Save_station:
.init
	LDX !P_Location,y
	LDA #$B04D : JSR !Write_block_bts
	RTS

.instr
	dw $0001, $9A3F
	dw .reset_save
	dw .save_check, .end
	dw $B00E
	dw $8C07 : db $2E
	dw $874E : db $15
.loop
	dw $0004, $9A9F
	dw $0004, $9A6F
	dw !InstrGoToDec, .loop
	dw $B024
.end
	dw $B030
	dw !InstrGoTo, .instr

.reset_save
   !phxy
	JSL !Get_PLM_XY	
	LDA !P_X_pos : DEC : STA !P_X_pos
	LDA !W_X_pos : LSR #4 : STA !P_Y_pos
	CMP !P_X_pos : BMI +
	LDA !P_X_pos : INC #4 : STA !P_X_pos
	LDA !P_Y_pos : CMP !P_X_pos : BPL +
	BRA ++
	+
	STZ !W_Save_used
	++
   !plxy
	LDA #$0001 : STA !P_Frame_delay,x
	PLA
	RTS

.save_check
   !phxy
	LDA !C_O_Auto_save : JSL Check_option_bit : BCS +
	LDA #$0017 : JSL !Message_box
	CMP #$0001 : BEQ .no_save
	+
	LDX !P_Index : LDY #$E6D2 : JSL $868097		;spawn the save plm
	LDA !P_Args,x : AND #$0007 : STA !W_Current_station
	JSL !Check_bit						;why is this checking a bit for no reason?
	LDA !W_Region : ASL : TAX
	LDA $7ED8F8,x : ORA !W_Bit_check : STA $7ED8F8,x
	LDA !W_Save_slot : JSL !Save_game
   !plxy
	INY #2
	RTS

.no_save
   !plxy
	LDA $0000,y : TAY
	RTS

; :::										  :::
; ::: Misc routines used by stuff in bank $84 :::
; :::										  :::

; --- Quote58 ---
Samus_PLM_contact:						;X = PLM index
	JSL !Get_PLM_XY						;this routine updates the PLM's X/Y so that we can check if samus is touching it
	LDA !W_Y_pos : LSR #4
	CMP !P_Y_pos : BNE +
	LDA !W_X_pos : LSR #4
	CMP !P_X_pos : BNE +
	SEC									;sec = samus is touching plm
	RTS
	+
	CLC									;clc = samus is not touching plm
	RTS

Make_simple_plm_alt:					;this is an alternate version of the simple plm spawning routine, but can be used during a plm instruction list
	PHB
	PHY : PHX : PHK
	PLB
	TAY									;put the plm-to-spawn header in Y
	LDX #$004E							;max number of plms is 4E/2
.find_space
	LDA !P_Headers,x					;loop through plm headers, if it's empty, use it
	BEQ .initialize
	DEX #2
	BPL .find_space
	PLX : PLY							;no more room for plms, exit (this should really CLC or something to signal the error)
	PLB
	RTL
	
.initialize
	LDA !W_Current_block : ASL A		;current block index * 2 = index into room tilemap
	STA !P_Location,x					;which is used to intialize the plm's index
	TYA
	STA !P_Headers,x					;plm header -> A -> plm header list
	LDA #$853D  : STA !P_pre_instr,x	;plm pre processing instruction = RTS
	LDA $0002,y : STA !P_Instr_next,x	;plm header + 2 = plm instruction list -> plm next instruction pointer
	LDA #$0001  : STA !P_Frame_delay,x;set a standard frame delay
	LDA #$8DA0  : STA !P_Tile_value,x	;set some sort of tile value to the new tile value for the plm
	LDA #$0000  : STA $1D77,x			;clear out the variable use ram for the plm
				  STA $1DC7,x
				  STA $7EDF0C,x
	TXA									;plm index  -> A   unlike the normal plm spawning routine, this one does not change the current plm to process index (1C27)
	TYX									;plm header -> X
	TAY									;plm index  -> Y
	JSR ($0000,x)						;run the init pointer of the current plm
	PLX : PLY
	PLB
	RTL

; :::								    :::
; ::: Music and soundfx related changes :::
; :::							   	    :::
; --- Scyzer ---
Clip:
.check
	LDA !W_Item_clip : CMP #$0002 : BEQ +
	LDA #$0000 : JSL $808FF7			;Changes music song/instruments or music track to A, with a Y-frame delay (minimum of 8). Does not stop 0639 from lapping 063B
	LDA $07F5  : JSL $808FC1			;Changes music song/instruments or music track to A, with an 8-frame delay. Makes sure 0639 does not lap 063B
	+
	LDA #$0000 : STA !W_Item_clip
	RTL
	
.set
	LDA #$0001 : STA !W_Item_clip
	JSL !Pause_sounds
	LDA #$0000
	RTS

.item_sfx
	LDA !W_Item_sfx : BEQ .sound_fx		;if item_sfx is 0, it will act like InstrSoundFX
	JSR .set : STA $063D				;but if it's anything else, it will play the vanilla fanfare sound
	LDA #$0002 : JSL $808FC1			;item fanfare sound
	INY
	RTS

.sound_fx
	JSR .set_fx
	AND #$00FF
	JSL $809049
	RTS

.special_fx
	JSR .set_fx
	JSL $8090CB
	RTS
	
.misc_fx
	JSR .set_fx
	JSL $80914D
	RTS
	
.set_fx
	LDA #$0002 : STA !W_Item_clip
	LDA $0000,y
	INY
	RTS

print "End of free space (84FFFF): ",pc











