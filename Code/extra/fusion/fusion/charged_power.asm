.power_up
	dw $0001,.power_s00,$0808,$0000
	dw $8239,.power_up
.power_up_right
	dw $0001,.power_s00,$0808,$0000
	dw $8239,.power_up_right
.power_right
	dw $0001,.power_sright,$0808,$0000
	dw $8239,.power_right
.power_down_right
	dw $0001,.power_s00,$0808,$0000
	dw $8239,.power_down_right
.power_down
	dw $0001,.power_s00,$0808,$0000
	dw $8239,.power_down
.power_down_left
	dw $0001,.power_s00,$0808,$0000
	dw $8239,.power_down_left
.power_left
	dw $0001,.power_sleft,$0808,$0000
	dw $8239,.power_left
.power_up_left
	dw $0001,.power_s00,$0808,$0000
	dw $8239,.power_up_left

.power_s00
.power_sleft
	dw $0006
	db $FC,$01,$F8,$30,$2C
	db $F8,$01,$F8,$30,$2C
	db $F4,$01,$F8,$30,$2C
	db $F4,$01,$00,$30,$AC
	db $F8,$01,$00,$30,$AC
	db $FC,$01,$00,$30,$AC
.power_sright
	dw $0006
	db $FC,$01,$F8,$30,$6C
	db $FC,$01,$00,$30,$EC
	db $00,$00,$F8,$30,$6C
	db $00,$00,$00,$30,$EC
	db $04,$00,$F8,$30,$6C
	db $04,$00,$00,$30,$EC