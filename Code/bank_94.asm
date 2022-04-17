lorom

; misc changes
org $949B4C : dw Scroll_block			;pointer to code for block type $06
org $948884 : JSR Spark_restart			;code that runs when samus touches a slope
org $94953E : JSR Walk_on_water			;hijack of vertical collision reaction routine. Index into tile type collision table in X
org $949CF9								;hijack of bomb collision detection of adjacent blocks
	JSR Bomb_collision_check
	RTS

; automorph hijack
org $949543
	JSR $9495							;calculate samus' height
	JSR Check_for_block_collisions		;where the magic happens ;)
	RTS

; bts table changes
org $94A003 : LDA.w BTS_bomb_table,x
org $94935B : LDA.w BTS_bomb_table_collisions,x
org $94933C : LDA.w BTS_bomb_table_collisions,x

; gotta import some labels so the tables don't look all fucked up
incsrc Code/data/plm/bts_plm_labels.asm

org $949139
BTS_crumble_table:
	dw $D044, $D048, $D04C, $D050, $D054, $D058, $D05C, $D060, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $D038, $D040
	dw !NoPLM, !MGL

org $949EA6								;this is the shot block bts table, which goes until $80, at which point the region dependant tables start (but are never used)
BTS_shot_table:
;normal chain block starts at $11
;super missile chain block starts at $18
;power bomb chain block starts at $1B
;missile chain block starts at $1E

	dw !RShot1x1, !RShot2x1, !RShot1x2, !RShot2x2, !Shot1x1, !Shot2x1, !Shot1x2, !Shot2x2
	dw !RPB, !PB, !RSM, !SM, !RMB, !MB, !NoPLM, !NoPLM, $B974
	dw !CB, !CB, !CB, !CB, !CB, !CB, !CB
	dw !SCB, !SCB, !SCB
	dw !PCB, !PCB, !PCB
	dw !MCB, !MCB, !MCB
	dw !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM
	dw $F038, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM
	dw !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM
	dw !BDoorL, !BDoorR, !BDoorU, !BDoorD, $C83E, $EED3
	dw !BGateL, !BGateR, !RGateL, !RGateR, !GGateL, !GGateR, !YGateL, !YGateR
	dw !NoPLM, !AnimalWall
	dw !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM
	dw !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM
	dw !NoPLM, !NoPLM, !NoPLM, !NoPLM

org $94B19F
; free space until gunship escape blast gfx (C800)

; --- Quote58 ---
BTS_bomb_table:							;this is the new bomb block bts table, because originally it was dumb
	dw $D0B8, $D0BC, $D0C0, $D0C4, $D0C8, $D0CC, $D0D0, $D0D4, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM
	dw !BCB, !BCB, !BCB, !BCB, !BCB, !BCB, !BCB, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM

.collisions
	dw $D098, $D09C, $D0A0, $D0A4, $D0A8, $D0AC, $D0B0, $D0B4, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM
	dw $D098, $D098, $D098, $D098, $D098, $D098, $D098, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM, !NoPLM

; --- Scyzer ---
Check_block_index:
	TXA : AND #$FFFE : TAX				;in the unlikely event of a bad index (croc's room), this corrects it
	CPX !W_Room_area
	RTS

; --- Scyzer (Slightly optimized by quote58) ---
;Tile Type = $06 ("Air???" in smile, unused normally)
;BTS = Screen #
;	+00 = Red scroll
;	+40 = Blue scroll
;	+80 = Green scroll
Scroll_block:
	PHP
	SEP #$20
	LDX !W_Current_block
	LDA $7F6402,X						;index the bts tilemap with the current block
	PHA : AND #$3F : TAX				;take everything but the scroll colour, and use it as the index into the scroll map (limiting the room size it works in to 63 scrolls)
	PLA : AND #$C0						;take the 2 most significant bits and shift them to the end, leaving a value of 00, 04, or 08
	XBA : LSR #2						;this saves 3 bytes and 5 cycles over the LSR #6 :3
	STA $7ECD20,X						;which is then used to set the new scoll value
	PLP
	RTS

; --- Quote58 ---
Walk_on_water:
	TXA : BEQ + : CMP #$0002 : BEQ +
	BRA .end
	+
   %check_option(!C_O_Water_walk)
	JSL Is_morphed : BCS .end
	LDA !W_V_direction : BNE .end
	LDA !W_Speed_counter : AND #$0F00
	CMP #$0400 : BNE .end
	LDA !W_H_speed : CMP #$0003 : BMI .end
	LDA !W_Y_radius : CMP #$0011 : BMI .end
	PHX
	LDA !W_Current_block : ASL : TAX
	PHY
	JSL Find_xy : TYA
	PLY
	PLX
	PHA
	LDA !W_FX3_type : CMP #$0006 : BEQ .water
					  CMP #$0002 : BEQ .lava
					  CMP #$0004 : BEQ .acid
	PLA
.end
	JSR ($94F5,x)						;tile type collision table
	LDA #$0000 : STA !W_Water_running
	RTS

.acid
	PLA
	CMP !W_FX3_Ypos : BNE .end
	JSR .draw_smoke
	LDA #$0001 : STA $0A50
	LDX #$0010 : BRA .end

.lava
	PLA
	CMP !W_FX3_Ypos : BNE .end
	JSR .draw_smoke
	LDA !W_Items_equip : BIT !C_I_gravity : BNE +
	LDA #$0001 : STA $0A50
	+
	LDX #$0010 : BRA .end

.water
	PLA
	CMP !W_FX3_height : BNE .end
	LDA #$0001 : STA !W_Water_running
	LDX #$0010							;index for solid tile
	JSR ($94F5,x)
	RTS
	
.draw_smoke
	LDA !W_Current_frame : BIT #$0001 : BNE +
	PHY
	LDA $12 : PHA : LDA $14 : PHA
	LDA $16 : PHA : LDA $18 : PHA
	LDA !W_X_pos : STA $12
	LDA !W_Y_pos : CLC : ADC #$0010 : STA $14
	LDA #$0009 : STA $16
	STZ $18
	JSL $B4BC26
	PLA : STA $18 : PLA : STA $16
	PLA : STA $14 : PLA : STA $12
	PLY
	+
	RTS

; --- Quote58 ---
; automorph revision 4
; code now maps the blocks it needs to know about and then compares that with predefined bitmaps to know what block patterns should cause morph and what shouldn't
; easy to add to and modify in theory, but code needs to be polished before it will be easy to do in practice
; config 1:		 config 2:		 config 3:
;    o	[ ]			o				o	[ ]
;   -|\	[ ]		   -|\	[ ]		   -|/
;   / \  		   / \			   / \	[ ]
;
; config 4:		 config 5:		  \config 6:
; 	  [ ][ ]         [ ]		 \\    [ ]
; 	 /--\              /--\[ ]	   /--\[ ]
;  	 \--/[ ]           \--/[ ]	   \--/
;   //	 [ ]         //    [ ]		   [ ]
;    /                 /			   [ ]
Check_for_block_collisions:
!BlockCount  = $1A
!Yindex 	 = $20
!Speed 		 = $12
!Speedsub 	 = $14
!Newblock 	 = $18
!Newblocksub = $16
!BlockMap 	 = $02
!BlockBit	 = $04

!Config1 = #$0005
!Config2 = #$0004
!Config3 = #$0011
!Config4 = #$0013
!Config5 = #$0011
!Config6 = #$0012

	LDA !W_Y_pos : %sbc(!W_Y_radius)
	LSR #4
   %multiply(!W_Room_width)
   %add(!W_X_pos_sub, !Speedsub, !Newblocksub)
	LDA !W_X_pos : ADC !Speed : STA !Newblock
	BIT !Speed : BPL .right
.left
   %sbc(!W_X_radius) : BRA +
.right
   %adc(!W_X_radius) : DEC A
    +
	STA !Yindex
	LSR #4
   %adc(!R_Product) : ASL A : TAX		;X now holds the index of the block for collision detection

.check_block
	JSR $9515 : BCC .check_next_block	;check what to do for the block at the given index. If clear, keep checking blocks. If set, collision is supposed to happen
	JSR .prereqs : BCS .collision		;check all the prerequesits for automorph to be allowed to happen
	JSR Automorph : BCC .clear_to_morph	;main hook into automorph
	BRA .collision
	
.check_next_block
	TXA : CLC : ADC !W_Room_width : ADC !W_Room_width
	TAX
	DEC !BlockCount : BPL .check_block
	
.no_collision
	CLC
	RTS

.collision
	SEC
	RTS

.clear_to_morph
	LDA #$0002 : STA !W_Auto_morph
	LDA !C_O_Morph_flash : JSL Check_option_bit : BCC +
	LDA !C_Flash_amount : STA !W_Morph_flash ;activate morph flash by resetting the palette index
	+
	CLC
	RTS

.prereqs
	LDA !C_O_Auto_morph : JSL Check_option_bit : BCC +
	JSL Is_moonwalking : BCS +
	JSL Is_morphed 	   : BCS +
	LDA !W_Items_equip : BIT !C_I_morph : BEQ +
	CLC
	RTS
	+
	SEC
	RTS

Automorph:
	PHX : PHY
	LDA !BlockMap : PHA : LDA !BlockBit : PHA
	STZ !BlockMap : LDA #$0001 : STA !BlockBit
	JSR .main : BCS .no_morph			;now we can actually handle the automorphing
	
.morph
	LDA !W_Current_pose : BIT #$0001 : BNE +
	LDA #$0404 : STA !W_X_direction
	LDA #$0038 : BRA .pose_set
	+
	LDA #$0408 : STA !W_X_direction
	LDA #$0037 : BRA .pose_set

.pose_set
	STA !W_New_pose
	STZ $0DC6
	LDA !W_Auto_morph : BNE +
	STZ !W_Animation_frame
	+
	PLA : STA !BlockBit : PLA : STA !BlockMap
	PLY : PLX
	CLC
	RTS
	
.no_morph
	PLA : STA !BlockBit : PLA : STA !BlockMap
	PLY : PLX
	SEC
	RTS
	
.main
	JSR Collision_pos_check : BCC .end_not_clear ;check to make sure samus is on the same Y block line as the block we're checking
	JSR Collision_pos					;check where on samus the collision is and leave the answer in Y
	JSR Map_blocks						;build a complete bitmap of the surrounding blocks to compare with preset block positions
   %asy(1) : TYX
	LDA .config,y : TAY
	JSL Is_spinning : BCC .not_spinning
	LDY #.spinning
	LDA !W_V_direction : BNE + : BRA .end_not_clear
	+
	CMP #$0002 : BEQ .moving_down
.moving_up
	TXA : LSR : BNE .end_not_clear
	LDA $0000,y : CMP !BlockMap : BEQ .end_clear
	LDA $0004,y : CMP !BlockMap : BEQ .end_clear
	BRA .end_not_clear
.moving_down
	TXA : LSR : CMP #$0002 : BNE .end_not_clear
	LDA $0002,y : CMP !BlockMap : BEQ .end_clear
	BRA .end_not_clear
	
.not_spinning
	JSR .check_aim : BMI .end_not_clear : BEQ +
	LDA $0002,y : CMP !BlockMap : BEQ .hop : BRA .end_not_clear
	+
	LDA $0000,y : CMP !BlockMap : BNE .end_not_clear
	CLC
	RTS

.end_not_clear
	SEC
	RTS

.end_clear
	LDA !W_V_direction : CMP #$0001 : BNE ++
	LDA #$0003 : STA !W_V_speed
	LDA !W_Current_pose : BIT #$0001 : BNE +
	LDA #$001A : BRA $03
	+
	LDA #$0019
	STA !W_Current_pose
	++
	CLC
	RTS

.hop
	LDA #$0002 : STA !W_V_speed
	LDA #$0001 : STA !W_V_direction
	CLC
	RTS

.config   : dw .bottom, .mid, .top
.top 	  : dw !Config1, !Config3
.mid 	  : dw !Config2
.bottom   : dw $0000
.spinning : dw !Config4, !Config5, !Config6

.check_aim
	LDA !W_Current_pose : AND #$00FF
	CMP #$0005 : BEQ .aim_up : CMP #$0006 : BEQ .aim_up
	CMP #$000F : BEQ .aim_up : CMP #$0010 : BEQ .aim_up
	CMP #$0007 : BEQ .aim_down : CMP #$0008 : BEQ .aim_down
	CMP #$0011 : BEQ .aim_down : CMP #$0012 : BEQ .aim_down
	LDA #$FFFF
	RTS
.aim_up
	LDA #$0001
	RTS
.aim_down
	LDA #$0000
	RTS

Collision_pos:							;gets the block's Y pos and compares it to samus' Y pos. BEQ -> block = middle, BPL -> block = top, BMI -> block = bottom
	LDY !BlockCount						;BlockCount already tells us where on samus the collision happened if she's standing
	JSL Is_spinning : BCS + : RTS		;if we're spinning however, it's not so easy
	+
	LDA !W_Y_pos : AND #$000F
	CMP #$0005 : BMI .bottom
	CMP #$0008 : BPL .top
.mid
	LDY #$0001 : RTS
.top
	LDY #$0002 : RTS
.bottom
	LDY #$0000 : RTS
	
.check
	JSL Is_spinning : BCC .standing
	LDA $00 : PHA
	PHX
	LDX !W_X_pos : LDA !W_Y_pos
	JSL Find_block : TXY
	PLX
	
	JSR Map_blocks_left_or_right : BCC +
	DEY #2 : BRA ++
	+
	INY #2
	++
	TYA : STA $00
	
	CPX $00 : BEQ + : PLA : STA $00 : CLC : RTS
	+
	PLA : STA $00
	SEC
	RTS

.standing
	SEC
	RTS

Map_blocks:
	PHY
	TYA : CMP #$0001 : BEQ + : BPL .map_helper
	%up()								;if block is at the bottom, we need to move the index up twice
	+
	%up()								;and if the block is in the middle, we only need to move it up once
.map_helper
	LDY #$0006
.map
	TYA : BEQ .end
	JSL Is_air_block : BCS .skip
	CMP #$1000 : BNE .solid
	PHX : TXA : LSR : TAX
	LDA !W_Room_bts,x : PLX : AND #$00FF	;gotta check those square bts blocks because fuck me right?
	CMP #$0013 : BEQ .solid : CMP #$0053 : BEQ .solid	;am I just forgetting scyzers scroll bts???
	CMP #$0093 : BEQ .solid : CMP #$00D3 : BEQ .solid
	CMP #$0092 : BEQ .solid : CMP #$00D2 : BEQ .solid	;changed from BNE .skip to BEQ .solid because that makes sense, but if that was on purpose I want to remember it
	CMP #$0097 : BEQ .solid : CMP #$00D7 : BEQ .skip
	PHA : JSL Is_spinning : BCS + : PLA : BRA .skip
	+
	PLA : CMP #$0052 : BEQ .solid : CMP #$0012 : BEQ .solid
.solid
	LDA !BlockBit : TSB !BlockMap
.skip
   %asl(!BlockBit, 1)
	TYA : CMP #$0005 : BEQ .move_down	;6 is the end of the first row
		  CMP #$0003 : BEQ .move_down	;3 is the end of the second row
	JSR .left_or_right : BCS +
	DEX #2 : BRA ++
	+
	INX #2
	++
	DEY : BRA .map

.end
	PLY
	RTS
	
.move_down
	JSR .left_or_right : BCS +
	INX #2 : BRA ++
	+
	DEX #2
	++
	TXA : CLC : ADC !W_Room_width : ADC !W_Room_width : TAX
	DEY : JMP .map

.left_or_right
	LDA !W_X_direction : AND #$00FF
	CMP #$0004 : BEQ +					;4 = left, 8 = right
	CLC
	RTS
	+
	SEC
	RTS

; --- Quote58 (hijack point from Drewseph) ---
Spark_restart:
   %check_option(!C_O_Spark_restart)
	LDA !W_Current_pose
	CMP #$00C9 : BEQ .right				;samus is sparking right
	CMP #$00CA : BEQ .left				;samus is sparking left

.end
	LDA #$0001
	RTS

.right
	LDA !W_Held : BIT !W_B_right : BNE +;check for at least holding right
	BRA .end
	+
	LDA !W_Ball_sparking : BEQ +
	LDA #$007B : STA !W_New_pose
	LDA #$0008 : JMP Restart_ball_setup
	+
	LDA #$0009 : STA !W_New_pose		;new pose
	BRA Restart

.left
	LDA !W_Held : BIT !W_B_left : BNE +	;check for at least holding left
	BRA .end
	+
	LDA !W_Ball_sparking : BEQ +
	LDA #$007C : STA !W_New_pose
	LDA #$0004 : JMP Restart_ball_setup
	+
	LDA #$000A : STA !W_New_pose
	LSR A

Restart:
	DEC A : STA !W_X_direction			;new movement direction (this is just to save 3 bytes and look pretty tbh)
	LDA #$0001
.ball	
	STA !W_Move_type					;new movement type
	LDA #$0009 : STA !W_H_speed			;set her to full speed moving forward when starting to run <-- this should totally be slower/faster based on frame even/odd just to fuck with the speed runners loool
	LDA #$FFFE : STA $12 : STZ $14
	JSL $949763							;adjust x/y for slope	

.variables
	LDA #$0001 : STA !W_Contact_dmg		;set contact damage to speed boosting
				 STA !W_Speed_flag		;tell the game to check speed counter
	LDA #$0402 : STA !W_Speed_counter	;set samus to speed boosting
				 STZ !W_V_direction		;set samus to standing on ground
				 STZ !W_Spark_timer
	LDA #$A337 : STA !W_Movement_pointer;run movement routines (next frame) based on new movement type	<-- IS THIS WHAT IS CAUSING THAT WEIRD AUTOMORPH BUG???? LOOK INTO IT!!!!
	LDA #$E913 : STA !W_Input_pointer	;allow player input to affect samus again
	LDA #$0001 : STA !W_Echoes_active	;restart the speed boosting sound
	RTS

.ball_setup
	STA !W_X_direction
	STZ !W_Ball_sparking
	LDA #$0011
	BRA .ball

; --- Quote58 ---
Shinespark_jump:
!Spin_right   = #$0019
!Spin_left    = #$001A
!Hspark_right = #$00C9
!Hspark_left  = #$00CA
!Vspark_right = #$00CB
!Vspark_left  = #$00CC

	LDA !W_Current_pose+1 : AND #$FF00	;check movement type, and set the spinjump pose accordingly
	CMP #$0400 : BEQ .left
	LDA !Spin_right : BRA .set_pose
.left
	LDA !Spin_left
.set_pose
	STA !W_New_pose						;set new pose (spin left/right)
	LDA #$0003 : STA !W_Move_type		;set movement type to spin jump
	
	LDA !W_Current_pose	
	CMP !Hspark_right : BEQ .horizontal
	CMP !Hspark_left  : BEQ .horizontal
	BRA .check_vertical
.horizontal
	LDA #$0001 : STA !W_Spark_exit
	BRA .adjust_speed
	
.check_vertical	
	LDA !W_Current_pose
	CMP !Vspark_right : BEQ .vertical
	CMP !Vspark_left  : BEQ .vertical
	
.adjust_speed
	LDA !W_H_speed : LSR #2 : STA $00	;h speed *= 3/4
	LDA !W_H_speed : LSR : CLC : ADC $00

.store_speed
	STA !W_H_speed
	JSR Restart_variables
	RTL

.vertical
	LDA #$0000
	BRA .store_speed

; --- Drewseph (Opimized/reduced by Quote58) ---	
;this originally used subroutines mirroring the ones used by the game for the same purpose
;however, that's a waste of cycles as this takes up very little space
Bomb_collision_check:
!LeftCheck  = "%left()  : JSR $A052"
!RightCheck = "%right() : JSR $A052"
!UpCheck 	= "%up()    : JSR $A052"
!DownCheck  = "%down()  : JSR $A052"

	LDA !W_Proj_type,x
	BIT #$0001 : BNE +
	ORA #$0001 : STA !W_Proj_type,x
	
	LDA !W_Current_block : CMP #$FFFF : BEQ +
	LDY #$0000
	LDA !W_Current_block
	
	ASL A : TAX							;block samus is currently in
	JSR $A052							;middle block (in case it respawns with samus in it)

										;this order of checking the blocks saves 2 bytes and is more logical
   !LeftCheck							;left
   !UpCheck								;top left
   !RightCheck							;top
   !RightCheck							;top right
   !DownCheck							;right
   !DownCheck							;bottom right
   !LeftCheck							;bottom
   !LeftCheck							;bottom left
	
	+
	RTS

print "End of free space before gunship gfx (94C800): ", pc

org $94DC00
; free space until the title bg mode 7 tiles (E000)

print "End of free space until bg mode 7 tiles (94E000): ", pc



