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
	dw $0002
	db $00,$00,$FC,$31,$2C
	db $F8,$01,$FC,$31,$6C
.power_s01
	dw $0003
	db $00,$00,$00,$34,$6C
	db $00,$00,$F8,$32,$6C
	db $F8,$01,$F8,$33,$6C
.power_s02
	dw $0002
	db $FC,$01,$F8,$30,$6C
	db $FC,$01,$00,$30,$EC
.power_s03
	dw $0003
	db $00,$00,$F8,$34,$EC
	db $00,$00,$00,$32,$EC
	db $F8,$01,$00,$33,$EC
.power_s04
	dw $0002
	db $00,$00,$FC,$31,$AC
	db $F8,$01,$FC,$31,$EC
.power_s05
	dw $0003
	db $F8,$01,$F8,$34,$AC
	db $F8,$01,$00,$32,$AC
	db $00,$00,$00,$33,$AC
.power_s06
	dw $0002
	db $FC,$01,$F8,$30,$2C
	db $FC,$01,$00,$30,$AC
.power_s07
	dw $0003
	db $FC,$01,$04,$34,$2C
	db $FC,$01,$FC,$32,$2C
	db $04,$00,$FC,$33,$2C