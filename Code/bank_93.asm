lorom

org $938268 : JSR Beam_flicker : BCC $39
org $9382F7 : JSR Beam_trails : NOP
org $938021 : LDA Projectile_uncharged_beam,y		;uncharged beam
org $93802C : LDA Projectile_charged_beam,y			;charge beam
org $938038 : LDA Projectile_misc,y					;missile/super/bomb
org $9380AE : LDA Projectile_misc,y					;power bomb
org $93817E : LDA Projectile_spark,y				;shinespark and spazer sba
org $9381B2 : LDA Projectile_sba,y					;wave and plasma sba but *not* ice
org $93807F : LDA Projectile_super,y				;super missile link thing
org $9380E9 : LDA.w #Misc_beam_explosion
org $93811F : LDA.w #Misc_super_missile_explosion
org $938117 : LDA.w #Misc_missile_explosion
org $938154 : LDA.w #Misc_bomb_explosion

; Samus related projectiles are handled in four levels
; Main pointer table (Projectile:)
; Directional table of animation pointers (Beam_power:)
; Animation pointers (Beam_power_up:)
; Sprite data (Beam_power_up_s:)

org $9383C1
; --- Quote58 ---
; Main Samus related projectile pointer tables
Projectile:
.no_sprite
	dw $0000

.uncharged_beam
	dw Beam_power
	dw Beam_wave
	dw Beam_ice
	dw Beam_wave_ice
	dw Beam_spazer, Beam_spazer_wave, Beam_spazer_ice, Beam_spazer_wave_ice
	dw Beam_plasma, Beam_plasma_wave, Beam_plasma_ice, Beam_plasma_wave_ice

.charged_beam
	dw Beam_c_power
	dw Beam_c_wave
	dw Beam_c_ice
	dw Beam_c_wave_ice
	dw Beam_c_spazer, Beam_c_spazer_wave, Beam_c_spazer_ice, Beam_c_spazer_wave_ice
	dw Beam_c_plasma, Beam_c_plasma_wave, Beam_c_plasma_ice, Beam_c_plasma_wave_ice

.misc
	dw Misc_missile, Misc_missile
	dw Misc_super
	dw Misc_power
	dw Misc_missile
	dw Misc_bomb
	dw Misc_missile
	dw Misc_beam_explosion, Misc_super_missile_explosion

.sba
	dw $0000
	dw SBA_wave
	dw $0000, $0000
	dw SBA_spazer, SBA_spazer
	dw $0000, $0000
	dw SBA_plasma, SBA_plasma
	dw $0000, $0000

.spark
	dw $0000, $0000
	dw SBA_spazer_end
	dw $0000
	dw SBA_spazer_end
	dw $0000, $0000
	dw Misc_spark_echo

.super
	dw $0000, $0000
	dw Misc_super_link

; ::: Projectile Sprite Objects :::
; the structure is as follows:
;
; - Directional table -
; Name:
; dw damage
; dw up
; dw up_right, right, down_right
; dw down, down
; dw down_left, left, up_left
; dw up
;
; - Animation table -
; Name:
; dw delay, sprite_pointer, hitbox, frame
; Loop:
; dw delay, sprite_pointer, hitbox, frame
; dw $8239, Loop

; ::: Regular Beams :::
Beam:
.power 			 		: %proj_dir("power",	  	  	  $0014)
.wave    		 		: %proj_dir("wave",	  	  	  	  $0032)
.ice			 		: %proj_dir("ice",	  	  	  	  $001E)
.wave_ice		 		: %proj_dir("wave",	  	  	  	  $003C)
.spazer			 		: %proj_dir("spazer",	  	  	  $0028)
.spazer_wave	 		: %proj_dir("spazer_wave",	  	  $0046)
.spazer_ice		 		: %proj_dir("spazer",	  	  	  $003C)
.spazer_wave_ice 		: %proj_dir("spazer_wave",	  	  $0064)
.plasma			 		: %proj_dir("plasma",	  	  	  $0096)
.plasma_wave	 		: %proj_dir("plasma_wave",	  	  $00FA)
.plasma_ice		 		: %proj_dir("plasma",	  	  	  $00C8)
.plasma_wave_ice		: %proj_dir("plasma_wave",	  	  $012C)

incsrc data/projectiles/vanilla/beams/power.asm
incsrc data/projectiles/vanilla/beams/wave.asm
incsrc data/projectiles/vanilla/beams/ice.asm
incsrc data/projectiles/vanilla/beams/spazer.asm
incsrc data/projectiles/vanilla/beams/spazer_wave.asm
incsrc data/projectiles/vanilla/beams/plasma.asm
incsrc data/projectiles/vanilla/beams/plasma_wave.asm

; ::: Charged Beams :::
Beam_c:
.power 			 		: %proj_dir("power",       		  $003C)
.wave    		 		: %proj_dir("wave",        		  $0096)
.ice			 		: %proj_dir("ice",         		  $005A)
.wave_ice		 		: %proj_dir("wave",        		  $00B4)
.spazer			 		: %proj_dir("spazer",      		  $0078)
.spazer_wave	 		: %proj_dir("spazer_wave", 		  $00D2)
.spazer_ice		 		: %proj_dir("spazer",      		  $00B4)
.spazer_wave_ice 		: %proj_dir("spazer_wave", 		  $012C)
.plasma			 		: %proj_dir("plasma",      		  $01C2)
.plasma_wave	 		: %proj_dir("plasma_wave", 		  $02EE)
.plasma_ice		 		: %proj_dir("plasma",      		  $0258)
.plasma_wave_ice 		: %proj_dir("plasma_wave", 		  $0384)

incsrc data/projectiles/vanilla/beams/charged_power.asm
incsrc data/projectiles/vanilla/beams/charged_wave.asm
incsrc data/projectiles/vanilla/beams/charged_ice.asm
incsrc data/projectiles/vanilla/beams/charged_spazer.asm
incsrc data/projectiles/vanilla/beams/charged_spazer_wave.asm
incsrc data/projectiles/vanilla/beams/charged_plasma.asm
incsrc data/projectiles/vanilla/beams/charged_plasma_wave.asm

; ::: Missile/Super/Power + Spark echo :::
Misc:
.missile		 : %proj_dir("missile", 	  $0064)
.super			 : %proj_dir("super_missile", $012C)
.super_link		 : dw $012C, .super_link_all
.bomb	 		 : dw $001E, .bomb_slow
.power			 : dw $00C8, .power_bomb_slow
.spark_echo 	 : %proj_dir("spark_echo", 	  $1000)

.super_link_all
	dw $000F,Projectile_no_sprite,$0808,$0000
	dw $8239,.super_link_all

.spark_echo_up
.spark_echo_up_right
.spark_echo_right
.spark_echo_down_right
.spark_echo_down
.spark_echo_down_left
.spark_echo_left
.spark_echo_up_left
	dw $0002,Projectile_no_sprite,$2020,$0000
	dw $0002,Projectile_no_sprite,$2020,$0001
	dw $0002,Projectile_no_sprite,$2020,$0002
	dw $0002,Projectile_no_sprite,$2020,$0003
	dw $8239,.spark_echo

incsrc data/projectiles/vanilla/missile.asm
incsrc data/projectiles/vanilla/super_missile.asm
incsrc data/projectiles/vanilla/bomb.asm
incsrc data/projectiles/vanilla/power_bomb.asm
incsrc data/projectiles/vanilla/beam_explosion.asm
incsrc data/projectiles/vanilla/missile_explosion.asm
incsrc data/projectiles/vanilla/super_missile_explosion.asm
incsrc data/projectiles/vanilla/bomb_explosion.asm

; ::: Special Beam Attacks :::
SBA:
.spazer_end : %proj_dir("spazer", $012C)
.spazer		: dw $012C, Beam_spazer_up
.wave		: dw $012C, .wave_all
.plasma		: dw $012C, .plasma_all

.spazer_up
.spazer_up_right
.spazer_right
.spazer_down_right
.spazer_down
.spazer_down_left
.spazer_left
.spazer_up_left
	dw $0002,Projectile_no_sprite,$0804,$0000
	dw $0002,Projectile_no_sprite,$080C,$0001
.spazer_up_l
	dw $0002,Projectile_no_sprite,$0814,$0002
	dw $8239,.spazer_up_l

.wave_all
	dw $0008,Beam_c_wave_s01,$0404,$0000
	dw $0008,Beam_c_wave_s02,$0404,$0001
	dw $8239,.wave_all

.plasma_all
	dw $0002,Misc_bomb_explosion_s00,$0808,$0000
	dw $0002,Misc_bomb_explosion_s01,$0C0C,$0000
	dw $0002,Misc_bomb_explosion_s02,$1010,$0000
	dw $0002,Misc_bomb_explosion_s03,$1010,$0000
	dw $0002,Misc_bomb_explosion_s04,$1010,$0000
	dw $8239,.plasma_all

; ::: Charge beam flare + sparks :::
Flare:
.index_right : dw $0000, $001E, $0024
.index_left  : dw $0000, $002A, $0030
.type
	dw .charge_s00, .charge_s01, .charge_s00, .charge_s01, .charge_s00, .charge_s01, .charge_s00, .charge_s01
	dw .charge_s02, .charge_s01, .charge_s02, .charge_s01, .charge_s02, .charge_s01, .charge_s02, .charge_s01
	dw .charge_s02, .charge_s03, .charge_s02, .charge_s03, .charge_s02, .charge_s03, .charge_s02
	dw .charge_s03, .charge_s02, .charge_s03, .charge_s02, .charge_s03, .charge_s02, .charge_s03
	dw .sparks_s04, .sparks_s05, .sparks_s06, .sparks_s07, .sparks_s08, .sparks_s09
	dw .sparks_s10, .sparks_s11, .sparks_s12, .sparks_s13, .sparks_s14, .sparks_s15
	dw .sparks_s16, .sparks_s17, .sparks_s18, .sparks_s19, .sparks_s20, .sparks_s21
	dw .sparks_s22, .sparks_s23, .sparks_s24, .sparks_s25, .sparks_s26, .sparks_s27
	dw .charge_s00, .charge_s02
	dw .charge_s00, .charge_s02
	dw .charge_s00, .charge_s02
	dw .charge_s00, .charge_s02
	dw .charge_s00, .charge_s02
	dw .charge_s00, .charge_s02

incsrc data/projectiles/vanilla/charge_flare.asm
incsrc data/projectiles/vanilla/charge_sparks.asm

; ::: Free space for anything else until the end of the bank :::
; --- Black Falcon (modified by Quote58) ---
Beam_trails:
   %check_option(!C_O_Beam_trails)
	JSL $90B6A9				;swaps the gfx and draws the trail
.end
	RTS

; --- Black Falcon (modified by Quote58) ---
Beam_flicker:
	PHA
   %check_option(!C_O_Beam_flicker)
	PLA : BIT #$0F10 : BNE +
	SEC
	RTS
.end
	PLA
	+
	CLC
	RTS

print "End of free space (93FFFF): ", pc




























