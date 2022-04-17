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
	dw $0001,.ice_s02,$0808,$0002
	dw $0001,.ice_s03,$0808,$0003
	dw $8239,.ice_up

.ice_s00
	dw $0001
	db $FC,$01,$FC,$30,$2C
.ice_s01
	dw $0001
	db $FC,$01,$FC,$31,$2C
.ice_s02
	dw $0001
	db $FC,$01,$FC,$32,$2C
.ice_s03
	dw $0001
	db $FC,$01,$FC,$31,$6C
