lorom

macro bounce()
	dw normal, lower, normal, higher, normal, lower, normal, higher
endmacro

macro no_bounce()
	rep 8 : dw normal
endmacro

macro morph_animate_up()				;xkas can't use multi line variables, so these are macros instead
	db $0A,$00,$00,$00
	db $0A,$01,$00,$00
	db $0A,$02,$00,$00
	db $0A,$03,$00,$00
	db $0A,$04,$00,$00
	db $0A,$05,$00,$00
	db $0A,$06,$00,$00
	db $0A,$07,$00,$00
endmacro

macro morph_animate_down()
	db $0A,$07,$00,$00
	db $0A,$06,$00,$00
	db $0A,$05,$00,$00
	db $0A,$04,$00,$00
	db $0A,$03,$00,$00
	db $0A,$02,$00,$00
	db $0A,$01,$00,$00
	db $0A,$00,$00,$00
endmacro

; --- Black Falcon (rewritten for readability by Quote58) ---
; this changes the animation for the morphball to use a more logical arrangement in rom

org $92D9B2 : db $30					;fixing the old no springball falling left error
org $91B378 : REP 8 : DB $04
org $92D613								;location data for moving sprites to vram
	DL $9C8000 : dw $0060,$0040
	DL $9C80A0 : dw $0060,$0040
	DL $9C8140 : dw $0060,$0040
	DL $9C81E0 : dw $0060,$0040	
	DL $9C8280 : dw $0060,$0040
	DL $9C8320 : dw $0060,$0040
	DL $9C83C0 : dw $0060,$0040
	DL $9C8460 : dw $0060,$0040

org $92BAB3
normal: dw $0002 : %oam(f8,01,f8,02,28)	;sprite data for standard position
				   %oam(f8,c3,f8,00,28)
org $92BAE3
higher: dw $0002 : %oam(f8,01,f8,02,28)	;sprite data for one pixel higher than standard
				   %oam(f8,c3,f7,00,28)
org $92BABF
lower:  dw $0002 : %oam(f8,01,f8,02,28)	;sprite data for one pixel lower than standard
				   %oam(f8,c3,f9,00,28)

org $928EAD : %bounce()
org $928EC1 : %bounce()
org $928ED5 : %bounce()
org $928EE9 : %bounce()
org $928EFD : %bounce()
org $928F11 : %bounce()

org $92E5A8	: %morph_animate_up()		;spring ball facing right
org $92E5D0	: %morph_animate_down()		;springball left
org $92E508	: %morph_animate_up()		;morphball on ground and midair right
org $92E530	: %morph_animate_down()		;morphball on ground and midair left
org $92E558	: %morph_animate_up()		;morphball moving right
org $92E580 : %morph_animate_down()		;morphball moving left

; --- Quote58 ---
; spritemaps for samus air bubbles, adjusted for extra beam space
org $92D7DD : db $CF
org $92D7E4 : db $CF
org $92D7F5 : db $CF
org $92D806 : db $CF
org $92D80B : db $CF
org $92D810 : db $CF
org $92D817 : db $CE
org $92D81C : db $CE
org $92D821 : db $CF
org $92D828 : db $CE
org $92D82D : db $CE
org $92D832 : db $CE
org $92D839 : db $CE
org $92D83E : db $CE
org $92D843 : db $CE
org $92D84A : db $CE
org $92D84F : db $CE
org $92D856 : db $CE
org $929126 : db $CF
org $92C5FA : db $CF
org $92C931 : db $CF
org $92C58A : db $CE
org $92C8C1 : db $CE

org $92EDF4
; free space in bank $92

print "End of free space (92FFFF): ", pc















