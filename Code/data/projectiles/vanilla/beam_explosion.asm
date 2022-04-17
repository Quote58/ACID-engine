.beam_explosion
	dw $0003,.beam_explosion_s00,$0000,$0000
	dw $0003,.beam_explosion_s01,$0000,$0000
	dw $0003,.beam_explosion_s02,$0000,$0000
	dw $0003,.beam_explosion_s03,$0000,$0000
	dw $0003,.beam_explosion_s04,$0000,$0000
	dw $0003,.beam_explosion_s05,$0000,$0000
	dw $822F

.beam_explosion_s00
	dw $0001
	db $FC,$01,$FC,$53,$3C
.beam_explosion_s01
	dw $0001
	db $FC,$01,$FC,$51,$3C
.beam_explosion_s02
	dw $0004
	db $00,$00,$00,$60,$FC
	db $00,$00,$F8,$60,$7C
	db $F8,$01,$00,$60,$BC
	db $F8,$01,$F8,$60,$3C
.beam_explosion_s03
	dw $0004
	db $00,$00,$00,$61,$FC
	db $00,$00,$F8,$61,$7C
	db $F8,$01,$00,$61,$BC
	db $F8,$01,$F8,$61,$3C
.beam_explosion_s04
	dw $0004
	db $00,$00,$00,$62,$FC
	db $00,$00,$F8,$62,$7C
	db $F8,$01,$00,$62,$BC
	db $F8,$01,$F8,$62,$3C
.beam_explosion_s05
	dw $0004
	db $00,$00,$00,$63,$FC
	db $00,$00,$F8,$63,$7C
	db $F8,$01,$00,$63,$BC
	db $F8,$01,$F8,$63,$3C