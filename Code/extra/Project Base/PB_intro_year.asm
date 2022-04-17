org $8BA0EF : dw $9CBC, $9CCF, #Intro_year	;the spritemap for the intro year sprite when booting up the game was repointed

; --- Quote58 ---
; the tilemaps referenced here can be found in 8C
Intro_year:
	dw $003C,$0000
	dw $0008,$8862
	dw $0008,$886E
	dw $0008,$8884
	dw $0008,$88A4
	dw $0008,Intro_cinematic_sprite_year_dash
	dw $0008,Intro_cinematic_sprite_year_2
	dw $0008,Intro_cinematic_sprite_year_20
	dw $0008,Intro_cinematic_sprite_year_202
	dw $002D,Intro_cinematic_sprite_year_2020
	dw $9CE1
	dw $9438




; in 8c

; this is the 1994 sprite in the title screen opening
; it has been expanded to say 1994-2020

; these are the original 1994 spritemaps (adjusted in location to accomodate the extra numbers)
; --- Quote58 ---
org $8C8862 : dw $0002 : %oam(18,00,00,10,33)
						 %oam(18,00,F8,00,33)

org $8C886E : dw $0004 : %oam(10,00,00,10,33)
						 %oam(10,00,F8,00,33)
						 %oam(18,00,00,76,33)
						 %oam(18,00,F8,66,33)

org $8C8884 : dw $0006 : %oam(08,00,00,10,33)
						 %oam(08,00,F8,00,33)
						 %oam(10,00,00,76,33)
						 %oam(10,00,F8,66,33)
						 %oam(18,00,00,76,33)
						 %oam(18,00,F8,66,33)

org $8C88A4 : dw $0008 : %oam(00,00,00,10,33)
						 %oam(00,00,F8,00,33)
						 %oam(08,00,00,76,33)
						 %oam(08,00,F8,66,33)
						 %oam(10,00,00,76,33)
						 %oam(10,00,F8,66,33)
						 %oam(18,00,00,30,33)
						 %oam(18,00,F8,20,33)


; in free space
; and these are the 2020 spritemaps + '1994' + '-'
; the final 0 is marked with *** so that you can easily change it to reflect whenever your project is released
; --- Quote58 ---
Intro_cinematic_sprite:
.year_dash : dw $0009 : %oam(F8,01,00,10,33)
						%oam(F8,01,F8,00,33)
						%oam(00,00,00,76,33)
						%oam(00,00,F8,66,33)
						%oam(08,00,00,76,33)
						%oam(08,00,F8,66,33)
						%oam(10,00,00,30,33)
						%oam(10,00,F8,20,33)
						%oam(18,00,FC,CF,33)
.year_2    : dw $000B : %oam(F0,01,00,10,33)
						%oam(F0,01,F8,00,33)
						%oam(F8,01,00,76,33)
						%oam(F8,01,F8,66,33)
						%oam(00,00,00,76,33)
						%oam(00,00,F8,66,33)
						%oam(08,00,00,30,33)
						%oam(08,00,F8,20,33)
						%oam(10,00,FC,CF,33)
						%oam(18,00,F8,EF,33)
						%oam(18,00,00,FF,33)
.year_20   : dw $000D : %oam(E8,01,00,10,33)
						%oam(E8,01,F8,00,33)
						%oam(F0,01,00,76,33)
						%oam(F0,01,F8,66,33)
						%oam(F8,01,00,76,33)
						%oam(F8,01,F8,66,33)
						%oam(00,00,00,30,33)
						%oam(00,00,F8,20,33)
						%oam(08,00,FC,CF,33)
						%oam(10,00,F8,EF,33)
						%oam(10,00,00,FF,33)
						%oam(18,00,F8,8C,33)
						%oam(18,00,00,9C,33)
.year_202  : dw $000F : %oam(E0,01,00,10,33)
						%oam(E0,01,F8,00,33)
						%oam(E8,01,00,76,33)
						%oam(E8,01,F8,66,33)
						%oam(F0,01,00,76,33)
						%oam(F0,01,F8,66,33)
						%oam(F8,01,00,30,33)
						%oam(F8,01,F8,20,33)
						%oam(00,00,FC,CF,33)
						%oam(08,00,F8,EF,33)
						%oam(08,00,00,FF,33)
						%oam(10,00,F8,8C,33)
						%oam(10,00,00,9C,33)
						%oam(18,00,F8,EF,33)
						%oam(18,00,00,FF,33)
.year_2020 : dw $0011 : %oam(D8,01,00,10,33)
						%oam(D8,01,F8,00,33)
						%oam(E0,01,00,76,33)
						%oam(E0,01,F8,66,33)
						%oam(E8,01,00,76,33)
						%oam(E8,01,F8,66,33)
						%oam(F0,01,00,30,33)
						%oam(F0,01,F8,20,33)
						%oam(F8,01,FC,CF,33)
						%oam(00,00,F8,EF,33)
						%oam(00,00,00,FF,33)
						%oam(08,00,F8,8C,33)
						%oam(08,00,00,9C,33)
						%oam(10,00,F8,EF,33)
						%oam(10,00,00,FF,33)
						%oam(18,00,F8,8C,33)		;*** top of the final 0 ***
						%oam(18,00,00,9C,33)		;*** bottom of the final 0 ***