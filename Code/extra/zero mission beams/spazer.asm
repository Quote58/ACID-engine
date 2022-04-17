.spazer
%beam_table("spazer", $0014)
%beam_frame_3("spazer_up", 			$02, $0404, $0404, $0404)
%beam_frame_3("spazer_up_right", 	$02, $0404, $0404, $0404)
%beam_frame_3("spazer_right", 		$02, $0404, $0404, $0404)
%beam_frame_3("spazer_down_right",	$02, $0404, $0404, $0404)
%beam_frame_3("spazer_down", 		$02, $0404, $0404, $0404)
%beam_frame_3("spazer_down_left", 	$02, $0404, $0404, $0404)
%beam_frame_3("spazer_left", 		$02, $0404, $0404, $0404)
%beam_frame_3("spazer_up_left", 	$02, $0404, $0404, $0404)
.spazer_up_s
.spazer_up_s1
.spazer_up_s2

.spazer_up_right_s
.spazer_up_right_s1
.spazer_up_right_s2

.spazer_right_s
.spazer_right_s1
.spazer_right_s2

.spazer_down_right_s
.spazer_down_right_s1
.spazer_down_right_s2

.spazer_down_s
.spazer_down_s1
.spazer_down_s2

.spazer_down_left_s
.spazer_down_left_s1
.spazer_down_left_s2

.spazer_left_s
dw $0002
db $F8,$01,$FC,$30,$2C
db $00,$00,$FC,$31,$2C
.spazer_left_s1
dw $0006
db $F8,$01,$FC,$30,$2C
db $00,$00,$FC,$31,$2C
db $F8,$01,$F4,$30,$2C
db $00,$00,$F4,$31,$2C
db $F8,$01,$04,$30,$2C
db $00,$00,$04,$31,$2C
.spazer_left_s2
dw $0006
db $F8,$01,$FC,$30,$2C
db $00,$00,$FC,$31,$2C
db $00,$00,$F0,$31,$2C
db $00,$00,$08,$31,$2C
db $F8,$01,$F0,$30,$2C
db $F8,$01,$08,$30,$2C

.spazer_up_left_s
.spazer_up_left_s1
.spazer_up_left_s2