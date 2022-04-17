.reserve_cycle : dw .auto, .manual
.mode 		   : dw $2E00, $2E01, $2E02											 ;mode
.timer		   : dw $2E10, $2E11, $2E12											 ;timer
.manual 	   : dw $2A04, $2A05, $2A06, $2A07									 ;[manual]
.auto  		   : dw $2A08, $2A09, $2A0A, $2A0B									 ;[auto]
.shells		   : dw $0A35, $0A35, $0A35, $0A35, $0A35, $0A35, $0A35, $0A36		 ;empty reserve tank shells (the amount of this used is calculated from !C_Reserves_total, so it will draw shells for up to and including 7)
.charge  	   : dw $08E3, $08E4, $08E5, $08E6							 		 ;charge
.ice 		   : dw $08E7, $08E8, $08E1, $08E1							 		 ;ice
.wave 		   : dw $08E9, $08EA, $08EB, $08E1							 		 ;wave
.spazer 	   : dw $08EC, $08ED, $08EE, $08EF							 		 ;spazer
.plasma 	   : dw $08F0, $08F1, $08F2, $08F3							 		 ;plasma
.varia  	   : dw $0920, $0921, $0922, $0927, $0928, $0929, $08E1, $08E1 		 ;Varia suit
.gravity 	   : dw $0923, $0924, $0925, $0926, $0927, $0928, $0929, $08E1 		 ;Gravity suit
.morph 		   : dw $08F4, $08F5, $08F6, $08F7, $092A, $092B, $092C, $08E1		 ;morphball
.bombs 		   : dw $08F8, $08F9, $08FA, $08FB, $08E1, $08E1, $08E1, $08E1		 ;Bomb
.spring 	   : dw $08FC, $08FD, $08FE, $08FF, $092A, $092B, $092C, $08E1		 ;Springball
.screw 		   : dw $0903, $0904, $0905, $0906, $0907, $0908, $0909, $08E1		 ;screw attack
.hi_jump 	   : dw $090A, $090B, $090C, $090D, $090E, $08E1, $08E1, $08E1		 ;high jump boots
.space_jump    : dw $0910, $0911, $0912, $0913, $0914, $0915, $08E1, $08E1		 ;space jump
.speed_booster : dw $0916, $0917, $0918, $0919, $091A, $091B, $091C, $091D		 ;speed booster
.hyper 		   : dw $0930, $0931, $0932, $0933, $08E1, $08E1, $08E1, $08E1		 ;hyper