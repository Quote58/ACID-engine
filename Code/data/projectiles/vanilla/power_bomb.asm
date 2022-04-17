.power_bomb_slow
	dw $0005,.power_s00,$0404,$0000
	dw $0005,.power_s01,$0404,$0000
	dw $0005,.power_s02,$0404,$0000
	dw $8239,.power_bomb_slow

.power_bomb_fast
	dw $0001,.power_s00,$0404,$0000
	dw $0001,.power_s01,$0404,$0000
	dw $0001,.power_s02,$0404,$0000
	dw $8239,.power_bomb_fast

.power_s00
	dw $0001
	db $FC,$01,$FC,$26,$3A
.power_s01
	dw $0001
	db $FC,$01,$FC,$27,$3A
.power_s02
	dw $0001
	db $FC,$01,$FC,$7B,$3A