.plasma_wave_up
.plasma_wave_down
	dw $0001,.plasma_wave_s00,$100C,$0000
.plasma_wave_up_l
	dw $0002,.plasma_wave_s01,$100C,$0001
	dw $0002,.plasma_wave_s02,$100C,$0002
	dw $0002,.plasma_wave_s03,$1011,$0003
	dw $0002,.plasma_wave_s04,$1013,$0004
	dw $0002,.plasma_wave_s05,$1014,$0005
	dw $0002,.plasma_wave_s04,$1013,$0006
	dw $0002,.plasma_wave_s03,$1011,$0007
	dw $0002,.plasma_wave_s02,$100C,$0008
	dw $8239,.plasma_wave_up_l
.plasma_wave_up_right
.plasma_wave_down_left
	dw $0001,.plasma_wave_s06,$0808,$0000
.plasma_wave_up_right_l
	dw $0002,.plasma_wave_s07,$0808,$0001
	dw $0002,.plasma_wave_s08,$0C0C,$0002
	dw $0002,.plasma_wave_s09,$1010,$0003
	dw $0002,.plasma_wave_s10,$1010,$0004
	dw $0002,.plasma_wave_s11,$1414,$0005
	dw $0002,.plasma_wave_s10,$1010,$0006
	dw $0002,.plasma_wave_s09,$1010,$0007
	dw $0002,.plasma_wave_s08,$0C0C,$0008
	dw $8239,.plasma_wave_up_right_l
.plasma_wave_right
.plasma_wave_left
	dw $0001,.plasma_wave_s12,$0C08,$0000
.plasma_wave_right_l
	dw $0002,.plasma_wave_s13,$0C10,$0001
	dw $0002,.plasma_wave_s14,$0C10,$0002
	dw $0002,.plasma_wave_s15,$1110,$0003
	dw $0002,.plasma_wave_s16,$1310,$0004
	dw $0002,.plasma_wave_s17,$1410,$0005
	dw $0002,.plasma_wave_s16,$1310,$0006
	dw $0002,.plasma_wave_s15,$1110,$0007
	dw $0002,.plasma_wave_s14,$0C10,$0008
	dw $8239,.plasma_wave_right_l
.plasma_wave_down_right
.plasma_wave_up_left
	dw $0001,.plasma_wave_s18,$0808,$0000
.plasma_wave_down_right_l
	dw $0002,.plasma_wave_s19,$0808,$0001
	dw $0002,.plasma_wave_s20,$0C0C,$0002
	dw $0002,.plasma_wave_s21,$1010,$0003
	dw $0002,.plasma_wave_s22,$1010,$0004
	dw $0002,.plasma_wave_s23,$1414,$0005
	dw $0002,.plasma_wave_s22,$1010,$0006
	dw $0002,.plasma_wave_s21,$1010,$0007
	dw $0002,.plasma_wave_s20,$0C0C,$0008
	dw $8239,.plasma_wave_down_right_l

.plasma_wave_s00
	dw $0001
	db $FC,$01,$FC,$33,$2C
.plasma_wave_s01
	dw $0004
	db $FC,$01,$08,$33,$2C
	db $FC,$01,$00,$33,$2C
	db $FC,$01,$F0,$33,$2C
	db $FC,$01,$F8,$33,$2C
.plasma_wave_s02
	dw $0008
	db $04,$00,$08,$33,$2C
	db $04,$00,$00,$33,$2C
	db $04,$00,$F0,$33,$2C
	db $04,$00,$F8,$33,$2C
	db $F5,$01,$08,$33,$2C
	db $F5,$01,$00,$33,$2C
	db $F5,$01,$F0,$33,$2C
	db $F5,$01,$F8,$33,$2C
.plasma_wave_s03
	dw $0008
	db $09,$00,$08,$33,$2C
	db $09,$00,$00,$33,$2C
	db $09,$00,$F0,$33,$2C
	db $09,$00,$F8,$33,$2C
	db $EF,$01,$08,$33,$2C
	db $EF,$01,$00,$33,$2C
	db $EF,$01,$F0,$33,$2C
	db $EF,$01,$F8,$33,$2C
.plasma_wave_s04
	dw $0008
	db $0B,$00,$08,$33,$2C
	db $0B,$00,$00,$33,$2C
	db $0B,$00,$F0,$33,$2C
	db $0B,$00,$F8,$33,$2C
	db $EE,$01,$08,$33,$2C
	db $EE,$01,$00,$33,$2C
	db $EE,$01,$F0,$33,$2C
	db $EE,$01,$F8,$33,$2C
.plasma_wave_s05
	dw $0008
	db $0C,$00,$08,$33,$2C
	db $0C,$00,$00,$33,$2C
	db $0C,$00,$F0,$33,$2C
	db $0C,$00,$F8,$33,$2C
	db $ED,$01,$08,$33,$2C
	db $ED,$01,$00,$33,$2C
	db $ED,$01,$F0,$33,$2C
	db $ED,$01,$F8,$33,$2C
.plasma_wave_s06
	dw $0002
	db $F8,$01,$FC,$32,$6C
	db $00,$00,$FC,$31,$6C
.plasma_wave_s07
	dw $0006
	db $F0,$01,$04,$32,$6C
	db $F8,$01,$04,$31,$6C
	db $00,$00,$F4,$32,$6C
	db $08,$00,$F4,$31,$6C
	db $F8,$01,$FC,$32,$6C
	db $00,$00,$FC,$31,$6C
.plasma_wave_s08
	dw $000C
	db $E9,$01,$FE,$32,$6C
	db $F1,$01,$FE,$31,$6C
	db $F9,$01,$EE,$32,$6C
	db $01,$00,$EE,$31,$6C
	db $F1,$01,$F6,$32,$6C
	db $F9,$01,$F6,$31,$6C
	db $F6,$01,$0A,$32,$6C
	db $FE,$01,$0A,$31,$6C
	db $06,$00,$FA,$32,$6C
	db $0E,$00,$FA,$31,$6C
	db $FE,$01,$02,$32,$6C
	db $06,$00,$02,$31,$6C
.plasma_wave_s09
	dw $000C
	db $E6,$01,$FB,$32,$6C
	db $EE,$01,$FB,$31,$6C
	db $F6,$01,$EB,$32,$6C
	db $FE,$01,$EB,$31,$6C
	db $EE,$01,$F3,$32,$6C
	db $F6,$01,$F3,$31,$6C
	db $F9,$01,$0D,$32,$6C
	db $01,$00,$0D,$31,$6C
	db $09,$00,$FD,$32,$6C
	db $11,$00,$FD,$31,$6C
	db $01,$00,$05,$32,$6C
	db $09,$00,$05,$31,$6C
.plasma_wave_s10
	dw $000C
	db $E4,$01,$F9,$32,$6C
	db $EC,$01,$F9,$31,$6C
	db $F4,$01,$E9,$32,$6C
	db $FC,$01,$E9,$31,$6C
	db $EC,$01,$F1,$32,$6C
	db $F4,$01,$F1,$31,$6C
	db $FB,$01,$0F,$32,$6C
	db $03,$00,$0F,$31,$6C
	db $0B,$00,$FF,$32,$6C
	db $13,$00,$FF,$31,$6C
	db $03,$00,$07,$32,$6C
	db $0B,$00,$07,$31,$6C
.plasma_wave_s11
	dw $000C
	db $E3,$01,$F8,$32,$6C
	db $EB,$01,$F8,$31,$6C
	db $F3,$01,$E8,$32,$6C
	db $FB,$01,$E8,$31,$6C
	db $EB,$01,$F0,$32,$6C
	db $F3,$01,$F0,$31,$6C
	db $FC,$01,$10,$32,$6C
	db $04,$00,$10,$31,$6C
	db $0C,$00,$00,$32,$6C
	db $14,$00,$00,$31,$6C
	db $04,$00,$08,$32,$6C
	db $0C,$00,$08,$31,$6C
.plasma_wave_s12
	dw $0001
	db $FC,$01,$FC,$30,$2C
.plasma_wave_s13
	dw $0004
	db $08,$00,$FC,$30,$2C
	db $00,$00,$FC,$30,$2C
	db $F8,$01,$FC,$30,$2C
	db $F0,$01,$FC,$30,$2C
.plasma_wave_s14
	dw $0008
	db $08,$00,$04,$30,$2C
	db $00,$00,$04,$30,$2C
	db $F8,$01,$04,$30,$2C
	db $F0,$01,$04,$30,$2C
	db $08,$00,$F4,$30,$2C
	db $00,$00,$F4,$30,$2C
	db $F8,$01,$F4,$30,$2C
	db $F0,$01,$F4,$30,$2C
.plasma_wave_s15
	dw $0008
	db $08,$00,$09,$30,$2C
	db $00,$00,$09,$30,$2C
	db $F8,$01,$09,$30,$2C
	db $F0,$01,$09,$30,$2C
	db $08,$00,$EF,$30,$2C
	db $00,$00,$EF,$30,$2C
	db $F8,$01,$EF,$30,$2C
	db $F0,$01,$EF,$30,$2C
.plasma_wave_s16
	dw $0008
	db $08,$00,$0B,$30,$2C
	db $00,$00,$0B,$30,$2C
	db $F8,$01,$0B,$30,$2C
	db $F0,$01,$0B,$30,$2C
	db $08,$00,$ED,$30,$2C
	db $00,$00,$ED,$30,$2C
	db $F8,$01,$ED,$30,$2C
	db $F0,$01,$ED,$30,$2C
.plasma_wave_s17
	dw $0008
	db $08,$00,$0C,$30,$2C
	db $00,$00,$0C,$30,$2C
	db $F8,$01,$0C,$30,$2C
	db $F0,$01,$0C,$30,$2C
	db $08,$00,$EC,$30,$2C
	db $00,$00,$EC,$30,$2C
	db $F8,$01,$EC,$30,$2C
	db $F0,$01,$EC,$30,$2C
.plasma_wave_s18
	dw $0002
	db $00,$00,$FC,$32,$2C
	db $F8,$01,$FC,$31,$2C
.plasma_wave_s19
	dw $0006
	db $08,$00,$04,$32,$2C
	db $00,$00,$04,$31,$2C
	db $F8,$01,$F4,$32,$2C
	db $F0,$01,$F4,$31,$2C
	db $00,$00,$FC,$32,$2C
	db $F8,$01,$FC,$31,$2C
.plasma_wave_s20
	dw $000C
	db $0F,$00,$FE,$32,$2C
	db $07,$00,$FE,$31,$2C
	db $FF,$01,$EE,$32,$2C
	db $F7,$01,$EE,$31,$2C
	db $07,$00,$F6,$32,$2C
	db $FF,$01,$F6,$31,$2C
	db $02,$00,$0A,$32,$2C
	db $FA,$01,$0A,$31,$2C
	db $F2,$01,$FA,$32,$2C
	db $EA,$01,$FA,$31,$2C
	db $FA,$01,$02,$32,$2C
	db $F2,$01,$02,$31,$2C
.plasma_wave_s21
	dw $000C
	db $12,$00,$FB,$32,$2C
	db $0A,$00,$FB,$31,$2C
	db $02,$00,$EB,$32,$2C
	db $FA,$01,$EB,$31,$2C
	db $0A,$00,$F3,$32,$2C
	db $02,$00,$F3,$31,$2C
	db $FF,$01,$0D,$32,$2C
	db $F7,$01,$0D,$31,$2C
	db $EF,$01,$FD,$32,$2C
	db $E7,$01,$FD,$31,$2C
	db $F7,$01,$05,$32,$2C
	db $EF,$01,$05,$31,$2C
.plasma_wave_s22
	dw $000C
	db $14,$00,$F9,$32,$2C
	db $0C,$00,$F9,$31,$2C
	db $04,$00,$E9,$32,$2C
	db $FC,$01,$E9,$31,$2C
	db $0C,$00,$F1,$32,$2C
	db $04,$00,$F1,$31,$2C
	db $FD,$01,$0F,$32,$2C
	db $F5,$01,$0F,$31,$2C
	db $ED,$01,$FF,$32,$2C
	db $E5,$01,$FF,$31,$2C
	db $F5,$01,$07,$32,$2C
	db $ED,$01,$07,$31,$2C
.plasma_wave_s23
	dw $000C
	db $15,$00,$F8,$32,$2C
	db $0D,$00,$F8,$31,$2C
	db $05,$00,$E8,$32,$2C
	db $FD,$01,$E8,$31,$2C
	db $0D,$00,$F0,$32,$2C
	db $05,$00,$F0,$31,$2C
	db $FC,$01,$10,$32,$2C
	db $F4,$01,$10,$31,$2C
	db $EC,$01,$00,$32,$2C
	db $E4,$01,$00,$31,$2C
	db $F4,$01,$08,$32,$2C
	db $EC,$01,$08,$31,$2C