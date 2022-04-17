.missile_up
	dw $000F,.missile_s00,$0404,$0000
	dw $8239,.missile_up
.missile_up_right
	dw $000F,.missile_s01,$0404,$0000
	dw $8239,.missile_up_right
.missile_right
	dw $000F,.missile_s02,$0404,$0000
	dw $8239,.missile_right
.missile_down_right
	dw $000F,.missile_s03,$0404,$0000
	dw $8239,.missile_down_right
.missile_down
	dw $000F,.missile_s04,$0404,$0000
	dw $8239,.missile_down
.missile_down_left
	dw $000F,.missile_s05,$0404,$0000
	dw $8239,.missile_down_left
.missile_left
	dw $000F,.missile_s06,$0404,$0000
	dw $8239,.missile_left
.missile_up_left
	dw $000F,.missile_s07,$0404,$0000
	dw $8239,.missile_up_left

.missile_s00
	dw $0002
	db $FC,$01,$F7,$59,$2A
	db $FC,$01,$FF,$5A,$2A
.missile_s01
	dw $0003
	db $00,$00,$F5,$56,$6A
	db $F8,$01,$FD,$58,$6A
	db $00,$00,$FD,$57,$6A
.missile_s02
	dw $0002
	db $F9,$01,$FC,$55,$6A
	db $01,$00,$FC,$54,$6A
.missile_s03
	dw $0003
	db $00,$00,$03,$56,$EA
	db $F8,$01,$FB,$58,$EA
	db $00,$00,$FB,$57,$EA
.missile_s04
	dw $0002
	db $FD,$01,$01,$59,$AA
	db $FD,$01,$F9,$5A,$AA
.missile_s05
	dw $0003
	db $F8,$01,$03,$56,$AA
	db $00,$00,$FB,$58,$AA
	db $F8,$01,$FB,$57,$AA
.missile_s06
	dw $0002
	db $FF,$01,$FC,$55,$2A
	db $F7,$01,$FC,$54,$2A
.missile_s07
	dw $0003
	db $F8,$01,$F5,$56,$2A
	db $00,$00,$FD,$58,$2A
	db $F8,$01,$FD,$57,$2A