;table of sprite data pointers
	dw .beam, .suit, .misc, .boots ;03
	dw .button_outline, .button_outline_alt, .button_A, .button_B, .button_X, .button_Y, .button_L, .button_R, .button_S, .button_OFF ;0D
	dw .digit_0, .digit_1, .digit_2, .digit_3, .digit_4, .digit_5, .digit_6, .digit_7, .digit_8, .digit_9 ;17
	dw .colon, .clock, .period, .percent, .tanks, .check, .backdrop_timer, .backdrop_percent ;1F
	dw .s_digit_0, .s_digit_1, .s_digit_2, .s_digit_3, .s_digit_4, .s_digit_5, .s_digit_6, .s_digit_7, .s_digit_8, .s_digit_9 ;29
	dw .s_slash, .s_percent, .s_period, .tanks_backdrop, .item_dot_missile ;2E
	dw .scroll_bar, .more_info, .debug_select, .debug_dpad, .debug_next, .debug_prev
	
;sprite data for the line that is drawn from the list to samus for each of the relevant lists
.beam  : dw $0007 : %oam(00,00,00,51,30)
				    %oam(03,00,00,51,30)
				    %oam(FC,01,FB,53,70)
				    %oam(F4,01,FB,54,70)
				    %oam(F4,01,F3,53,70)
				    %oam(EC,01,F3,52,70)
				    %oam(04,00,00,50,30)
				   
.suit  : dw $0009 : %oam(00,00,00,51,30)
				    %oam(04,00,00,51,30)
				    %oam(08,00,00,51,30)
				    %oam(0C,00,00,54,30)
				    %oam(0C,00,F8,53,30)
				    %oam(14,00,F8,54,30)
				    %oam(13,00,F1,53,30)
				    %oam(1B,00,F1,52,30)
				    %oam(FA,01,00,50,30)
				   
.misc  : dw $000A : %oam(00,00,00,51,30)
				    %oam(14,00,10,51,30)
				    %oam(18,00,10,51,30)
				    %oam(1A,00,10,51,30)
				    %oam(1D,00,10,52,30)
				    %oam(04,00,00,54,B0)
				    %oam(04,00,08,53,B0)
				    %oam(0C,00,08,54,B0)
				    %oam(0C,00,10,53,B0)
				    %oam(FA,01,00,50,30)

.boots : dw $0005 : %oam(00,00,00,54,30)
				    %oam(00,00,F8,53,30)
					%oam(06,00,FA,54,30)
					%oam(0A,00,F6,52,30)
					%oam(FA,01,02,50,30)
					
.button_outline : dw $0008 : %oam(00,00,00,C8,30)
							 %oam(08,00,00,C9,30)
							 %oam(10,00,00,C8,70)
							 %oam(00,00,08,CA,30)
							 %oam(10,00,08,CA,70)
							 %oam(00,00,10,C8,B0)
							 %oam(08,00,10,C9,B0)
							 %oam(10,00,10,C8,F0)

.button_outline_alt : dw $0008 : %oam(00,00,00,CB,30)
								 %oam(08,00,00,CC,30)
								 %oam(10,00,00,CB,70)
								 %oam(00,00,08,CD,30)
								 %oam(10,00,08,CD,70)
								 %oam(00,00,10,CB,B0)
								 %oam(08,00,10,CC,B0)
								 %oam(10,00,10,CB,F0)

.button_A : dw $0001 : %oam(08,00,08,C0,30)
.button_B : dw $0001 : %oam(08,00,08,C1,30)
.button_X : dw $0001 : %oam(08,00,08,C2,30)
.button_Y : dw $0001 : %oam(08,00,08,C3,30)
.button_L : dw $0001 : %oam(08,00,08,C4,30)
.button_R : dw $0001 : %oam(08,00,08,C5,30)
.button_S : dw $0002 : %oam(04,00,08,C6,30)
					   %oam(0C,00,08,C7,30)
					   
.button_OFF : dw $0003 : %oam(01,00,08,78,30)
						 %oam(09,00,08,6F,30)
						 %oam(11,00,08,6F,30)

.digit_0 : dw $0001 : %oam(00,00,00,60,30)
.digit_1 : dw $0001 : %oam(00,00,00,61,30)
.digit_2 : dw $0001 : %oam(00,00,00,62,30)
.digit_3 : dw $0001 : %oam(00,00,00,63,30)
.digit_4 : dw $0001 : %oam(00,00,00,64,30)
.digit_5 : dw $0001 : %oam(00,00,00,65,30)
.digit_6 : dw $0001 : %oam(00,00,00,66,30)
.digit_7 : dw $0001 : %oam(00,00,00,67,30)
.digit_8 : dw $0001 : %oam(00,00,00,68,30)
.digit_9 : dw $0001 : %oam(00,00,00,69,30)
.period  : dw $0001 : %oam(00,00,00,88,30)

.s_digit_0 : dw $0001 : %oam(00,00,00,40,30)
.s_digit_1 : dw $0001 : %oam(00,00,00,41,30)
.s_digit_2 : dw $0001 : %oam(00,00,00,42,30)
.s_digit_3 : dw $0001 : %oam(00,00,00,43,30)
.s_digit_4 : dw $0001 : %oam(00,00,00,44,30)
.s_digit_5 : dw $0001 : %oam(00,00,00,45,30)
.s_digit_6 : dw $0001 : %oam(00,00,00,46,30)
.s_digit_7 : dw $0001 : %oam(00,00,00,47,30)
.s_digit_8 : dw $0001 : %oam(00,00,00,48,30)
.s_digit_9 : dw $0001 : %oam(00,00,00,49,30)
.s_slash   : dw $0001 : %oam(00,00,00,4A,30)
.s_percent : dw $0001 : %oam(00,00,00,4B,30)
.s_period  : dw $0001 : %oam(00,00,00,4C,30)

.clock : dw $0002 : %oam(FC,01,FF,36,30)
					%oam(04,00,FF,37,30)

.backdrop_timer
	dw $000A : %oam(00,00,FF,8E,30)
			   %oam(04,00,FF,8E,30)
			   %oam(0C,00,FF,8E,30)
			   %oam(14,00,FF,8E,30)
			   %oam(1C,00,FF,8E,30)
			   %oam(24,00,FF,8E,30)
			   %oam(2C,00,FF,8E,30)
			   %oam(34,00,FF,8E,30)
			   %oam(3C,00,FF,8E,30)
			   %oam(44,00,FF,8E,30)

.backdrop_percent
	dw $0007 : %oam(FC,01,00,8E,30)
			   %oam(04,00,00,8E,30)
			   %oam(0C,00,00,8E,30)
			   %oam(14,00,00,8E,30)
			   %oam(1C,00,00,8E,30)
			   %oam(24,00,00,8E,30)
			   %oam(2C,00,00,8E,30)

.colon   : dw $0001 : %oam(00,00,00,89,30)
.percent : dw $0001 : %oam(00,00,00,8A,30)

.check   : dw $0001 : %oam(00,00,00,35,30)

.tanks   : dw $0005 : %oam(00,00,00,30,30)
					  %oam(00,00,09,31,30)
					  %oam(00,00,12,32,30)
					  %oam(00,00,1B,33,30)
					  %oam(00,00,24,34,30)

.tanks_backdrop
	dw $0009 : %oam(00,00,00,8E,30)
			   %oam(00,00,01,8E,30)
			   %oam(00,00,09,8E,30)
			   %oam(00,00,0A,8E,30)
			   %oam(00,00,12,8E,30)
			   %oam(00,00,13,8E,30)
			   %oam(00,00,1B,8E,30)
			   %oam(00,00,1C,8E,30)
			   %oam(00,00,24,8E,30)

.item_dot_missile : dw $0001 : %oam(00,00,00,D8,30)

.scroll_bar : dw $0001 : %oam(00,00,FC,96,30)

.more_info : dw $0006 : %oam(00,00,00,B9,30)
						%oam(08,00,00,BA,30)
						%oam(10,00,00,BB,30)
						%oam(18,00,00,BC,30)
						%oam(20,00,00,BD,30)
						%oam(28,00,00,BE,30)

.debug_select  : dw $001A : %oam(00,00,FB,95,34)
							%oam(00,00,03,92,34)
							%oam(08,00,FB,92,34)
							%oam(08,00,03,92,34)
							%oam(10,00,FB,92,34)
							%oam(10,00,03,92,34)
							%oam(18,00,FB,92,34)
							%oam(18,00,03,92,34)
							%oam(20,00,FB,92,34)
							%oam(20,00,03,92,34)
							%oam(28,00,FB,92,34)
							%oam(28,00,03,92,34)
							%oam(30,00,FB,92,34)
							%oam(30,00,03,92,34)
							%oam(38,00,FB,92,34)
							%oam(38,00,03,92,34)
							%oam(40,00,FB,92,34)
							%oam(40,00,03,92,34)
							%oam(48,00,FB,92,34)
							%oam(48,00,03,92,34)
							%oam(50,00,FB,92,34)
							%oam(50,00,03,92,34)
							%oam(58,00,FB,92,34)
							%oam(58,00,03,92,34)
							%oam(60,00,FB,93,34)
							%oam(60,00,03,94,34)

.debug_dpad : dw $0008 : %oam(00,00,00,50,34)
						 %oam(08,00,00,50,74)
						 %oam(00,00,08,50,B4)
						 %oam(08,00,08,50,F4)
						 %oam(10,00,04,51,34)
						 %oam(18,00,04,52,34)
						 %oam(20,00,04,53,34)
						 %oam(28,00,04,54,34)

.debug_next : dw $0004 : %oam(00,00,00,55,34)
						 %oam(08,00,00,56,34)
						 %oam(10,00,00,57,34)
						 %oam(18,00,00,58,34)

.debug_prev : dw $0006 : %oam(00,00,00,59,34)
						 %oam(08,00,00,5A,34)
						 %oam(10,00,00,5B,34)
						 %oam(18,00,00,5C,34)
						 %oam(20,00,00,5D,34)
						 %oam(28,00,00,5E,34)















































