; ::: spritemaps that needed to be rewritten because of gfx being moved :::
Pause_spritemaps_vanilla:
org $82CF7C
; Map cursor (3 frames, sprites 5F, 60, 61)
.cursor_1 : dw $0004 : %oam(04,00,04,28,EE)
					   %oam(FC,01,04,28,AE)
					   %oam(04,00,FC,28,6E)
				   	   %oam(FC,01,FC,28,2E)

.cursor_2 : dw $0004 : %oam(05,00,05,28,EE)
					   %oam(FB,01,05,28,AE)
					   %oam(05,00,FB,28,6E)
				   	   %oam(FB,01,FB,28,2E)

.cursor_3 : dw $0004 : %oam(06,00,06,28,EE)
					   %oam(FA,01,06,28,AE)
					   %oam(06,00,FA,28,6E)
				   	   %oam(FA,01,FA,28,2E)

org $82C4DB
; Elevator designations (1 frame, sprites 59-5C)
.crateria : dw $0004 : %oam(10,00,F8,03,20)
					   %oam(08,00,F8,02,20)
					   %oam(00,00,F8,01,20)
					   %oam(F8,01,F8,00,20)

.brinstar : dw $0004 : %oam(10,00,F8,07,20)
					   %oam(08,00,F8,06,20)
					   %oam(00,00,F8,05,20)
					   %oam(F8,01,F8,04,20)

.norfair  : dw $0004 : %oam(10,00,F8,0B,20)
					   %oam(08,00,F8,0A,20)
					   %oam(00,00,F8,09,20)
					   %oam(F8,01,F8,08,20)

.tourian  : dw $0004 : %oam(10,00,F8,19,20)
					   %oam(08,00,F8,18,20)
					   %oam(00,00,F8,17,20)
					   %oam(F8,01,F8,16,20)

.maridia  : dw $0004 : %oam(10,00,F8,0F,20)
					   %oam(08,00,F8,0E,20)
					   %oam(00,00,F8,0D,20)
					   %oam(F8,01,F8,0C,20)

.w_ship   : dw $0006 : %oam(04,00,00,15,20)
					   %oam(FC,01,00,14,20)
					   %oam(0C,00,F8,13,20)
					   %oam(04,00,F8,12,20)
					   %oam(FC,01,F8,11,20)
					   %oam(F4,01,F8,10,20)

; Map scrolling arrows (1 frame, sprites 4,5,6,7)
org $82C232
.arrow_up 	 : dw $0002 : %oam(FF,01,FC,29,F4)
						  %oam(F8,01,FC,29,B4)

.arrow_down  : dw $0002 : %oam(FF,01,FC,29,74)
						  %oam(F8,01,FC,29,34)

.arrow_left  : dw $0002 : %oam(FC,01,00,2A,F4)
						  %oam(FC,01,F9,2A,74)

.arrow_right : dw $0002 : %oam(FC,01,00,2A,B4)
						  %oam(FC,01,F9,2A,34)

; Selection dot (1 frame, sprite 14)
org $82C29F
.selection_dot : dw $0001 : %oam(FC,01,FC,90,36)

; Selection dot with box for equip screen (1 frame, sprites 15 and 16)
org $82C2B7
.selection_box : dw $000C : %oam(10,00,04,92,34)
							%oam(10,00,FC,92,34)
							%oam(F0,01,04,92,34)
							%oam(F8,01,04,92,34)
							%oam(00,00,04,92,34)
							%oam(08,00,04,92,34)
							%oam(18,00,04,94,34)
							%oam(18,00,FC,93,34)
							%oam(08,00,FC,92,34)
							%oam(00,00,FC,92,34)
							%oam(F8,01,FC,92,34)
							%oam(F0,01,FC,91,34)

.selection_big : dw $0014 : %oam(1C,00,04,92,34)
							%oam(1C,00,FC,92,34)
							%oam(04,00,04,92,34)
							%oam(14,00,04,92,34)
							%oam(0C,00,04,92,34)
							%oam(14,00,FC,92,34)
							%oam(0C,00,FC,92,34)
							%oam(04,00,FC,92,34)
							%oam(FC,01,04,92,34)
							%oam(FC,01,FC,92,34)
							%oam(DC,01,04,92,34)
							%oam(E4,01,04,92,34)
							%oam(EC,01,04,92,34)
							%oam(F4,01,04,92,34)
							%oam(24,00,04,94,34)
							%oam(24,00,FC,93,34)
							%oam(F4,01,FC,92,34)
							%oam(EC,01,FC,92,34)
							%oam(E4,01,FC,92,34)
							%oam(DC,01,FC,91,34)

; L and R button sprites (1 frame each, sprites 28, 29)
org $82C48F
.button_l : dw $0003 : %oam(F4,01,FC,A4,34)
					   %oam(FC,01,FC,A5,34)
					   %oam(04,00,FC,A6,34)
					   
.button_r : dw $0003 : %oam(F4,01,FC,A4,34)
					   %oam(FC,01,FC,A7,34)
					   %oam(04,00,FC,A6,34)

; L and R button outline thing (1 frame, sprite 2A)
org $82C465
.button_outline : dw $0008 : %oam(08,00,00,A0,74)
							 %oam(00,00,00,A1,34)
							 %oam(F8,01,00,A1,34)
							 %oam(F0,01,00,A0,34)
							 %oam(00,00,F8,A3,74)
							 %oam(08,00,F8,A2,74)
							 %oam(F8,01,F8,A3,34)
							 %oam(F0,01,F8,A2,34)

; START button (1 frame, sprite 2B)
org $82C4B1
.button_start : dw $0008 : %oam(08,00,00,AB,34)
						   %oam(00,00,00,AA,34)
						   %oam(F8,01,00,A9,34)
						   %oam(F0,01,00,A8,34)
						   %oam(00,00,F8,9A,34)
						   %oam(F8,01,F8,99,34)
						   %oam(08,00,F8,98,74)
						   %oam(F0,01,F8,98,34)

; Boss Defeated icon (1 frame, sprite 62)
org $82CFBE
.icon_boss_defeated : dw $0004 : %oam(03,00,04,27,EE)
								 %oam(03,00,FC,27,6E)
								 %oam(FC,01,04,27,AE)
								 %oam(FC,01,FC,27,2E)

; various icons (1 frame each)
org $82C298
.icon_samus   : dw $0001 : %oam(01,00,00,21,2E) ;12

org $82C385
.icon_save    : dw $0001 : %oam(01,00,00,25,20) ;8
.icon_boss    : dw $0001 : %oam(01,00,00,22,20) ;9
.icon_energy  : dw $0001 : %oam(01,00,00,24,20) ;A
.icon_missile : dw $0001 : %oam(01,00,00,23,20) ;B
.icon_map     : dw $0001 : %oam(01,00,00,26,20) ;4E <-?

; ship icon (1 frame, sprite 63)
org $82CFD4
.icon_ship    : dw $0002 : %oam(04,00,FE,20,6E)
						   %oam(FC,01,FE,20,2E)
