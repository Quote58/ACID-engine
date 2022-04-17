.default_cycle : dw .default_map, .default_samus, .default_options
.hud_cycle 	   : dw .hud_normal, .hud_pro, .hud_rando, .hud_speed, .hud_prime, .hud_practice, .hud_classic, .hud_retro
.item_cycle	   : dw .item_short, .item_fanfare

.item_short		 : dw $2E48, $2E49, $2E4A, $2E4B					;[short]
.item_fanfare	 : dw $2E44, $2E45, $2E46, $2E47					;[fanfare]
.default_options : dw $2E04, $2E05, $2E06, $2E07					;[option]
.default_map 	 : dw $2E08, $2E09, $2E0A, $2E0B					;[ map ]
.default_samus   : dw $2E0C, $2E0D, $2E0E, $2E0F					;[samus]
.hud_normal		 : dw $2E14, $2E15, $2E16, $2E17					;[normal]
.hud_pro		 : dw $2E20, $2E21, $2E22, $2E23					;[ pro ]
.hud_speed		 : dw $2E18, $2E19, $2E1A, $2E1B					;[speed]
.hud_rando		 : dw $2E1C, $2E1D, $2E1E, $2E1F					;[rando]
.hud_practice	 : dw $2E24, $2E25, $2E26, $2E27					;[practice]
.hud_prime		 : dw $2E38, $2E39, $2E3A, $2E3B					;[prime]
.hud_classic	 : dw $2E28, $2E29, $2E2A, $2E2B					;[classic]
.hud_retro		 : dw $2E2C, $2E2D, $2E2E, $2E2F					;[retro]
.locked			 : dw $2D00, $2D00, $2D00							;? ? ?
.on			 	 : dw $28E3, $28E4, $28E5							;[ on ]
.off		  	 : dw $28E0, $28E1, $28E2							;[ off]
.auto_morph   	 : dw $2D10, $2D11, $2D12, $2D13, $2D14, $2D15, $2D16, $28E6, $28E6
.beam_flicker 	 : dw $2D17, $2D18, $2D19, $2D1A, $2D1B, $2D1C, $2D1D, $2D1E, $28E6
.beam_trails  	 : dw $2D17, $2D18, $2D19, $2D20, $2D21, $2D22, $2D23, $28E6, $28E6
.morph_flash  	 : dw $2D13, $2D14, $2D15, $2D16, $2D1A, $2D24, $2D25, $28E6, $28E6
.screen_shake	 : dw $2D37, $2D38, $2D39, $2D3A, $2D3B, $2D3C, $2D3D, $2D3E, $28E6
.moon_walk	 	 : dw $2D26, $2D27, $2D28, $2D29, $2D2A, $2D2B, $28E6, $28E6, $28E6
.shinespark_exit : dw $2D40, $2D41, $2D42, $2D43, $2D44, $2D45, $2D46, $2D47, $2D48
.low_health		 : dw $2D50, $2D51, $2D52, $2D53, $2D54, $2D55, $2D56, $2D57, $2D58
.keep_speed		 : dw $2D49, $2D4A, $2D4B, $2D4C, $2D4D, $2D4E, $2D4F, $28E6, $28E6
.quick_booster	 : dw $2D60, $2D61, $2D62, $2D63, $2D64, $2D65, $2D66, $2D67, $28E6
.auto_run		 : dw $2D10, $2D11, $2D12, $2D2C, $2D2D, $28E6, $28E6, $28E6, $28E6
.backflip		 : dw $2D59, $2D5A, $2D5B, $2D5C, $2D5D, $28E6, $28E6, $28E6, $28E6
.respin			 : dw $2D70, $2D71, $2D72, $2D73, $2D74, $28E6, $28E6, $28E6, $28E6
.quickmorph		 : dw $2D60, $2D61, $2D62, $2D68, $2D69, $2D6A, $2D6B, $28E6, $28E6
.cannon_tint	 : dw $2D75, $2D76, $2D77, $2D78, $2D79, $2D7A, $2D7B, $28E6, $28E6
.upspin			 : dw $2D2E, $2D2F, $2D72, $2D73, $2D74, $28E6, $28E6, $28E6, $28E6
.disable_minimap : dw $2D01, $2D02, $2D03, $2D04, $2D05, $2D06, $2D07, $2D08, $2D09
.speed_echoes	 : dw $2D4C, $2D4D, $2D4E, $2D4F, $2D6C, $2D6D, $2D6E, $2D6F, $28E6
.flip_echoes	 : dw $2D59, $2D5A, $2D5B, $2D5C, $2D5D, $2D6C, $2D6D, $2D6E, $2D6F
.auto_save		 : dw $2D10, $2D11, $2D12, $2D7C, $2D7D, $2D7E, $28E6, $28E6, $28E6
.time_attack	 : dw $2D30, $2D31, $2D32, $2D33, $2D34, $2D35, $2D36, $28E6, $28E6
.clear_msg		 : dw $2D88, $2D89, $2D8A, $2D8B, $2D8C, $2D8D, $2D8E, $2D8F, $28E6
.screw_glow		 : dw $2D98, $2D99, $2D9A, $2D9B, $2D9C, $28E6, $28E6, $28E6, $28E6
.spin_complex	 : dw $2D98, $2D01, $2D02, $2D03, $2D04, $2D05, $2D06, $28E6, $28E6