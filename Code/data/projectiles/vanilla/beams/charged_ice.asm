.ice_up
.ice_up_right
.ice_right
.ice_down_right
.ice_down
.ice_down_left
.ice_left
.ice_up_left
	dw $0001,.ice_s00,$0808,$0000
	dw $0001,.ice_s01,$0808,$0001
	dw $0001,.ice_s00,$0808,$0002
	dw $0001,.ice_s01,$0808,$0003
	dw $8239,.ice_up

.ice_s00
	dw $0004
	db $00,$00,$00,$33,$EC
	db $F8,$01,$00,$33,$AC
	db $00,$00,$F8,$33,$6C
	db $F8,$01,$F8,$33,$2C
.ice_s01
	dw $0004
	db $00,$00,$00,$34,$EC
	db $F8,$01,$00,$34,$AC
	db $00,$00,$F8,$34,$6C
	db $F8,$01,$F8,$34,$2C