!C_Item_total		= #$0069			;total number of items in the game (this includes all ammo and upgrades) [64h, 100d]

!C_Full_charge  	= #$002C			;3A is more accurate but the game uses 3C which gives a couple of frames of leeway

!C_O_Auto_morph		= #$0000			;the bit value of options are single bytes because they are stored in the extra event bit array and 
!C_O_Beam_flicker	= #$0001
!C_O_Beam_trails	= #$0002
!C_O_Morph_flash	= #$0003
!C_O_Spark_exit		= #$0004
!C_O_Low_health	    = #$0005
!C_O_Screen_shake	= #$0006
!C_O_Keep_speed		= #$0007
!C_O_Quick_booster	= #$0008
!C_O_Auto_run		= #$0009
!C_O_Soundfx_toggle	= #$000A
!C_O_Backflip		= #$000B
!C_O_Respin			= #$000C
!C_O_Quickmorph		= #$000D
!C_O_Music_toggle	= #$000E
!C_O_Cannon_tint	= #$000F
!C_O_Time_attack	= #$0010			;this shows or hides the time, item percentage, and item tanks on the map screen
!C_O_Moon_walk		= #$0011
!C_O_Upspin			= #$0012
!C_O_Disable_map	= #$0013
!C_O_Speed_echoes	= #$0014
!C_O_Flip_echoes	= #$0015
!C_O_Auto_save		= #$0016
!C_O_Clear_msg		= #$0017
!C_O_Screw_glow		= #$0018
!C_O_Spin_complex	= #$0019			;handles both the faster spin animation and the speed change over time when spinning routine
!C_E_100msg			= #$0017			;C_E = event bit


!W_Easter_egg_1		= $7FFA04			;1st address of wram for conditions for easter eggs
!W_Easter_egg_2		= $7FFA06			;2nd address of wram for conditions for easter eggs
!W_Debug_ram		= $7FFA0A			;flag used to initialize things for quickmet

!W_Bomb_timer		= $7FFE06			;0 = slow, 1 = normal, 2 = fast
!W_Bomb_mode		= $7FFE08			;0 = spread, 1 = explosion thing
!W_Collected_tanks	= $7FFE0E			;FE0C - FE20 single bytes indexed by region * type of tank, ie. FE08 - FE0B are Crateria Energy, Missile, Super, Power, reserve
!W_Item_dots		= $7FFE2E			;FE2C - (FE22+total_items*2) = currently FEFE
!W_Practice_mode	= $7FFE30			;1 = practice mode active, anything else = not active
;!W_???				= $7FFE32

;!W_Practice_hud		= $7FFF00			;the module data for the practice hud, saved into sram

!BitVaria   = #$0000					;bit values of samus' equipment for use in the pause screen
!BitSpring  = #$0001
!BitMorph   = #$0002
!BitScrew   = #$0003
!BitDash    = #$0004
!BitGravity = #$0005
!BitHijump  = #$0008
!BitSpace   = #$0009
!BitBombs   = #$000C
!BitSpeed   = #$000D
!BitGrapple = #$000E
!BitXray    = #$000F
!BitWave    = #$0020
!BitIce     = #$0021
!BitSpazer  = #$0022
!BitPlasma  = #$0023
!BitCharge  = #$002C







