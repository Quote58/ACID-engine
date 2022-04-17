.plasma_up
.plasma_down
	dw $0001,.plasma_s00,$0808,$0000
	dw $0001,.plasma_s01,$0808,$0001
	dw $0001,.plasma_s02,$1008,$0002
	dw $0001,.plasma_s03,$1008,$0003
	dw $0001,.plasma_s04,$1808,$0004
	dw $0001,.plasma_s05,$1808,$0005
.plasma_up_l
	dw $0001,.plasma_s06,$1C08,$0006
	dw $0001,.plasma_s07,$1C08,$0007
	dw $8239,.plasma_up_l
.plasma_up_right
.plasma_down_left
	dw $0001,.plasma_s08,$0808,$0000
	dw $0001,.plasma_s09,$0808,$0001
	dw $0001,.plasma_s10,$0C0C,$0002
	dw $0001,.plasma_s11,$0C0C,$0003
	dw $0001,.plasma_s12,$1010,$0004
	dw $0001,.plasma_s13,$1010,$0005
.plasma_up_right_l
	dw $0001,.plasma_s14,$1414,$0006
	dw $0001,.plasma_s15,$1414,$0007
	dw $8239,.plasma_up_right_l
.plasma_right
.plasma_left
	dw $0001,.plasma_s16,$0808,$0000
	dw $0001,.plasma_s17,$0808,$0001
	dw $0001,.plasma_s18,$0810,$0002
	dw $0001,.plasma_s19,$0810,$0003
	dw $0001,.plasma_s20,$0818,$0004
	dw $0001,.plasma_s21,$0818,$0005
.plasma_right_l
	dw $0001,.plasma_s22,$081C,$0006
	dw $0001,.plasma_s23,$081C,$0007
	dw $8239,.plasma_right_l
.plasma_down_right
.plasma_up_left
	dw $0001,.plasma_s24,$0808,$0000
	dw $0001,.plasma_s25,$0808,$0001
	dw $0001,.plasma_s26,$0C0C,$0002
	dw $0001,.plasma_s27,$0C0C,$0003
	dw $0001,.plasma_s28,$1010,$0004
	dw $0001,.plasma_s29,$1010,$0005
.plasma_down_right_l
	dw $0001,.plasma_s30,$1414,$0006
	dw $0001,.plasma_s31,$1414,$0007
	dw $8239,.plasma_down_right_l

.plasma_s00
	dw $0001
	db $FC,$01,$FC,$33,$2C
.plasma_s01
	dw $0001
	db $FC,$01,$FC,$37,$2C
.plasma_s02
	dw $0003
	db $FC,$01,$04,$33,$2C
	db $FC,$01,$FC,$33,$2C
	db $FC,$01,$F4,$33,$2C
.plasma_s03
	dw $0003
	db $FC,$01,$04,$37,$2C
	db $FC,$01,$FC,$37,$2C
	db $FC,$01,$F4,$37,$2C
.plasma_s04
	dw $0006
	db $FC,$01,$10,$33,$2C
	db $FC,$01,$08,$33,$2C
	db $FC,$01,$00,$33,$2C
	db $FC,$01,$F8,$33,$2C
	db $FC,$01,$F0,$33,$2C
	db $FC,$01,$E8,$33,$2C
.plasma_s05
	dw $0006
	db $FC,$01,$10,$37,$2C
	db $FC,$01,$08,$37,$2C
	db $FC,$01,$00,$37,$2C
	db $FC,$01,$F8,$37,$2C
	db $FC,$01,$F0,$37,$2C
	db $FC,$01,$E8,$37,$2C
.plasma_s06
	dw $0007
	db $FC,$01,$14,$33,$2C
	db $FC,$01,$0C,$33,$2C
	db $FC,$01,$04,$33,$2C
	db $FC,$01,$FC,$33,$2C
	db $FC,$01,$F4,$33,$2C
	db $FC,$01,$EC,$33,$2C
	db $FC,$01,$E4,$33,$2C
.plasma_s07
	dw $0007
	db $FC,$01,$14,$37,$2C
	db $FC,$01,$0C,$37,$2C
	db $FC,$01,$04,$37,$2C
	db $FC,$01,$FC,$37,$2C
	db $FC,$01,$F4,$37,$2C
	db $FC,$01,$EC,$37,$2C
	db $FC,$01,$E4,$37,$2C
.plasma_s08
	dw $0002
	db $F8,$01,$FC,$32,$6C
	db $00,$00,$FC,$31,$6C
.plasma_s09
	dw $0002
	db $FC,$01,$F8,$36,$6C
	db $FC,$01,$00,$36,$AC
.plasma_s10
	dw $0004
	db $F4,$01,$00,$32,$6C
	db $FC,$01,$00,$31,$6C
	db $FC,$01,$F8,$32,$6C
	db $04,$00,$F8,$31,$6C
.plasma_s11
	dw $0004
	db $F8,$01,$04,$36,$AC
	db $F8,$01,$FC,$35,$AC
	db $00,$00,$F4,$36,$6C
	db $00,$00,$FC,$35,$6C
.plasma_s12
	dw $0008
	db $EC,$01,$08,$32,$6C
	db $F4,$01,$08,$31,$6C
	db $F4,$01,$00,$32,$6C
	db $FC,$01,$00,$31,$6C
	db $FC,$01,$F8,$32,$6C
	db $04,$00,$F8,$31,$6C
	db $04,$00,$F0,$32,$6C
	db $0C,$00,$F0,$31,$6C
.plasma_s13
	dw $0008
	db $F0,$01,$04,$35,$AC
	db $00,$00,$F4,$35,$AC
	db $F8,$01,$FC,$35,$AC
	db $F0,$01,$0C,$36,$AC
	db $08,$00,$EC,$36,$6C
	db $F8,$01,$04,$35,$6C
	db $00,$00,$FC,$35,$6C
	db $08,$00,$F4,$35,$6C
.plasma_s14
	dw $000A
	db $E8,$01,$0C,$32,$6C
	db $F0,$01,$0C,$31,$6C
	db $F0,$01,$04,$32,$6C
	db $F8,$01,$04,$31,$6C
	db $F8,$01,$FC,$32,$6C
	db $00,$00,$FC,$31,$6C
	db $00,$00,$F4,$32,$6C
	db $08,$00,$F4,$31,$6C
	db $08,$00,$EC,$32,$6C
	db $10,$00,$EC,$31,$6C
.plasma_s15
	dw $000A
	db $EC,$01,$10,$36,$AC
	db $0C,$00,$E8,$36,$6C
	db $EC,$01,$08,$35,$AC
	db $F4,$01,$00,$35,$AC
	db $FC,$01,$F8,$35,$AC
	db $04,$00,$F0,$35,$AC
	db $F4,$01,$08,$35,$6C
	db $FC,$01,$00,$35,$6C
	db $04,$00,$F8,$35,$6C
	db $0C,$00,$F0,$35,$6C
.plasma_s16
	dw $0001
	db $FC,$01,$FC,$30,$2C
.plasma_s17
	dw $0001
	db $FC,$01,$FC,$34,$2C
.plasma_s18
	dw $0003
	db $F4,$01,$FC,$30,$2C
	db $FC,$01,$FC,$30,$2C
	db $04,$00,$FC,$30,$2C
.plasma_s19
	dw $0003
	db $04,$00,$FC,$34,$2C
	db $FC,$01,$FC,$34,$2C
	db $F4,$01,$FC,$34,$2C
.plasma_s20
	dw $0006
	db $10,$00,$FC,$30,$2C
	db $08,$00,$FC,$30,$2C
	db $00,$00,$FC,$30,$2C
	db $F8,$01,$FC,$30,$2C
	db $F0,$01,$FC,$30,$2C
	db $E8,$01,$FC,$30,$2C
.plasma_s21
	dw $0006
	db $10,$00,$FC,$34,$2C
	db $08,$00,$FC,$34,$2C
	db $00,$00,$FC,$34,$2C
	db $F8,$01,$FC,$34,$2C
	db $F0,$01,$FC,$34,$2C
	db $E8,$01,$FC,$34,$2C
.plasma_s22
	dw $0007
	db $14,$00,$FC,$30,$2C
	db $0C,$00,$FC,$30,$2C
	db $04,$00,$FC,$30,$2C
	db $FC,$01,$FC,$30,$2C
	db $F4,$01,$FC,$30,$2C
	db $EC,$01,$FC,$30,$2C
	db $E4,$01,$FC,$30,$2C
.plasma_s23
	dw $0007
	db $14,$00,$FC,$34,$2C
	db $0C,$00,$FC,$34,$2C
	db $04,$00,$FC,$34,$2C
	db $FC,$01,$FC,$34,$2C
	db $F4,$01,$FC,$34,$2C
	db $EC,$01,$FC,$34,$2C
	db $E4,$01,$FC,$34,$2C
.plasma_s24
	dw $0002
	db $00,$00,$FC,$32,$2C
	db $F8,$01,$FC,$31,$2C
.plasma_s25
	dw $0002
	db $FC,$01,$F8,$36,$2C
	db $FC,$01,$00,$36,$EC
.plasma_s26
	dw $0004
	db $04,$00,$00,$32,$2C
	db $FC,$01,$00,$31,$2C
	db $FC,$01,$F8,$32,$2C
	db $F4,$01,$F8,$31,$2C
.plasma_s27
	dw $0004
	db $00,$00,$04,$36,$EC
	db $00,$00,$FC,$35,$EC
	db $F8,$01,$F4,$36,$2C
	db $F8,$01,$FC,$35,$2C
.plasma_s28
	dw $0008
	db $0C,$00,$08,$32,$2C
	db $04,$00,$08,$31,$2C
	db $04,$00,$00,$32,$2C
	db $FC,$01,$00,$31,$2C
	db $FC,$01,$F8,$32,$2C
	db $F4,$01,$F8,$31,$2C
	db $F4,$01,$F0,$32,$2C
	db $EC,$01,$F0,$31,$2C
.plasma_s29
	dw $0008
	db $08,$00,$04,$35,$EC
	db $F8,$01,$F4,$35,$EC
	db $00,$00,$FC,$35,$EC
	db $08,$00,$0C,$36,$EC
	db $F0,$01,$EC,$36,$2C
	db $00,$00,$04,$35,$2C
	db $F8,$01,$FC,$35,$2C
	db $F0,$01,$F4,$35,$2C
.plasma_s30
	dw $000A
	db $10,$00,$0C,$32,$2C
	db $08,$00,$0C,$31,$2C
	db $08,$00,$04,$32,$2C
	db $00,$00,$04,$31,$2C
	db $00,$00,$FC,$32,$2C
	db $F8,$01,$FC,$31,$2C
	db $F8,$01,$F4,$32,$2C
	db $F0,$01,$F4,$31,$2C
	db $F0,$01,$EC,$32,$2C
	db $E8,$01,$EC,$31,$2C
.plasma_s31
	dw $000A
	db $0C,$00,$10,$36,$EC
	db $EC,$01,$E8,$36,$2C
	db $0C,$00,$08,$35,$EC
	db $04,$00,$00,$35,$EC
	db $FC,$01,$F8,$35,$EC
	db $F4,$01,$F0,$35,$EC
	db $04,$00,$08,$35,$2C
	db $FC,$01,$00,$35,$2C
	db $F4,$01,$F8,$35,$2C
	db $EC,$01,$F0,$35,$2C