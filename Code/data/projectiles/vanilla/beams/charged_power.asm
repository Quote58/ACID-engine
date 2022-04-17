.power_up
	dw $0001,.power_s00,$0808,$0000
	dw $0001,.power_s01,$0808,$0001
	dw $8239,.power_up
.power_up_right
	dw $0001,.power_s00,$0808,$0000
	dw $0001,.power_s01,$0808,$0001
	dw $8239,.power_up_right
.power_right
	dw $0001,.power_s00,$0808,$0000
	dw $0001,.power_s01,$0808,$0001
	dw $8239,.power_right
.power_down_right
	dw $0001,.power_s00,$0808,$0000
	dw $0001,.power_s01,$0808,$0001
	dw $8239,.power_down_right
.power_down
	dw $0001,.power_s00,$0808,$0000
	dw $0001,.power_s01,$0808,$0001
	dw $8239,.power_down
.power_down_left
	dw $0001,.power_s00,$0808,$0000
	dw $0001,.power_s01,$0808,$0001
	dw $8239,.power_down_left
.power_left
	dw $0001,.power_s00,$0808,$0000
	dw $0001,.power_s01,$0808,$0001
	dw $8239,.power_left
.power_up_left
	dw $0001,.power_s00,$0808,$0000
	dw $0001,.power_s01,$0808,$0001
	dw $8239,.power_up_left

.power_s00
	dw $0004
	db $00,$00,$00,$33,$EC
	db $00,$00,$F8,$33,$6C
	db $F8,$01,$00,$33,$AC
	db $F8,$01,$F8,$33,$2C
.power_s01
	dw $0004
	db $00,$00,$00,$34,$EC
	db $00,$00,$F8,$34,$6C
	db $F8,$01,$00,$34,$AC
	db $F8,$01,$F8,$34,$2C