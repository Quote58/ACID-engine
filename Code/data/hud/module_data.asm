.health
	dw $0000, $0000
	dw !C_H_Health, Hud_method_health

.health_big
	dw $0000, $0000
	dw !C_H_Health, Hud_method_health_big

.health_pro
	dw $0000, $0000
	dw !C_H_Health
	dw Hud_method_draw_counter_4, $2C, !W_Health

.health_bar
	dw $0000, Hud_tilemaps_health_bar
	dw !C_H_Health, Hud_method_draw_health_bar

.etanks
	dw $0000, $0000
	dw !C_H_Health, Hud_method_etanks
.etanks_small
	dw $0000, $0000
	dw !C_H_Health, Hud_method_etanks_small
.etanks_dynamic
	dw $0000, $0000
	dw !C_H_Health, Hud_method_etanks_dynamic

.charge_bar
	dw Hud_condition_charge, Hud_tilemaps_charge_bar
	dw !C_H_Charge, Hud_method_draw_charge_bar

.mini_map
	dw $0000, $0000
	dw !C_H_Minimap, Hud_method_draw_mini_map, $0503

.mini_map_4x3
	dw $0000, $0000
	dw !C_H_Minimap, Hud_method_draw_mini_map, $0403

.mini_map_3x3
	dw $0000, $0000
	dw !C_H_Minimap, Hud_method_draw_mini_map, $0303

.reserves
	dw Hud_condition_reserves, Hud_tilemaps_reserves
	dw !C_H_Reserves, Hud_method_draw_reserves

.reserves_small
	dw Hud_condition_reserves, Hud_tilemaps_reserves_small
	dw !C_H_Reserves, Hud_method_draw_reserves_small

.input_display
	dw $0000, Hud_tilemaps_input_display
	dw !C_H_Input, Hud_method_draw_input_display

.game_time
	dw $0000, $0000
	dw $0000, Hud_method_draw_game_time

.item_percentage
	dw $0000, $0000
	dw $0000, Hud_method_draw_item_percentage

.magic_display
	dw Hud_condition_speed, Hud_tilemaps_magic_display
	dw !C_H_Magic+!C_H_Spark, Hud_method_draw_magic_display

.missiles_counter
	dw Hud_condition_missiles, Hud_tilemaps_empty_3_digit_counter
	dw !C_H_Missiles
	dw Hud_method_draw_counter_3, $2C, !W_Missiles
.missiles_counter_max
	dw Hud_condition_missiles, $0000
	dw !C_H_Missiles
	dw Hud_method_draw_counter_3, $14, !W_Missiles_max

.supers_counter
	dw Hud_condition_supers, Hud_tilemaps_empty_2_digit_counter
	dw !C_H_Supers
	dw Hud_method_draw_counter_2, $2C, !W_Supers
.supers_counter_3
	dw Hud_condition_supers, Hud_tilemaps_empty_3_digit_counter
	dw !C_H_Supers
	dw Hud_method_draw_counter_3, $2C, !W_Supers
.supers_counter_max
	dw Hud_condition_supers, $0000
	dw !C_H_Supers
	dw Hud_method_draw_counter_3, $14, !W_Supers_max

.powers_counter
	dw Hud_condition_powers, Hud_tilemaps_empty_2_digit_counter
	dw !C_H_Powers
	dw Hud_method_draw_counter_2, $2C, !W_Powers
.powers_counter_3
	dw Hud_condition_powers, Hud_tilemaps_empty_3_digit_counter
	dw !C_H_Powers
	dw Hud_method_draw_counter_3, $2C, !W_Powers
.powers_counter_max
	dw Hud_condition_powers, $0000
	dw !C_H_Powers
	dw Hud_method_draw_counter_3, $14, !W_Powers_max

.missiles_icon
	dw Hud_condition_missiles, Hud_tilemaps_missiles_icon
	dw !C_H_Select, Hud_method_toggle, $01
.missiles_icon_3x1
	dw Hud_condition_missiles, Hud_tilemaps_missiles_icon_3x1
	dw !C_H_Select, Hud_method_toggle, $01
.missiles_icon_2x1
	dw Hud_condition_missiles, Hud_tilemaps_missiles_icon_2x1
	dw !C_H_Select, Hud_method_toggle, $01
.missiles_icon_2x2
	dw Hud_condition_missiles, Hud_tilemaps_missiles_icon_2x2
	dw !C_H_Select, Hud_method_toggle, $01

.supers_icon
	dw Hud_condition_supers, Hud_tilemaps_supers_icon
	dw !C_H_Select, Hud_method_toggle, $02
.supers_icon_2x1
	dw Hud_condition_supers, Hud_tilemaps_supers_icon_2x1
	dw !C_H_Select, Hud_method_toggle, $02
.supers_icon_3x1
	dw Hud_condition_supers, Hud_tilemaps_supers_icon_3x1
	dw !C_H_Select, Hud_method_toggle, $02

.powers_icon
	dw Hud_condition_powers, Hud_tilemaps_powers_icon
	dw !C_H_Select, Hud_method_toggle, $03
.powers_icon_2x1
	dw Hud_condition_powers, Hud_tilemaps_powers_icon_2x1
	dw !C_H_Select, Hud_method_toggle, $03
.powers_icon_3x1
	dw Hud_condition_powers, Hud_tilemaps_powers_icon_3x1
	dw !C_H_Select, Hud_method_toggle, $03
.powers_icon_2x2
	dw Hud_condition_powers, Hud_tilemaps_powers_icon_2x2
	dw !C_H_Select, Hud_method_toggle, $03

.grapple_icon
	dw Hud_condition_grapple, Hud_tilemaps_grapple_icon
	dw !C_H_Select, Hud_method_toggle, $04
.grapple_icon_2x1
	dw Hud_condition_grapple, Hud_tilemaps_grapple_icon_2x1
	dw !C_H_Select, Hud_method_toggle, $04

.xray_icon
	dw Hud_condition_xray, Hud_tilemaps_xray_icon
	dw !C_H_Select, Hud_method_toggle, $05
.xray_icon_2x1
	dw Hud_condition_xray, Hud_tilemaps_xray_icon_2x1
	dw !C_H_Select, Hud_method_toggle, $05