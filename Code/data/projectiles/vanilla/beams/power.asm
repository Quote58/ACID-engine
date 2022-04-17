.power_up
	dw $000F,.power_s00,$0404,$0000
	dw $8239,.power_up
.power_up_right
	dw $000F,.power_s01,$0408,$0000
	dw $8239,.power_up_right
.power_right
	dw $000F,.power_s02,$0408,$0000
	dw $8239,.power_right
.power_down_right
	dw $000F,.power_s03,$0408,$0000
	dw $8239,.power_down_right
.power_down
	dw $000F,.power_s04,$0404,$0000
	dw $8239,.power_down
.power_down_left
	dw $000F,.power_s05,$0408,$0000
	dw $8239,.power_down_left
.power_left
	dw $000F,.power_s06,$0408,$0000
	dw $8239,.power_left
.power_up_left
	dw $000F,.power_s07,$0408,$0000
	dw $8239,.power_up_left

.power_s00
	dw $0001
	db $FC,$01,$FC,$32,$2C
.power_s01
	dw $0001
	db $FC,$01,$FC,$31,$6C
.power_s02
	dw $0001
	db $FC,$01,$FC,$30,$EC
.power_s03
	dw $0001
	db $FC,$01,$FC,$31,$EC
.power_s04
	dw $0001
	db $FC,$01,$FC,$32,$AC
.power_s05
	dw $0001
	db $FC,$01,$FC,$31,$AC
.power_s06
	dw $0001
	db $FC,$01,$FC,$30,$2C
.power_s07
	dw $0001
	db $FC,$01,$FC,$31,$2C