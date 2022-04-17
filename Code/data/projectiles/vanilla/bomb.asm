.bomb_slow
	dw $0005,.bomb_s00,$0404,$0000
	dw $0005,.bomb_s01,$0404,$0000
	dw $0005,.bomb_s02,$0404,$0000
	dw $0005,.bomb_s03,$0404,$0000
	dw $8239,.bomb_slow

.bomb_fast
	dw $0001,.bomb_s00,$0404,$0000
	dw $0001,.bomb_s01,$0404,$0000
	dw $0001,.bomb_s02,$0404,$0000
	dw $0001,.bomb_s03,$0404,$0000
	dw $8239,.bomb_fast

.bomb_s00
	dw $0001
	db $FC,$01,$FC,$4C,$3A
.bomb_s01
	dw $0001
	db $FC,$01,$FC,$4D,$3A
.bomb_s02
	dw $0001
	db $FC,$01,$FC,$4E,$3A
.bomb_s03
	dw $0001
	db $FC,$01,$FC,$4F,$3A