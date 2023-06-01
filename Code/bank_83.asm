lorom

org $83AD66
; free space in bank $83

; --- Quote58 ---
; there's so much free space here we're just going to go ahead and dedicate it to extra tilemaps needed elsewhere
; all the tilemaps for the individual subscreens goes here
Map_init_tilemap:
.buttons
	incsrc data/subscreens/map_screen/map_buttons.asm

Equip_init_tilemap:
	incsrc data/subscreens/equip_screen/equip_tilemap.asm
.buttons
	incsrc data/subscreens/equip_screen/equip_buttons.asm

Options_init_tilemap:
	incsrc data/subscreens/options_screen/options_tilemap.asm
.buttons
	incsrc data/subscreens/options_screen/options_buttons.asm

Button_config_init_tilemap:
	incsrc data/subscreens/button_config/button_config_tilemap.asm

Unpausing_tilemap:
.buttons
	incsrc data/subscreens/unpausing_buttons.asm

; the equipment screen samus model tilemaps and modifiers are stored here as well
Equip_samus_tilemaps:
	incsrc data/subscreens/equip_screen/equip_samus.asm

Equip_samus_modifier:
	incsrc data/subscreens/equip_screen/equip_samus_modifiers.asm

; these credit sheets are each $500 bytes, so they take up space really quickly being uncompressed
Credit_sheet_data:
.special_thanks :      incsrc data/credit_sheets/credit_sheet_ST.asm
.programming_credits : incsrc data/credit_sheets/credit_sheet_PC.asm
.tester_credits :      incsrc data/credit_sheets/credit_sheet_TC.asm

; these tilemaps are to avoid having 4 of the same tile in misc sprite vram at all times
; but they do take up a lot of space, so I'm leaving them here
Frame_4_gate:   dw $0010 : %oam_h_square(00,00,be,2a) : %oam_h_square(f0,00,be,2a) : %oam_h_square(e0,00,be,2a) : %oam_h_square(d0,00,be,2a)
Frame_3_gate:   dw $000C : %oam_h_square(00,00,be,2a) : %oam_h_square(f0,00,be,2a) : %oam_h_square(e0,00,be,2a)
Frame_2_gate:   dw $0008 : %oam_h_square(00,00,be,2a) : %oam_h_square(f0,00,be,2a)
Frame_1_gate:   dw $0004 : %oam_h_square(00,00,be,2a)

; there are a ton of extra sprites used on the pause screen, so the tilemaps are stored here
Pause_spritemaps_extra:
incsrc data/subscreens/pause_sprites_extra.asm

print "End of free space (83FFFF): ", pc