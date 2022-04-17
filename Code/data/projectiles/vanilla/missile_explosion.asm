.missile_explosion
	dw $0003,.missile_explosion_s00,$0808,$0000
	dw $0003,.missile_explosion_s01,$0808,$0000
	dw $0003,.missile_explosion_s02,$0808,$0000
	dw $0003,.missile_explosion_s03,$0808,$0000
	dw $0003,.missile_explosion_s04,$0808,$0000
	dw $0003,.missile_explosion_s05,$0808,$0000
	dw $822F

.missile_explosion_s00
	dw $0001
	db $FC,$01,$FC,$5F,$3A
.missile_explosion_s01
	dw $0004
	db $00,$00,$00,$8A,$FA
	db $F8,$01,$00,$8A,$BA
	db $00,$00,$F8,$8A,$7A
	db $F8,$01,$F8,$8A,$3A
.missile_explosion_s02
	dw $0004
	db $00,$C2,$00,$90,$FA
	db $F0,$C3,$00,$90,$BA
	db $00,$C2,$F0,$90,$7A
	db $F0,$C3,$F0,$90,$3A
.missile_explosion_s03
	dw $0004
	db $00,$C2,$00,$92,$FA
	db $F0,$C3,$00,$92,$BA
	db $00,$C2,$F0,$92,$7A
	db $F0,$C3,$F0,$92,$3A
.missile_explosion_s04
	dw $0004
	db $00,$C2,$00,$94,$FA
	db $F0,$C3,$00,$94,$BA
	db $00,$C2,$F0,$94,$7A
	db $F0,$C3,$F0,$94,$3A
.missile_explosion_s05
	dw $0004
	db $00,$C2,$00,$96,$FA
	db $F0,$C3,$00,$96,$BA
	db $00,$C2,$F0,$96,$7A
	db $F0,$C3,$F0,$96,$3A