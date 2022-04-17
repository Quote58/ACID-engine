.bomb_explosion
	dw $0002,.bomb_explosion_s00,$0808,$0000
	dw $0002,.bomb_explosion_s01,$0C0C,$0000
	dw $0002,.bomb_explosion_s02,$1010,$0000
	dw $0002,.bomb_explosion_s03,$1010,$0000
	dw $0002,.bomb_explosion_s04,$1010,$0000
	dw $822F

.bomb_explosion_s00
	dw $0004
	db $00,$00,$00,$8B,$FA
	db $F8,$01,$00,$8B,$BA
	db $00,$00,$F8,$8B,$7A
	db $F8,$01,$F8,$8B,$3A
.bomb_explosion_s01
	dw $0004
	db $00,$00,$00,$7A,$FA
	db $F8,$01,$00,$7A,$BA
	db $00,$00,$F8,$7A,$7A
	db $F8,$01,$F8,$7A,$3A
.bomb_explosion_s02
	dw $0004
	db $00,$C2,$00,$70,$FA
	db $F0,$C3,$00,$70,$BA
	db $00,$C2,$F0,$70,$7A
	db $F0,$C3,$F0,$70,$3A
.bomb_explosion_s03
	dw $0004
	db $00,$C2,$00,$72,$FA
	db $F0,$C3,$00,$72,$BA
	db $00,$C2,$F0,$72,$7A
	db $F0,$C3,$F0,$72,$3A
.bomb_explosion_s04
	dw $0004
	db $00,$C2,$00,$74,$FA
	db $F0,$C3,$00,$74,$BA
	db $00,$C2,$F0,$74,$7A
	db $F0,$C3,$F0,$74,$3A