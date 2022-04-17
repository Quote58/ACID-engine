;Modifiers are formatted like this:
;db $YY				-	YY = how many groups of tiles to modify
;db $XX				-	XX = how many tiles in current group
;dw $IIII			-	IIII = index into the equip screen tilemap
;dw $TTTT, $TTTT	-	TTTT = tile value to replace with

;Simple format is useful if there are a number of single tiles to replace at various locations (ie. screw attack)
;Group format is useful if there are groups of tiles in sequence to replace (ie. hijump boots saves about 8 bytes this way)
;All indexes into the equip tilemap begin at the start of the samus tilemap

.hijump
	db $02
	db $05 : dw $0344, $31E9, $31EA, $31EB, $31EC, $31ED
	db $06 : dw $0382, $31F8, $31F9, $31FA, $31FB, $31FC, $31FD

.speed
	db $03
	db $04 : dw $0286, $31D4, $31D5, $31D6, $31D7
	db $04 : dw $02C6, $31E4, $31E5, $31E6, $31E7
	db $04 : dw $0306, $31F4, $31F5, $31F6, $31F7

.spacejump
	db $02
	db $04 : dw $0104, $3167, $3168, $3169, $316A
	db $04 : dw $0144, $3177, $3178, $3179, $317A

.charge
	db $04
	db $03 : dw $0180, $3D96, $3D87, $3D88
	db $03 : dw $01C0, $3DA6, $3D97, $3D98
	db $02 : dw $0202, $3DA7, $3DA8
	db $02 : dw $0242, $3DB7, $3DB8

.cannon
	db $02
	db $02 : dw $0202, $3D9D, $3D9E
	db $02 : dw $0242, $3DBB, $3DBC

.cannon_charge
	db $02
	db $02 : dw $0202, $3DAD, $3DAE
	db $02 : dw $0242, $3DBD, $3DBE