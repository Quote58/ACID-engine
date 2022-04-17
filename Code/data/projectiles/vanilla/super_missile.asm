.super_missile_up
	dw $000F,.super_s00,$0808,$0000
	dw $8239,.super_missile_up
.super_missile_up_right
	dw $000F,.super_s01,$0808,$0000
	dw $8239,.super_missile_up_right
.super_missile_right
	dw $000F,.super_s02,$0808,$0000
	dw $8239,.super_missile_right
.super_missile_down_right
	dw $000F,.super_s03,$0808,$0000
	dw $8239,.super_missile_down_right
.super_missile_down
	dw $000F,.super_s04,$0808,$0000
	dw $8239,.super_missile_down
.super_missile_down_left
	dw $000F,.super_s05,$0808,$0000
	dw $8239,.super_missile_down_left
.super_missile_left
	dw $000F,.super_s06,$0808,$0000
	dw $8239,.super_missile_left
.super_missile_up_left
	dw $000F,.super_s07,$0808,$0000
	dw $8239,.super_missile_up_left

.super_s00
	dw $0002
	db $FC,$01,$F8,$69,$2A
	db $FC,$01,$00,$6A,$2A
.super_s01
	dw $0003
	db $F6,$01,$FE,$68,$6A
	db $FE,$01,$FE,$67,$6A
	db $FE,$01,$F6,$66,$6A
.super_s02
	dw $0002
	db $F8,$01,$FC,$65,$6A
	db $00,$00,$FC,$64,$6A
.super_s03
	dw $0003
	db $F6,$01,$FA,$68,$EA
	db $FE,$01,$FA,$67,$EA
	db $FE,$01,$02,$66,$EA
.super_s04
	dw $0002
	db $FC,$01,$00,$69,$AA
	db $FC,$01,$F8,$6A,$AA
.super_s05
	dw $0003
	db $02,$00,$FA,$68,$AA
	db $FA,$01,$FA,$67,$AA
	db $FA,$01,$02,$66,$AA
.super_s06
	dw $0002
	db $00,$00,$FC,$65,$2A
	db $F8,$01,$FC,$64,$2A
.super_s07
	dw $0003
	db $02,$00,$FE,$68,$2A
	db $FA,$01,$FE,$67,$2A
	db $FA,$01,$F6,$66,$2A