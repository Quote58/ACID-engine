lorom

; general stuff
org $90EA6E : LDA !C_Fade_speed				;start button input reaction
org $90A4F8 : CMP !C_Full_charge
org $90A747 : CMP !C_Full_charge
org $90B835 : CMP !C_Full_charge
org $90B85F : CMP !C_Full_charge
org $90C0B6 : CMP !C_Full_charge
org $90B846 : CMP !C_Max_charge
org $90D202 : STA !W_Spark_pal				;replacing all the references to 0A68 (Spark_timer) with a new address, so that the palette can be separate from the timer
org $90D135 : STA !W_Spark_pal				;this allows samus to exit a spark and not instantly be able to spark again
org $90D349 : STA !W_Spark_pal
org $90D3F6 : STA !W_Spark_pal
org $90D49D : STA !W_Spark_pal
org $90D03F : STA !W_Spark_pal

; these change the minimap update routine to store indirectly, allowing the hud to arrange the minimap however it wants with the data
org $90AAB1 : JMP Mini_map_row_1
org $90AAD8 : JMP Mini_map_row_2
org $90AB15 : JMP Mini_map_row_3
org $90AB2B : JMP Mini_map_final : NOP
org $90AB1B : STA !W_Mini_map_tiles+$14,x
org $90AADE : STA !W_Mini_map_tiles+$0A,x
org $90AAEE : STA !W_Mini_map_tiles+$0A,x
org $90AAF9 : LDA !W_Mini_map_tiles+$0A,x
org $90AAB7 : STA !W_Mini_map_tiles,x
org $90AAC7 : STA !W_Mini_map_tiles,x
org $90AB4A : PLP : RTL						;stop it from blinking

; overwriting the minimap clearing for bosses and such
org $90A7E8
	LDA #$2C1F : LDX #$001E
	-
	STA !W_Mini_map_tiles,x
	DEX #2 : BPL -
	LDA #$0001 : STA !W_Mini_map_mirror
	JSR Mini_map_blank
	JMP $A808

; misc changes
org $90BA80 : JSR Palette_stuff
org $90E11F : JSR Ridely_ceres_push_fix : PLB : PLP : RTL
org $90EA9D : JSR Low_health_alert_check : NOP #4
org $90F339 : JSR Low_health_alert_check : NOP #4 ;<--this one doesn't seem to actually be used, which is weird
org $90C539 : dw Check_charge_item_select
org $90BEDE : JSR Super_missile_recoil		;hijack right before non-beam projectile is fired

; movement related changes
org $908592 : JSR Quick_speed_boost			;normally adds 0200 to the counter, now it depends on the option
org $90EE4E : JSR Water_steps : RTS
org $90E5E9 : JSR Collision_speed_check		;hijack for zeroing speed upon hitting a wall
			  JMP $E604 : NOP
org $908022 : JSR Morph_animation_is_morphed_moving ;hijack of the part of the animation routine when the frame counter is decremented and stored back
org $908526 : JSR Morph_animation_main		;hijack of when the morph pose animation delay gets grabbed from the table
org $90831E : JSR Morph_animation_main
org $90A75A : JSR WJDamage

; bomb stuff
org $90BFFB : JSR Bomb_speed				;hijack of morph behaviour when holding fire, right before storing the timer amount (which is indirect because it was changed often I guess??)
org $90C06D : JSR Bomb_speed				; || but for power bombs
org $90BFB2 : JSR Bomb_spread_zero_charge	;hijack of morph behaviour routine, clears bomb charge if not holding fire, and triggers the spawn spread if bomb charge >0
org $90C0AB : JMP Bomb_spread_main			;handles bombs/bomb spread
org $90D849 : JSR Bomb_throw : JMP $D8B1	;rewrite of the routine that adds the speeds to each projectile in the bomb spread

; shinepark related changes
org $90D34C : JSR Ending_shinespark			;hijack of echo routine when ending shinespark
org $90D2BA	: JSR Shinespark_end			;hijack of main routine that checks whether or not to end a shinespark
			  BNE End_spark					;this allows sparks to be started with <30 health, as well as checking whether to exit the spark
			  JSR Shinespark_check : NOP #3
			  RTS
			  End_spark:					;this is where the routine that normally stops a shinespark is
			  STZ !W_Spark_timer
org $909902 : JSR Add_half_vertical_sub		;hijacking the vertical movement routine for samus so you don't jump super high out of shinespark
org $909910 : JSR Add_half_vertical_sub
org $909908 : JSR Add_half_vertical
org $909916 : JSR Add_half_vertical
org $909940 : JSR Add_half_zero				;hijack of point where the movement routine would set samus as moving up
org $90D121 : JSR Move_spark_v : RTS		;hijack during horizontal shinespark (also removes damage drain)
org $90D0FD : NOP #3						;removes the damage drain in diagonal
org $90D0C6 : JSR Move_spark_h : RTS		;hijack during vertical shinespark (also removes damage drain)

; all the hijack points for the ballspark code
org $91FA56 : JSL Ballspark_check : NOP #2	;main hijack point for ballspark
org $90D4B3 : JSR Ballspark_restore_left	;hijack points for restoring properties after spark has ending
org $90D4AB : JSR Ballspark_restore_right
org $90ECA5 : JSR Ballspark_restore_height
org $90ECAE : JSR Ballspark_restore_height_prev
org $908606 : JSR Ballspark_Animation_fake	;these hijacks are all used to fake the ballspark pose
org $908A0A : JSR Ballspark_Animation_fake	;8606 and 8a0a both hijack a samus drawing routine, the latter being called during door transitions
org $90EC25 : JSR Ballspark_Animation_fake
org $9082EB : JSR Ballspark_Animation_fake
org $928011 : JSL Ballspark_Animation_skip
org $92804C : JSL Ballspark_Animation_skip
org $9088DC : JSR Ballspark_Animation_fake_echo
org $908928 : JSR Ballspark_Animation_fake_echo
org $90EF0B : JSR Ballspark_Animation_echo_height
org $9088AD : JSR Ballspark_Animation_echo_height_final
org $9088FB : JSR Ballspark_Animation_echo_height_final
org $908874 : JSR Ballspark_Animation_echo_height_final

; beam related changes to make room for more beam tiles in vram
; charge spark index tables were in $93 for some reason, even though they're only referenced here
org $90BBFD : LDA Flare_index_right,x
org $90BC08 : LDA Flare_index_left,x
org $90B88F : JSR Beam_check				;repointing the function call to see whether samus can fire a beam to make sure it checks if a charge beam projectile is active
org $90B986 : JSR Beam_check_charge
org $90AC8D
   !phb
	LDA !W_Beams_equip
	AND #$0FFF : ASL : TAY
	JSR Beam_gfx							;update the gfx for the beam
	JSR Beam_gfx_spark						;update the gfx for the beam spark
	JMP $ACCD								;update the palette

; ice beam trail oam data (38 -> 3A, 39 -> 3B, 3A -> 3C, 3B -> 3D)
org $90B4CB
	rep 4 : dw $0001, $2C3C
	rep 2 : dw $0001, $2C3D
			dw $B525, $0001, $2C3D, $0001, $2C3D
	rep 8 : dw $B525, $0001, $2C3E
			dw $B525, $0004, $2C3F

; same data as above, but with the function changed to b587
org $90B52D
	rep 4 : dw $0001, $2C3C
	rep 2 : dw $0001, $2C3D
			dw $B587, $0001, $2C3D, $0001, $2C3D
	rep 8 : dw $B525, $0001, $2C3E
			dw $B525, $0004, $2C3F

; wave beam trail
org $90B58F : dw $0004, $2A3A
			  dw $0004, $2A40
			  dw $0004, $2A43
			  dw $0004, $2A3B
			  dw $0000

; missile/super smoke trail
org $90B5A1 : dw $0004, $2A48
			  dw $0004, $2A49
			  dw $0004, $2A4A
			  dw $0004, $2A4B
			  dw $0000

; location in rom (bank 9A) of the arm cannon opening tile gfx, indexed by direction with 90C7A5
org $90C7B9 : dw $0000,$82A0,$84A0,$86A0
			  dw $0000,$88A0,$8AA0,$8CA0
			  dw $0000,$8EA0,$90A0,$92A0
			  dw $0000,$94A0,$96A0,$98A0

; --- Scyzer ---
; this is part of respin
org $90A383									;hijack of collision detection routine
	JMP Landing
	Slow_down:

; --- Quote58 ---
; these changes allow you to force speed echoes outside of speed booster
org $9087C5 : JSR Check_echoes_force		;hijack of the routine that draws speed echoes when drawing samus' sprite
org $90EEE7 : JSR Check_echoes_force		;hijack of the routine that updates the position of speed echoes (in the main samus movement type routine)
org $908855									;hijack of the routine that draws samus echoes
	JSR Check_echoes : BCS +				;if the option bit is set, draw the echoes like normal, no matter what routine is calling it
	NOP : RTS
	+
	PHY

; --- Kejardon (with MAJOR bug fix by JAM) ---
; these changes to the super missile projectile routines make it into a single projectile
; instead of the two projectiles put together that the original game used
; and thanks to a branch fix by JAM, it now doesn't crash seemingly randomly!
org $90AC60 : NOP #2						;cancels a branch that's now unneeded since super missiles take only one slot
org $90AE19 : BRA $02						;skips a JSL that would cause a graphical glitch (might be a problem?)
org $90B005
	JSR $B329
	LDA !W_Proj_dir,x : AND #$000F
	ASL A : TAX
	JSR ($B033,x)
	JSR $B16A : BCC +						;checks if out of bounds
	JSL $90ADB7								;deletes the projectile if it is
	+
	RTS										;fun fact: This RTS, which is hex value $60, is also the number of bytes from here to another JSL $90ADB7. This is why the patch would sometimes crash before JAM's fix
											;it's also god damn mind bogglingly *lucky* that the routine is $60 bytes away exactly, because otherwise the patch never would've worked without JAM's fix.
org $90AFF1 : BRA $29						;(THANK YOU JAM) this is BRA $28 in the original game, but the new routine is slightly longer, so this branch needs to change accordingly
org $90B362 : RTS

org $90B2F6
	PHP : REP #$30
	PHX : PHY
	LDA $0C7C,x : BNE +
	INC : STA $0C7C,x
	LDA #$0100 : STA $16
	STX $12
	JSR $B1F3								;sets the initial speed of a projectile
	BRA ++
	+
	JSR $B329
	++
	PLY : PLX
	PLP
	RTS

org $90B366									;vertical collision detection
	LDX $0DDE
	LDA !W_Proj_type,x : AND #$0F00
	CMP #$0200								;check if projectile is a super missile
	BNE +++
	LDA !W_Proj_Yspeed,x : BPL +
	EOR #$FFFF
	INC A
	+
	AND #$FF00 : CMP #$0B00 : BMI +++		;if speed >= B pixels per frame
	XBA : SEC : SBC #$000A					;check collision at speed-A pixels earlier
	STA $12
	LDA $0B78,x : PHA						;save previous position
	BIT !W_Proj_Yspeed,x : BMI +			;check direction
	SEC : SBC $12
	BRA ++
	+
	CLC : ADC $12
	++
	STA $0B78,x								;move position back according to direction
	JSL $94A4D9								;collision detection
	LDA !W_Proj_type,x : AND #$0F00
	CMP #$0800
	PLA : BCS +++							;if collided, counter is set, rts
	STA $0B78,x								;else restore old position, counter is clear, rts
	+++
	RTS

org $90B406									;horizontal collision detection
	LDX $0DDE
	LDA !W_Proj_type,x : AND #$0F00
	CMP #$0200								;check if projectile is a super missile
	BNE +++
	LDA !W_Proj_Xspeed,x : BPL +
	EOR #$FFFF
	INC A
	+
	AND #$FF00 : CMP #$0B00 : BMI +++		;if speed >= B pixels per frame
	XBA : SEC : SBC #$000A					;check collision at speed-A pixels earlier
	STA $12
	LDA $0B64,x : PHA						;save previous position
	BIT !W_Proj_Xspeed,x : BMI +			;check direction
	SEC : SBC $12
	BRA ++
	+
	CLC : ADC $12
	++
	STA $0B64,x								;move position back according to direction
	JSL $94A46F								;collision detection
	LDA !W_Proj_type,x : AND #$0F00
	CMP #$0800
	PLA : BCS +++							;if collided, counter is set, rts
	STA $0B64,x								;else restore old position, counter is clear, rts
	+++
	RTS
	
org $90E9CE
; --- Quote58 ---
; this routine was expanded to include the ice beam thing and is still 1 byte smaller than vanilla
; the ice beam thing is that holding charged ice beam will reduce heat/lava/acid damage
Periodic_damage:
	PHP										;it now checks for gravity and varia (same logic as vanilla, gravity is /4 regardless of varia)
	REP #$30								;but also for having charged ice beam
	LDA !W_Pause_time : BNE .clear
	LDA !W_Items_equip : BIT !C_I_gravity : BEQ .varia
	JSR .half_damage : BRA +
.varia
	BIT !C_I_varia : BEQ ++
	+
	JSR .half_damage
	++
	LDA !W_Beams_equip : BIT !C_I_ice : BEQ +
	LDA !W_Charge : CMP !C_Full_charge : BMI +
	JSR .half_damage
	+
	LDA !W_Periodic_dmg_sub+1
	PHA : XBA : AND #$FF00 : STA !W_Periodic_dmg_sub
	PLA : XBA : AND #$00FF : STA !W_Periodic_dmg

.no_qualifiers
	LDA !W_Periodic_dmg : BMI .clear
   %dec(!W_Health_sub, !W_Periodic_dmg_sub)
	LDA !W_Health : SBC !W_Periodic_dmg : STA !W_Health
	BPL .clear
	STZ !W_Health_sub
	STZ !W_Health
.clear
	STZ !W_Periodic_dmg_sub
	STZ !W_Periodic_dmg
	PLP
	RTS
	
.half_damage
	LDA !W_Periodic_dmg_sub+1 : LSR : STA !W_Periodic_dmg_sub+1
	RTS

; --- Quote58 ---
; beam pointers have been repointed so that each combo has a unique palette
org $90C3C9
Beam_palette_pointers:
	dw .charge
	dw .wave
	dw .ice
	dw .wave_ice
	dw .spazer
	dw .spazer_wave
	dw .spazer_ice
	dw .spazer_wave_ice
	dw .plasma
	dw .plasma_wave
	dw .plasma_ice
	dw .plasma_wave_ice

org $90F63A
.charge 		 : skip 32
.wave			 : skip 32
.ice			 : skip 32
.wave_ice 		 : skip 32
.spazer 		 : skip 32
.spazer_wave 	 : skip 32
.spazer_ice		 : skip 32
.spazer_wave_ice : skip 32
.plasma 		 : skip 32
.plasma_wave	 : skip 32
.plasma_ice 	 : skip 32
.plasma_wave_ice : skip 32
; free space in bank $90

; --- Quote58 ---
; allows the player to jump out of a shinespark and into a spinjump while retaining their speed
Shinespark:
.check
	LDA !W_Pressed : BIT !W_B_jump : BNE .exit
	RTS
.exit
	LDA !C_O_Spark_exit : JSL Check_option_bit : BCC .cancel
	LDA !W_Ball_sparking : BNE .cancel		;don't want this to work with ballspark (OR DO WE?????? <-- WE REALLY DON'T)
	JSL Shinespark_jump						;this sets up everything for samus to no longer be shinesparking
.cancel
	RTS
.end
	LDA !W_Collision_flag : BEQ +
	LDA #$0014 : STA !W_Scrn_shake_type		;we need to give shake time 1 more than the correct amount (super missiles use 1E)
	LDA #$001F : STA !W_Scrn_shake_time		;because this happens after enemy processing, so we need it to be 1D *next* frame if we want the enemy is to fall
	LDA !W_Collision_flag
	+
	RTS

; --- Quote58 ---
Check_echoes:
	LDA !C_O_Speed_echoes : JSL Check_option_bit : BCS +
	CLC
	RTS
	+
	LDA !W_Current_pose
	ASL #3 : TAX
	SEC
	RTS

.force
	LDA !W_Force_echoes : CMP #$0001 : BNE +
	LDA #$0400
	RTS
	+
	LDA $0B3E
	RTS

; --- Quote58 ---
Mini_map:
.row_1
	AND #$E3FF : PHA
	LDA !W_Mini_map_tiles,x : STA !W_Mini_map_temp
	PLA : JMP $AAB4
.row_2
	AND #$E3FF : PHA
	LDA !W_Mini_map_tiles,x : CMP !W_Mini_map_temp : BEQ +
	LDA #$0001 : STA !W_Mini_map_mirror
	+
	LDA !W_Mini_map_tiles+$0A,x : STA !W_Mini_map_temp
	PLA : JMP $AADB
.row_3
	AND #$E3FF : PHA
	LDA !W_Mini_map_tiles+$0A,x : CMP !W_Mini_map_temp : BEQ +
	LDA #$0001 : STA !W_Mini_map_mirror
	+
	LDA !W_Mini_map_tiles+$14,x : STA !W_Mini_map_temp
	PLA : JMP $AB18
.final
	STA !W_Mini_map_tiles+$14,x
	CMP !W_Mini_map_temp : BEQ +
	LDA #$0001 : STA !W_Mini_map_mirror
	+
	JMP $AB2F
.blank
	LDA !C_H_Minimap : JSL Hud_init_specific
	LDA #$0001 : STA !W_Disable_minimap
	RTS

; --- Quote58 ---
Palette_stuff:							;what the fuck is this for???	<-- I guess I found out, added the state check, and then didn't comment to explain??? I still don't remember it's for!!
	STA $0C04,y : RTS
	LDA !W_Game_state : CMP #$001E : BEQ + ;if the game state is intro cutscene, don't bother
   !phxy
	JSL !Update_palette
   !plxy
	+
	RTS

; --- Quote58 ---
Ridely_ceres_push_fix:
	LDA !W_Move_type : AND #$00FF		;this just checks if you're backflipping and if so it doesn't try to push you against the wall
	CMP #$0019 : BEQ +
	LDA #$E90E : STA $0A58
	LDA #$E12E : STA $0A5A				;this part specifically activates the push
	+
	RTS

; --- Quote58 ---
Low_health_alert_check:
	LDA !C_O_Low_health : JSL Check_option_bit : BCC +
	LDA #$0002 : BRA ++
	+
	LDA #$0001
	++
	JSL $80914D
	RTS

; --- Quote58 ---
Check_charge_item_select:				;this is actually just fixing a bit of silly coding in the original game
	LDA !W_Charge : BEQ + : BMI +		;they didn't bother to check if you were actually charging when you hit item cancel
	STZ !W_Charge : JSR $BCBE			;which meant that if you weren't charging but hit item cancel, it would reset your palette anywhere that doesn't override the reset
	JSL !Update_palette					;for ex. heated rooms (maybe hyper beam too?), which don't use the standard palette routines. This just adds the check in so it doesn't do that
	+
	CLC
	RTS

; --- Quote58 ---
Quick_speed_boost:
	PHA
	LDA !C_O_Quick_booster : JSL Check_option_bit : BCC +
	PLA : CLC : ADC #$0200					;JSR + ;you could also write it this way if you need the extra 4 bytes at the cost of cycles
	RTS
	+
	PLA : CLC : ADC #$0100
	RTS

; --- Quote58 ---
Water_steps:
	LDA !W_Water_running : BNE +
	LDY #$8002 : LDA #$0100 : BRA ++
	+
	LDY #$0002 : LDA #$0300
	++
	STA $0AEC : STA $0AEE
	TYA : STA $0AD4
	LDA #$0003 : STA $0AD6
	RTS

; --- Quote58 ---
Collision_speed_check:
	LDA !W_Items_equip						;just making sure she has morph
	BIT !C_I_morph : BEQ +
	LDA !W_Auto_morph : BEQ +				;if automorph is active, preserve speed
	DEC !W_Auto_morph						;this routine gets called twice, this makes sure automorph is only active for those two times
	LDA #$0002 : BRA ++
	+
	JSL $91DE53
	STZ !W_H_speed : STZ !W_H_speed_sub
	STZ !W_H_momentum : STZ !W_H_momentum_sub
	LDA #$0000
	++
	STA !W_Momentum_preserv					;prevents clearing samus' speed when changing to morph (basically what mock ball does)
	RTS	

; --- Quote58 ---
Bomb_speed:
	;LDA !W_V_direction : BNE +				;uncomment this line if you want bombs to only be instant when on the ground
	LDA !W_Held : BIT !W_B_down : BEQ +		;check for holding down
	LDA #$0001 : BRA ++						;0 makes bombs never explode, 1 makes them explode instantly
	+
	LDA #$003C
	++
	RTS

; --- Quote58 (remember to comment this code later) ---
!Dir     = $00
!Dist    = $02
!NegAmt  = $04
!DirAddr = $00
!BlockTemp = $04
!XposAddr = $06
!YposAddr = $08
!PosAddr = $0A
!DistH   = #$0004							;distance from middle of samus to X boundries in V spark pose (+1 for right, +2 for left)
!DistV   = #$0012							;distance from middle of samus to Y boundries in H spark pose (+1 for down, +2 for up)

Move_spark:
.h
	LDA #$0000 : BRA .prep
.v
	LDA #$0001
.prep
	STA !Dir
.init
	PHA
	JSR .main								;run once, if run isn't held then this isn't redone
	PLA : STA !Dir
	LDA !W_Held : BIT !W_B_run : BEQ +
	JSR .main								;if run is held, simply run again because the position has just been updated
	+
	RTS
	
.main
   !phxy
   %check_option(!C_O_Spark_move)
	LDA !W_Spark_exit : BNE .end			;if we're exiting a spark, no need to do anything
	LDA !W_Held : AND #$0F00 : BEQ .end 	;if none of the directional buttons are being held, there's nothing to do
	XBA : TAX								;we now have the directional button inputs in X
	LDA !W_Y_pos : STA !YposAddr
	LDA !W_X_pos : STA !XposAddr
	
	LDA !Dir : BNE .updown
.leftright
	LDA #!W_X_pos : STA !DirAddr
	LDA #$0000+!XposAddr : STA !PosAddr
	LDA !DistH : STA !Dist
	TXA : AND #$0003 : BRA .move

.updown
	LDA #!W_Y_pos : STA !DirAddr
	LDA #$0000+!YposAddr : STA !PosAddr
	LDA !DistV : STA !Dist
	TXA : LSR #2 : AND #$0003
.move
	TAX : BEQ .end							;make sure at least one of the correct directions is being held
   %adc(!Dist)
    PHA
    TXA : BIT #$0001 : BNE .pos				;right/down = positive, left/up = negative
.neg
	PLA
	STA !NegAmt
	JSR Move_spark_check_neg : BNE .end
	LDA (!DirAddr) : DEC : STA (!DirAddr)	;if only I could do DEC (!DirAddr)
	BRA .end
.pos
	PLA
	JSR Move_spark_check_pos : BNE .end
	LDA (!DirAddr) : INC : STA (!DirAddr)
.end
   !plxy
	RTS

Move_spark_check:
.pos
   %adc("(!DirAddr)") : STA (!PosAddr)
	BRA .block
.neg
   %sub("(!DirAddr)", !NegAmt, "(!PosAddr)")
.block
	LDA !DirAddr : PHA
	LDX !XposAddr  : LDA !YposAddr
	JSL Find_block : AND #$F000 : STA !BlockTemp
	PLA : STA !DirAddr
	LDA !BlockTemp
	RTS

; --- Quote58 ---
Bomb_spread:
!Normal		 = "INC !W_Charge"				;if not using normal, if you charge right after laying a bomb, it will use normal speed anyway (essentially)
!Faster		 = "INC !W_Charge : INC !W_Charge"	;so if consistency is important with the bomb charge time, I suggest using normal
!SkipCharge  = "LDA !C_Full_charge : STA !W_Charge"

.zero_charge
	LDA !W_Bomb_charge : BEQ +
	JSR Bomb_spread_spawn_spread
	+
	STZ !W_Bomb_charge						;since you can now charge a bomb spread multiple times while morphed, it needs to be cleared when not holding fire
	LDA !W_Charge
	RTS

.main
	LDA !W_Items_equip : BIT !C_I_bombs		;must have bombs equipped
	BEQ .end
	LDA !W_Charge : CMP !C_Full_charge
	BMI .check_charge
	LDA !W_Bomb_counter : BNE .spawn_bomb	;if cooldown is a thing
	LDA !W_Bomb_charge : AND #$00C0
	CMP #$00C0 : BPL .end					;if fully charged, just wait until fire
	INC !W_Bomb_charge
.end
	CLC
	RTS
.check_charge
	LDA !W_Hyper_beam : BNE .hyper
	LDA !W_Beams_equip : AND #$F000 : BEQ .spawn_bomb
	LDA !W_Pressed : BIT !W_B_shoot : BNE .spawn_bomb
	LDA !W_Held : BIT !W_B_shoot : BEQ .spawn_bomb
   !Normal									;this is what determines how fast you charge in morph
	CLC
	RTS
.spawn_bomb
	JMP $C0E7
.hyper
	LDA !C_Full_charge+1 : STA !W_Charge
.spawn_spread
	LDA !W_Charge : CMP !C_Full_charge		;this makes sure you can only use the bomb spread once you have a full regular charge
	BPL +
	STZ !W_Bomb_charge
	CLC
	RTS
	+
	JSR $D849								;spawns the bomb spread
	JSL !Update_palette
	LDA #$0002 : JSL $80902B
	CLC
	RTS

; --- Quote58 ---
Bomb_throw:
	LDA $0C72 : CMP #$D8F7 : BNE +
	CLC : RTS
	+
	LDX #$000A
	-
	LDA #$8500 : STA !W_Proj_type,x : STZ !W_Proj_dir,x
	LDA #$D8F7 : STA $0C68,x
	JSL $9380A0								;setting up bomb projectiles??
	
	LDA !W_X_pos : STA !W_Proj_Xpos,x : STZ !W_Proj_Xpos_sub,x
	LDA !W_Y_pos : STA !W_Proj_Ypos,x : STZ !W_Proj_Ypos_sub,x
	TXA : SEC : SBC #$000A : TAY
	
	JSR .h : STA !W_Proj_Xspeed,x
	
	LDA $D8ED,y : STA $0C90,x				;timer for bombs?
	
	JSR .v
	EOR #$FFFF : INC A
	STA !W_Proj_Yspeed,x
	
	STA $0CA4,x								;????
	TYA : SEC : SBC #$001E : TAY
	LDA $D8CF,y : STA $0C7C,x				;I *think* this is to do with the bomb timer
	INX #2
	CPX #$0014 : BMI -						;it makes 5 bomb projectiles
	RTS

.v
	TYA : CLC : ADC #$001E : TAY
.h
	LDA !W_H_momentum_sub : BNE .moving
	LDA !W_Bomb_charge
	ASL #2 : XBA : AND #$0003
	CLC : ADC .speedh,y
	RTS

.moving
	LDA !W_Current_pose : AND #$00FF
	CMP #$0070 : BPL +						;morphball sometimes follows the standard of odd number pose = right, even = left
	CMP #$0031 : BEQ .right					;but sometimes it doesn't, so this checks all the morph poses and determines if it's right/left
	BIT #$0001 : BNE .left : BRA .right
	+
	BIT #$0001 : BEQ .left
.right
	LDA .speed_hright,y : BRA .check_speed
.left
	TYA : CMP #$001E : BMI +
	LDA .speed_hleft,y : BRA .check_speed
	+
	LDA .speed_hleft,y : ORA #$8000
.check_speed
	PHA
	LDA !W_Speed_counter : CMP #$0004 : BMI .end
	PLA : PHA
	AND #$0FFF : ASL : STA $02
	PLA : CLC : ADC $02 : PHA
.end
	PLA : STA $02
	LDA !W_Bomb_charge : ASL #2 : XBA : AND #$000F
	CLC : ADC $02
	RTS

.speedh 	  : dw $8100, $8080, $0000, $0080, $0100
.speed_hright : dw $0180, $0200, $0100, $0280, $0300
.speed_hleft  : dw $0300, $0280, $0100, $0180, $0200
.speedv 	  : dw $0000, $0001, $0002, $0001, $0000
.speed_vright : dw $0001, $0002, $0003, $0002, $0001
.speed_vleft  : dw $0001, $0002, $0003, $0002, $0001

; --- Scyzer (optimized/reduced by Quote58) ---
Ending_shinespark:
	LDA #$0001 : STA !W_Ending_spark
	LDA $0AAF
	RTS

Landing:									;determines whether to clear or keep samus' speed
	PHP
	REP #$30
	LDA #$0000 : STA !W_Force_echoes
	LDA !W_Ending_spark
	AND #$0000 : STA !W_Ending_spark : BNE .slow ;zeroes the flag while also checking if it was set (fucking clever scyzer)
	LDA !C_O_Keep_speed : JSL Check_option_bit : BCC .slow
	;add a call to Is_under_water if you want to make sure you can't get a speed boost under water by jumping from land with momentum preserve on
	SEP #$20
	LDA $0A24								;check previous pose
	CMP #$13 : BEQ .fast					;this comparison list saves 44 bytes over scyzers :3
	CMP #$14 : BEQ .fast
	CMP #$19 : BMI .slow
	CMP #$1D : BMI .fast
	CMP #$27 : BMI .slow
	CMP #$2B : BMI .fast
	CMP #$3D : BEQ .fast
	CMP #$3E : BEQ .fast
	CMP #$51 : BEQ .fast
	CMP #$52 : BEQ .fast
	CMP #$67 : BEQ .fast
	CMP #$68 : BEQ .fast
	CMP #$81 : BMI .slow
	CMP #$85 : BMI .fast
.slow
	REP #$20
	JMP Slow_down
.fast
	REP	#$20
	PLP
	RTS

Vertical_check:								;used by backflip
	STA $12
	STZ $14
	JSR $9440								;main routine for moving samus down
	RTL

; --- Quote58 (original by Black Falcon) ---
Morph_animation:
.is_morphed_moving						;carry is set only if samus is both morphed and moving. Otherwise the animation delay is set to 1
	PHA
	JSL Is_morphed : BCS +
	PLA : BRA ++
	+
	LDA !W_H_speed : BNE +
	LDA !W_H_speed_sub : BNE +
	LDA !W_H_momentum : BNE +
	LDA !W_H_momentum_sub : BNE +
	LDA !W_V_speed : BNE +
	LDA !W_V_speed_sub : BNE +
	PLA : LDA #$0001
	++
	STA !W_Animation_delay
	CLC
	RTS
	+
	PLA
	STA !W_Animation_delay
	SEC
	RTS
	+++
	PLA
	JSR .charge
	SEC
	RTS

.main
!Vert = #$0007							;range of vertical speed values is 0-7
!Hor  = #$0007							;range of horizontal speed values is 0-7
!Type = $02

	JSR .is_morphed_moving : BCS +
	RTS
	+
	LDA !W_V_direction : BNE .vertical  ;if she isn't in the air but is moving, she for sure uses the horizontal animation
	LDA !W_H_speed : BNE .horizontal	;if she isn't on the ground, but is moving horizontally, still use horizontal (for now)
	LDA !W_H_momentum : BNE .no_speed	;if she is moving but only at the 1-3 scale of momentum that morph uses, it has it's own branch
	RTS
	
.vertical
	LDA !W_V_speed : STA !Type
	LDA !Vert : BRA .end
	
.horizontal
	LDA !W_H_speed : INC #3 : STA !Type ;because 'speed' only starts after 'momentum', we can use the same max value and just start speed with the value of momentum
	LDA !Hor : BRA .end
	
.no_speed
	LDA !W_H_momentum : STA !Type
	LDA !Hor

.end
   %sbc(!Type) : BMI .clear
	STA !W_Animation_delay
	JSR .liquid							;liquid doubles frame delay in all cases
	JSR .rain							;if there's rain, then morph animation should be fast because it's slippery
	JSR .charge
	RTS
	
.clear
	STZ !W_Animation_delay
	RTS
	
.charge
	LDA !W_Bomb_charge : BEQ ++
	LSR #4 : STA $00
	LDA #$000B : SEC : SBC $00 : BEQ + : BPL +
	LDA #$0000
	+
	CMP !W_Animation_delay : BPL ++		;if the animation delay is currently lower than the proportional amount from charging, then don't change it
	STA !W_Animation_delay
	++
	RTS

.liquid
	LDA !W_FX3_type : AND #$00FF
	CMP #$0002 : BMI +
	CMP #$0007 : BPL +
	JSL Is_under_liquid_grav : BCC +	;carry set = under a liquid without gravity suit
   %asl(!W_Animation_delay, 1)
	+
	RTS
	
.rain
	LDA !W_FX3_type : AND #$00FF
	CMP #$000A : BNE +					;is the current fx3 type rain?
	LDA !W_V_direction : BNE +			;if she isn't on the ground it doesn't matter as much
	LDA #$0002 : STA !W_Animation_delay
	+
	RTS

; --- Quote58 ---
; this just adds a new stipulation to the standard 'can samus fire' routine
; which is that there can't be any live charged beam projectiles active
; this is so that uncharged/charged beams can each take the full 8 tiles in vram
Beam_check:
	LDA !W_Proj_counter : CMP #$0005 : BPL .no_fire
	ASL : TAX
	-
	LDA !W_Proj_type,x : BIT #$8000 : BEQ +
						 BIT #$0010 : BNE .no_fire
	+
	DEX #2 : BPL -
	LDA !W_Proj_cooldown : AND #$00FF : BNE .no_fire
	LDA #$0001 : STA !W_Proj_cooldown
	INC !W_Proj_counter
	LDA !W_Charged_beam : BEQ +
	STZ !W_Charged_beam
	JSL !Update_beam_gfx
	+
	SEC
	RTS

.no_fire
	CLC
	RTS

.charge
	JSR $AC39 : BCC +
	LDA !W_Charged_beam : BNE +
	INC !W_Charged_beam
	JSL !Update_beam_gfx
	SEC
	+
	RTS

; --- Quote58 (dynamic charge spark gfx concept by Black Falcon) ---
; beam gfx is now separated into uncharged and charged
; as well, the beam spark (or flare) loads it's own gfx indexed by beam type
; this has one cost, which is that you can't fire a regular shot if a charged shot
; is still on screen. The result is that each uncharged/charged beam can have a full 8
; tiles to draw from. It also means you can load different gfx for each beam combo
; both charged and uncharged, as well as a different flare for each.
Beam_gfx:
!BPower  = $9A80
!BIce    = $9C80
!BWave   = $9E80
!BPlasma = $A080
!BSpazer = $A280
!Power   = $9A00
!Ice     = $9C00
!Wave    = $9E00
!Plasma  = $A000
!Spazer  = $A200
!Hyper	 = $A400

	LDA .beam_source,y : PHA
	LDA !W_Charged_beam : BEQ .uncharged
	PLA : CLC : ADC #$0A00 : BRA +
.uncharged
	PLA
	+
	STA !src
	LDA #$0160 : STA !amt
	LDA #$6300 : BRA .transfer_gfx
.spark
	LDA !W_Hyper_beam : BEQ +
	LDA #!Hyper : BRA ++
	+
	LDA .spark_source,y
	++
	STA !src
	LDA #$0080 : STA !amt
	LDA #$6500
.transfer_gfx
	STA !dst
	LDA #$009A : STA !bnk
	JSL VRAM_DMA
	RTS

.beam_source
	dw !BPower							;0 power
	dw !BWave							;1 wave
	dw !BIce							;2 ice
	dw !BWave							;3 ice + wave
	dw !BSpazer							;4 spazer
	dw !BSpazer							;5 spazer + wave
	dw !BSpazer							;6 spazer + ice
	dw !BSpazer							;7 spazer + wave + ice
	dw !BPlasma							;8 plasma
	dw !BPlasma							;9 plasma + wave
	dw !BPlasma							;A plasma + ice
	dw !BPlasma							;B plasma + wave + ice

.spark_source
	dw !Power							;0 power
	dw !Wave							;1 wave
	dw !Ice								;2 ice
	dw !Ice								;3 ice + wave
	dw !Spazer							;4 spazer
	dw !Wave							;5 spazer + wave
	dw !Ice								;6 spazer + ice
	dw !Ice								;7 spazer + wave + ice
	dw !Plasma							;8 plasma
	dw !Wave							;9 plasma + wave
	dw !Ice								;A plasma + ice
	dw !Ice								;B plasma + wave + ice

; --- Scyzer (fixed by Quote58) ---
WJDamage:
	LDA !W_Items_equip
	BIT !C_I_screw : BEQ +					;if screw attack is not equipped, do not set contact damage
	JSL Is_under_liquid_grav : BCS +		;we need to account for samus being underwater and having screw attack but *not* having gravity suit on
	LDA #$0003 : STA !W_Contact_dmg			;since that shouldn't damage enemies
	+
	JMP $8FB3

; --- Quote58 ---
Super_missile_recoil:						;X = projectile index, A = current projectile
	PHA
   %check_option(!C_O_Super_recoil)
	CMP #$8200 : BNE .end					;8XXX = live projectile, X2XX = Super Missile
	LDA !W_V_direction : BEQ .end			;0 = standing on the ground
	LDA !W_Proj_dir,x
	CMP #$0004 : BEQ +						;down, facing left
	CMP #$0005 : BNE .end					;down, facing right
	+
	LDA #$0001 : STA !W_V_direction
	LDA #$0002 : STA !W_V_speed
.end
	PLA : STA !W_Proj_type,x
	RTS

; --- Quote58 ---
Add_half:									;only adds half the speed to her jump if she's jumping out of a spark
	PHA
	LDA !W_Spark_exit : BEQ .end
	PLA : LSR #2
	RTS
.end
	PLA
	RTS

.zero										;this is when samus has been given the proper vertical speed values
	LDA !W_Spark_exit : BNE +
	-
	STZ !W_Spark_exit
	LDA #$0001
	RTS
	+
	LDA !W_Held : BIT !W_B_run : BEQ -
	STZ !W_Spark_exit
	STZ !W_V_speed							;allows samus to fall instead of jumping downwards
	LDA #$0002
	RTS
	
.vertical
	JSR Add_half : STA !W_V_speed
	RTS
	
.vertical_sub
	JSR Add_half : STA !W_V_speed_sub
	RTS

; ::: Slyandro (edited for readability by Quote58) :::
; * rewrite this code later *

Ballspark:
.check
!WindupRight 	 = #$00C8					;windup facing right and facing left should logically be swapped, but as it is, left is right - 1, not right + 1 like the rest
!SpringRight	 = #$0079					;spring ball facing right. SpringLeft = SpringRight + 1
!Shinespark		 = #$001B					;movement type
!JumpHeight		 = #$0010					;# of pixels samus will jump up to start ballspark

	LDA !W_Ball_sparking 		: BNE .not_sparking
	LDA !W_Spark_timer 			: BEQ .not_sparking
	LDA !W_Held : CMP !W_B_jump : BNE .not_sparking
	JSR .clear_to_jump			: BCS .not_sparking

.begin_spark
	LDA !Shinespark : STA !W_Move_type
   %dec(!W_Y_pos, !JumpHeight)				;move samus up x pixels
	STA !W_Y_pos_prev						;save the new location to samus' previous y position (in case it causes her to scroll?)

	LDA !W_X_direction
	AND #$00FF : CMP #$0004 : BEQ +
	LDA !WindupRight-1 : BRA ++
	+
	LDA !WindupRight
	++
	STA !W_Current_pose : INC !W_Ball_sparking
	JSL $90CFFA								;begin sparking

.not_sparking
	LDA !W_Speed_counter
	AND #$FF00 : CMP #$0400 	: BNE .end	;if not speed boosting, don't start windup
	LDA !W_Held : BIT !W_B_down : BEQ .end	;if not holding down, don't start windup
	LDA !W_V_direction			: BNE .end	;just making sure samus is on the ground, otherwise shinespark exit lets you get a ballspark, which means you have a regular spark too

.start_windup
	LDA !C_Full_spark
	STA !W_Spark_timer : STA !W_Spark_pal
	LDA #$0001 : STA $0ACC : STZ $0ACE

.end
	LDA $0A23 : AND #$00FF
	RTL

.clear_to_jump
	LDA !W_X_pos : %adc(#$0004)				;is there a block up and to the right of samus?
	JSR .check_if_air : BEQ .air
	
	LDA !W_X_pos : %sbc(#$0004)				;is there a block up and to the left of samus?
	JSR .check_if_air : BEQ .air
.solid
	SEC : RTS
.air
	CLC : RTS
.check_if_air
	TAX
	LDA !W_Y_pos : %sbc(!JumpHeight)
	JSL Find_block : AND #$F000				;1000 = solid, 0000 = air
	RTS

.restore_left
	LDA !W_Ball_sparking : BEQ +
	LDA !SpringRight+1 : RTS
	+
	LDA #$0002 : RTS

.restore_right
	LDA !W_Ball_sparking : BEQ +
	LDA !SpringRight : RTS
	+
	LDA #$0001 : RTS
	
.restore_height
	ADC !W_Y_pos : JSR .adjust_height
	RTS

.restore_height_prev
	ADC !W_Y_pos_prev : JSR .adjust_height
	STZ !W_Ball_sparking
	RTS

.adjust_height
	PHA
	LDA !W_Ball_sparking : BEQ +
	PLA : %sbc(#$000C) : PHA
	+
	PLA
	RTS

Ballspark_Animation:							;these routines are all for faking the ballspark pose
.skip
	JSR .fake : ASL : RTL

.fake
	LDA !W_Ball_sparking : BEQ +
	LDA !SpringRight : RTS
	+
	LDA !W_Current_pose : RTS

.fake_echo
	PHA
	LDA !W_Ball_sparking : BEQ +
	PLA : LDA #$0743
	RTS
	+
	PLA : ADC !W_Animation_frame
	RTS
	
.echo_height
	PHA
	LDA !W_Ball_sparking : BEQ +
	PLA : %sbc(#$0007) : PHA
	+
	PLA : STA $0AB8,x
	RTS

.echo_height_final
	PHA
	LDA !W_Ball_sparking : BEQ +
	PLA : %adc(#$0010) : PHA : SEC
	+
	PLA : SBC !W_Layer1_Y
	RTS

print "End of free space (90FFFF): ", pc


























