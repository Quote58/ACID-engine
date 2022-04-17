.wave_up
	dw $0004,Projectile_no_sprite,$040C,$0000
.wave_down
	dw $0001,.wave_s01,$040C,$0000
	dw $0001,.wave_s02,$040C,$0001
	dw $0001,.wave_s03,$040C,$0002
	dw $0001,.wave_s04,$0410,$0003
	dw $0001,.wave_s05,$0414,$0004
	dw $0001,.wave_s04,$0410,$0005
	dw $0001,.wave_s03,$040C,$0006
	dw $0001,.wave_s02,$040C,$0007
	dw $0001,.wave_s01,$040C,$0008
	dw $0001,.wave_s06,$040C,$0009
	dw $0001,.wave_s07,$040C,$000A
	dw $0001,.wave_s08,$0410,$000B
	dw $0001,.wave_s09,$0414,$000C
	dw $0001,.wave_s08,$0410,$000D
	dw $0001,.wave_s07,$040C,$000E
	dw $0001,.wave_s06,$040C,$000F
	dw $8239,.wave_down
.wave_up_right
.wave_down_left
	dw $0001,.wave_s01,$0808,$0000
	dw $0001,.wave_s10,$0808,$0001
	dw $0001,.wave_s11,$0808,$0002
	dw $0001,.wave_s12,$0A0A,$0003
	dw $0001,.wave_s13,$0C0C,$0004
	dw $0001,.wave_s12,$0A0A,$0005
	dw $0001,.wave_s11,$0808,$0006
	dw $0001,.wave_s10,$0606,$0007
	dw $0001,.wave_s01,$0404,$0008
	dw $0001,.wave_s14,$0606,$0009
	dw $0001,.wave_s15,$0808,$000A
	dw $0001,.wave_s16,$0A0A,$000B
	dw $0001,.wave_s17,$0C0C,$000C
	dw $0001,.wave_s16,$0A0A,$000D
	dw $0001,.wave_s15,$0808,$000E
	dw $0001,.wave_s14,$0808,$000F
	dw $8239,.wave_down_left
.wave_right
.wave_left
	dw $0001,.wave_s01,$0C04,$0000
	dw $0001,.wave_s18,$0C04,$0001
	dw $0001,.wave_s19,$0C04,$0002
	dw $0001,.wave_s20,$1004,$0003
	dw $0001,.wave_s21,$1404,$0004
	dw $0001,.wave_s20,$1004,$0005
	dw $0001,.wave_s19,$0C04,$0006
	dw $0001,.wave_s18,$0C04,$0007
	dw $0001,.wave_s01,$0C04,$0008
	dw $0001,.wave_s22,$0C04,$0009
	dw $0001,.wave_s23,$0C04,$000A
	dw $0001,.wave_s24,$1004,$000B
	dw $0001,.wave_s25,$1404,$000C
	dw $0001,.wave_s24,$1004,$000D
	dw $0001,.wave_s23,$0C04,$000E
	dw $0001,.wave_s22,$0C04,$000F
	dw $8239,.wave_left
.wave_down_right
.wave_up_left
	dw $0001,.wave_s01,$0808,$0000
	dw $0001,.wave_s26,$0808,$0001
	dw $0001,.wave_s27,$0808,$0002
	dw $0001,.wave_s28,$0A0A,$0003
	dw $0001,.wave_s29,$0C0C,$0004
	dw $0001,.wave_s28,$0A0A,$0005
	dw $0001,.wave_s27,$0808,$0006
	dw $0001,.wave_s26,$0606,$0007
	dw $0001,.wave_s01,$0404,$0008
	dw $0001,.wave_s30,$0606,$0009
	dw $0001,.wave_s31,$0808,$000A
	dw $0001,.wave_s32,$0A0A,$000B
	dw $0001,.wave_s33,$0C0C,$000C
	dw $0001,.wave_s32,$0A0A,$000D
	dw $0001,.wave_s31,$0808,$000E
	dw $0001,.wave_s30,$0808,$000F
	dw $8239,.wave_up_left

.wave_s01
	dw $0001
	db $FC,$01,$FC,$30,$2C
.wave_s02
	dw $0001
	db $04,$00,$FC,$30,$2C
.wave_s03
	dw $0001
	db $09,$00,$FC,$31,$2C
.wave_s04
	dw $0001
	db $0B,$00,$FC,$31,$2C
.wave_s05
	dw $0001
	db $0C,$00,$FC,$32,$2C
.wave_s06
	dw $0001
	db $F4,$01,$FC,$30,$2C
.wave_s07
	dw $0001
	db $EF,$01,$FC,$31,$2C
.wave_s08
	dw $0001
	db $ED,$01,$FC,$31,$2C
.wave_s09
	dw $0001
	db $EC,$01,$FC,$32,$2C
.wave_s10
	dw $0001
	db $F6,$01,$F6,$30,$2C
.wave_s11
	dw $0001
	db $F3,$01,$F3,$31,$2C
.wave_s12
	dw $0001
	db $F1,$01,$F1,$31,$2C
.wave_s13
	dw $0001
	db $F0,$01,$F0,$32,$2C
.wave_s14
	dw $0001
	db $02,$00,$02,$30,$2C
.wave_s15
	dw $0001
	db $05,$00,$05,$31,$2C
.wave_s16
	dw $0001
	db $07,$00,$07,$31,$2C
.wave_s17
	dw $0001
	db $08,$00,$08,$32,$2C
.wave_s18
	dw $0001
	db $FC,$01,$F4,$30,$2C
.wave_s19
	dw $0001
	db $FC,$01,$EF,$31,$2C
.wave_s20
	dw $0001
	db $FC,$01,$ED,$31,$2C
.wave_s21
	dw $0001
	db $FC,$01,$EC,$32,$2C
.wave_s22
	dw $0001
	db $FC,$01,$04,$30,$2C
.wave_s23
	dw $0001
	db $FC,$01,$09,$31,$2C
.wave_s24
	dw $0001
	db $FC,$01,$0B,$31,$2C
.wave_s25
	dw $0001
	db $FC,$01,$0C,$32,$2C
.wave_s26
	dw $0001
	db $02,$00,$F6,$30,$2C
.wave_s27
	dw $0001
	db $05,$00,$F3,$31,$2C
.wave_s28
	dw $0001
	db $07,$00,$F1,$31,$2C
.wave_s29
	dw $0001
	db $08,$00,$F0,$32,$2C
.wave_s30
	dw $0001
	db $F6,$01,$02,$30,$2C
.wave_s31
	dw $0001
	db $F3,$01,$05,$31,$2C
.wave_s32
	dw $0001
	db $F1,$01,$07,$31,$2C
.wave_s33
	dw $0001
	db $F0,$01,$08,$32,$2C
