.super_missile_explosion
	dw $0005,.super_missile_explosion_s00,$0808,$0000
	dw $0005,.super_missile_explosion_s01,$0C0C,$0000
	dw $0005,.super_missile_explosion_s02,$1010,$0000
	dw $0005,.super_missile_explosion_s03,$1010,$0000
	dw $0005,.super_missile_explosion_s04,$1010,$0000
	dw $0005,.super_missile_explosion_s05,$1010,$0000
	dw $822F

.super_missile_explosion_s00
	dw $0004
	db $00,$00,$00,$8A,$FA
	db $F8,$01,$00,$8A,$BA
	db $00,$00,$F8,$8A,$7A
	db $F8,$01,$F8,$8A,$3A
.super_missile_explosion_s01
	dw $0004
	db $00,$C2,$00,$90,$FA
	db $00,$C2,$F0,$90,$7A
	db $F0,$C3,$00,$90,$BA
	db $F0,$C3,$F0,$90,$3A
.super_missile_explosion_s02
	dw $0004
	db $00,$C2,$00,$92,$FA
	db $F0,$C3,$00,$92,$BA
	db $00,$C2,$F0,$92,$7A
	db $F0,$C3,$F0,$92,$3A
.super_missile_explosion_s03
	dw $000C
	db $10,$00,$00,$C2,$FA
	db $10,$00,$F8,$C2,$7A
	db $00,$00,$10,$B2,$FA
	db $F8,$01,$10,$B2,$BA
	db $E8,$01,$00,$C2,$BA
	db $E8,$01,$F8,$C2,$3A
	db $00,$00,$E8,$B2,$7A
	db $F8,$01,$E8,$B2,$3A
	db $00,$C2,$00,$B0,$FA
	db $00,$C2,$F0,$B0,$7A
	db $F0,$C3,$00,$B0,$BA
	db $F0,$C3,$F0,$B0,$3A
.super_missile_explosion_s04
	dw $0008
	db $08,$C2,$00,$B5,$FA
	db $00,$C2,$08,$B3,$FA
	db $E8,$C3,$00,$B5,$BA
	db $F0,$C3,$08,$B3,$BA
	db $08,$C2,$F0,$B5,$7A
	db $00,$C2,$E8,$B3,$7A
	db $E8,$C3,$F0,$B5,$3A
	db $F0,$C3,$E8,$B3,$3A
.super_missile_explosion_s05
	dw $000C
	db $00,$00,$10,$BB,$FA
	db $F8,$01,$10,$BB,$BA
	db $00,$00,$E8,$BB,$7A
	db $F8,$01,$E8,$BB,$3A
	db $10,$00,$00,$B7,$FA
	db $10,$00,$F8,$B7,$7A
	db $E8,$01,$00,$B7,$BA
	db $E8,$01,$F8,$B7,$3A
	db $08,$C2,$08,$B8,$FA
	db $E8,$C3,$08,$B8,$BA
	db $08,$C2,$E8,$B8,$7A
	db $E8,$C3,$E8,$B8,$3A