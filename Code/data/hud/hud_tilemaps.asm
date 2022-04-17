;'00'
.empty_2_digit_counter
	dw $0201
	dw $2C09, $2C09

;'000'
.empty_3_digit_counter
	dw $0301
	dw $2C09, $2C09, $2C09

;'ENERGY'
.energy
	dw $0401
	dw $2C30, $2C31, $2C32, $2C33

;'TIME'
.game_time
	dw $0301
	dw $2C34, $2C35, $2C36

;'ITEM'
.item_percentage
	dw $0301
	dw $2C38, $2C39, $2C3A

;side part of minimap
.minimap_side
	dw $0103
	dw $2C1E
	dw $2C1E
	dw $2C1E

;.-|#|-.
.magic_display
	dw $0701
	dw $348A, $348B, $348C, $348D, $748C, $748B, $748A

;icons for missiles
.missiles_icon
	dw $0302
	dw $3490, $3491, $7490
	dw $34A0, $34A1, $74A0
.missiles_icon_3x1
	dw $0301
	dw $3496, $3497, $3498
.missiles_icon_2x1
	dw $0201
	dw $34A6, $34A7
.missiles_icon_2x2
	dw $0202
	dw $3490, $3491
	dw $34A0, $34A1

;icons for supers
.supers_icon
	dw $0202
	dw $3492, $7492
	dw $34A2, $74A2
.supers_icon_3x1
	dw $0301
	dw $3499, $349A, $349B
.supers_icon_2x1
	dw $0201
	dw $34A8, $34A9

;icons for powers
.powers_icon
	dw $0202
	dw $3493, $7493
	dw $34A3, $74A3
.powers_icon_3x1
	dw $0301
	dw $349C, $349D, $349E
.powers_icon_2x1
	dw $0201
	dw $34AA, $34AB
.powers_icon_2x2
	dw $0202
	dw $3494, $3495
	dw $34A4, $34A5

;icons for grapple
.grapple_icon
	dw $0202
	dw $3494, $7494
	dw $34A4, $74A4
.grapple_icon_2x1
	dw $0201
	dw $34AC, $34AD

;icons for xray
.xray_icon
	dw $0202
	dw $3495, $7495
	dw $34A5, $74A5
.xray_icon_2x1
	dw $0201
	dw $34AE, $34AF

;static part of the input display
.input_display
	dw $0202
	dw $000E, $000E
	dw $000E, $147A

;icon for reserves
.reserves
	dw $0203
;version for empty
	dw $2C37, $2C38
	dw $2C47, $2C48
	dw $AC37, $AC38
;version for full
	dw $0203
	dw $3C37, $3C38
	dw $3C47, $3C48
	dw $BC37, $BC38

.reserves_small
	dw $0202
;version for empty
	dw $2C39, $2C3A
	dw $2C49, $2C4A
;version for full
	dw $0202
	dw $3C39, $3C3A
	dw $3C49, $3C4A

;empty charge bar
.charge_bar
	dw $0801
	dw $349F, $3488, $3488, $3488, $3488, $3488, $3488, $3489

;empty health bar	
.health_bar
	dw $0801
	dw $2C88, $2C88, $2C88, $2C88, $2C88, $2C88, $2C88, $2C89

.null
	dw $0000