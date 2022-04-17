.spazer_up
	dw $0002,.spazer_s00,$080C,$0000
	dw $0002,.spazer_s01,$080C,$0001
.spazer_up_l
	dw $0002,.spazer_s02,$0814,$0002
	dw $8239,.spazer_up_l
.spazer_up_right
	dw $0002,.spazer_s03,$0808,$0000
	dw $0002,.spazer_s04,$0C0C,$0001
.spazer_up_right_l
	dw $0002,.spazer_s05,$1010,$0002
	dw $8239,.spazer_up_right_l
.spazer_right
	dw $0002,.spazer_s06,$0C08,$0000
	dw $0002,.spazer_s07,$0C08,$0001
.spazer_right_l
	dw $0002,.spazer_s08,$1408,$0002
	dw $8239,.spazer_right_l
.spazer_down_right
	dw $0002,.spazer_s09,$0808,$0000
	dw $0002,.spazer_s10,$0C0C,$0001
.spazer_down_right_l
	dw $0002,.spazer_s11,$1010,$0002
	dw $8239,.spazer_down_right_l
.spazer_down
	dw $0002,.spazer_s12,$080C,$0000
	dw $0002,.spazer_s13,$080C,$0001
.spazer_down_l
	dw $0002,.spazer_s14,$0814,$0002
	dw $8239,.spazer_down_l
.spazer_down_left
	dw $0002,.spazer_s15,$0808,$0000
	dw $0002,.spazer_s16,$0C0C,$0001
.spazer_down_left_l
	dw $0002,.spazer_s17,$1010,$0002
	dw $8239,.spazer_down_left_l
.spazer_left
	dw $0002,.spazer_s18,$0C08,$0000
	dw $0002,.spazer_s19,$0C08,$0001
.spazer_left_l
	dw $0002,.spazer_s20,$1408,$0002
	dw $8239,.spazer_left_l
.spazer_up_left
	dw $0002,.spazer_s21,$0808,$0000
	dw $0002,.spazer_s22,$0C0C,$0001
.spazer_up_left_l
	dw $0002,.spazer_s23,$1010,$0002
	dw $8239,.spazer_up_left_l

.spazer_s00
	dw $0002
	db $FC,$01,$00,$33,$2C
	db $FC,$01,$F8,$33,$2C
.spazer_s01
	dw $0006
	db $04,$00,$00,$33,$2C
	db $04,$00,$F8,$33,$2C
	db $F4,$01,$00,$33,$2C
	db $F4,$01,$F8,$33,$2C
	db $FC,$01,$00,$33,$2C
	db $FC,$01,$F8,$33,$2C
.spazer_s02
	dw $0006
	db $0C,$00,$00,$33,$2C
	db $0C,$00,$F8,$33,$2C
	db $EC,$01,$00,$33,$2C
	db $EC,$01,$F8,$33,$2C
	db $FC,$01,$00,$33,$2C
	db $FC,$01,$F8,$33,$2C
.spazer_s03
	dw $0004
	db $F2,$01,$00,$32,$6C
	db $FA,$01,$00,$31,$6C
	db $FA,$01,$F8,$32,$6C
	db $02,$00,$F8,$31,$6C
.spazer_s04
	dw $000C
	db $F2,$01,$00,$32,$6C
	db $FA,$01,$00,$31,$6C
	db $FA,$01,$F8,$32,$6C
	db $02,$00,$F8,$31,$6C
	db $EC,$01,$FA,$32,$6C
	db $F4,$01,$FA,$31,$6C
	db $F4,$01,$F2,$32,$6C
	db $FC,$01,$F2,$31,$6C
	db $F8,$01,$06,$32,$6C
	db $00,$00,$06,$31,$6C
	db $00,$00,$FE,$32,$6C
	db $08,$00,$FE,$31,$6C
.spazer_s05
	dw $000C
	db $F2,$01,$00,$32,$6C
	db $FA,$01,$00,$31,$6C
	db $FA,$01,$F8,$32,$6C
	db $02,$00,$F8,$31,$6C
	db $E6,$01,$F4,$32,$6C
	db $EE,$01,$F4,$31,$6C
	db $EE,$01,$EC,$32,$6C
	db $F6,$01,$EC,$31,$6C
	db $FE,$01,$0C,$32,$6C
	db $06,$00,$0C,$31,$6C
	db $06,$00,$04,$32,$6C
	db $0E,$00,$04,$31,$6C
.spazer_s06
	dw $0002
	db $F8,$01,$FC,$30,$6C
	db $00,$00,$FC,$30,$6C
.spazer_s07
	dw $0006
	db $F8,$01,$F4,$30,$6C
	db $F8,$01,$FC,$30,$6C
	db $F8,$01,$04,$30,$6C
	db $00,$00,$04,$30,$6C
	db $00,$00,$FC,$30,$6C
	db $00,$00,$F4,$30,$6C
.spazer_s08
	dw $0006
	db $F8,$01,$EC,$30,$6C
	db $F8,$01,$FC,$30,$6C
	db $F8,$01,$0C,$30,$6C
	db $00,$00,$0C,$30,$6C
	db $00,$00,$FC,$30,$6C
	db $00,$00,$EC,$30,$6C
.spazer_s09
	dw $0004
	db $F2,$01,$F8,$32,$EC
	db $FA,$01,$F8,$31,$EC
	db $FA,$01,$00,$32,$EC
	db $02,$00,$00,$31,$EC
.spazer_s10
	dw $000C
	db $F2,$01,$F8,$32,$EC
	db $FA,$01,$F8,$31,$EC
	db $FA,$01,$00,$32,$EC
	db $02,$00,$00,$31,$EC
	db $EC,$01,$FE,$32,$EC
	db $F4,$01,$FE,$31,$EC
	db $F4,$01,$06,$32,$EC
	db $FC,$01,$06,$31,$EC
	db $F8,$01,$F2,$32,$EC
	db $00,$00,$F2,$31,$EC
	db $00,$00,$FA,$32,$EC
	db $08,$00,$FA,$31,$EC
.spazer_s11
	dw $000C
	db $F2,$01,$F8,$32,$EC
	db $FA,$01,$F8,$31,$EC
	db $FA,$01,$00,$32,$EC
	db $02,$00,$00,$31,$EC
	db $E6,$01,$04,$32,$EC
	db $EE,$01,$04,$31,$EC
	db $EE,$01,$0C,$32,$EC
	db $F6,$01,$0C,$31,$EC
	db $FE,$01,$EC,$32,$EC
	db $06,$00,$EC,$31,$EC
	db $06,$00,$F4,$32,$EC
	db $0E,$00,$F4,$31,$EC
.spazer_s12
	dw $0002
	db $FC,$01,$F8,$33,$AC
	db $FC,$01,$00,$33,$AC
.spazer_s13
	dw $0006
	db $04,$00,$F8,$33,$AC
	db $04,$00,$00,$33,$AC
	db $F4,$01,$F8,$33,$AC
	db $F4,$01,$00,$33,$AC
	db $FC,$01,$F8,$33,$AC
	db $FC,$01,$00,$33,$AC
.spazer_s14
	dw $0006
	db $0C,$00,$F8,$33,$AC
	db $0C,$00,$00,$33,$AC
	db $EC,$01,$F8,$33,$AC
	db $EC,$01,$00,$33,$AC
	db $FC,$01,$F8,$33,$AC
	db $FC,$01,$00,$33,$AC
.spazer_s15
	dw $0004
	db $06,$00,$F8,$32,$AC
	db $FE,$01,$F8,$31,$AC
	db $FE,$01,$00,$32,$AC
	db $F6,$01,$00,$31,$AC
.spazer_s16
	dw $000C
	db $06,$00,$F8,$32,$AC
	db $FE,$01,$F8,$31,$AC
	db $FE,$01,$00,$32,$AC
	db $F6,$01,$00,$31,$AC
	db $0C,$00,$FE,$32,$AC
	db $04,$00,$FE,$31,$AC
	db $04,$00,$06,$32,$AC
	db $FC,$01,$06,$31,$AC
	db $00,$00,$F2,$32,$AC
	db $F8,$01,$F2,$31,$AC
	db $F8,$01,$FA,$32,$AC
	db $F0,$01,$FA,$31,$AC
.spazer_s17
	dw $000C
	db $06,$00,$F8,$32,$AC
	db $FE,$01,$F8,$31,$AC
	db $FE,$01,$00,$32,$AC
	db $F6,$01,$00,$31,$AC
	db $12,$00,$04,$32,$AC
	db $0A,$00,$04,$31,$AC
	db $0A,$00,$0C,$32,$AC
	db $02,$00,$0C,$31,$AC
	db $FA,$01,$EC,$32,$AC
	db $F2,$01,$EC,$31,$AC
	db $F2,$01,$F4,$32,$AC
	db $EA,$01,$F4,$31,$AC
.spazer_s18
	dw $0002
	db $00,$00,$FC,$30,$2C
	db $F8,$01,$FC,$30,$2C
.spazer_s19
	dw $0006
	db $00,$00,$F4,$30,$2C
	db $00,$00,$FC,$30,$2C
	db $00,$00,$04,$30,$2C
	db $F8,$01,$04,$30,$2C
	db $F8,$01,$FC,$30,$2C
	db $F8,$01,$F4,$30,$2C
.spazer_s20
	dw $0006
	db $00,$00,$EC,$30,$2C
	db $00,$00,$FC,$30,$2C
	db $00,$00,$0C,$30,$2C
	db $F8,$01,$0C,$30,$2C
	db $F8,$01,$FC,$30,$2C
	db $F8,$01,$EC,$30,$2C
.spazer_s21
	dw $0004
	db $06,$00,$00,$32,$2C
	db $FE,$01,$00,$31,$2C
	db $FE,$01,$F8,$32,$2C
	db $F6,$01,$F8,$31,$2C
.spazer_s22
	dw $000C
	db $06,$00,$00,$32,$2C
	db $FE,$01,$00,$31,$2C
	db $FE,$01,$F8,$32,$2C
	db $F6,$01,$F8,$31,$2C
	db $0C,$00,$FA,$32,$2C
	db $04,$00,$FA,$31,$2C
	db $04,$00,$F2,$32,$2C
	db $FC,$01,$F2,$31,$2C
	db $00,$00,$06,$32,$2C
	db $F8,$01,$06,$31,$2C
	db $F8,$01,$FE,$32,$2C
	db $F0,$01,$FE,$31,$2C
.spazer_s23
	dw $000C
	db $06,$00,$00,$32,$2C
	db $FE,$01,$00,$31,$2C
	db $FE,$01,$F8,$32,$2C
	db $F6,$01,$F8,$31,$2C
	db $12,$00,$F4,$32,$2C
	db $0A,$00,$F4,$31,$2C
	db $0A,$00,$EC,$32,$2C
	db $02,$00,$EC,$31,$2C
	db $FA,$01,$0C,$32,$2C
	db $F2,$01,$0C,$31,$2C
	db $F2,$01,$04,$32,$2C
	db $EA,$01,$04,$31,$2C