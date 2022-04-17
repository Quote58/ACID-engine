.power
%beam_table("power", $0014)
%beam_frame("power_up", 		$0F, $0404)
%beam_frame("power_up_right", 	$0F, $0404)
%beam_frame("power_right", 		$0F, $0404)
%beam_frame("power_down_right", $0F, $0404)
%beam_frame("power_down", 		$0F, $0404)
%beam_frame("power_down_left", 	$0F, $0404)
%beam_frame("power_left", 		$0F, $0404)
%beam_frame("power_up_left", 	$0F, $0404)
.power_up_s
dw $0002
db $FC,$01,$F8,$32,$2C
db $FC,$01,$00,$33,$2C
.power_up_right_s
dw $0004
db $F8,$01,$00,$37,$6C
db $00,$00,$00,$36,$6C
db $00,$00,$F8,$34,$6C
db $F8,$01,$F8,$35,$6C
.power_right_s
dw $0002
db $F8,$01,$FC,$31,$6C
db $00,$00,$FC,$30,$6C
.power_down_right_s
dw $0004
db $F8,$01,$FC,$37,$EC
db $00,$00,$FC,$36,$EC
db $00,$00,$04,$34,$EC
db $F8,$01,$04,$35,$EC
.power_down_s
dw $0002
db $FC,$01,$00,$32,$AC
db $FC,$01,$F8,$33,$AC
.power_down_left_s
dw $0004
db $04,$00,$FC,$37,$AC
db $FC,$01,$FC,$36,$AC
db $FC,$01,$04,$34,$AC
db $04,$00,$04,$35,$AC
.power_left_s
dw $0002
db $00,$00,$FC,$31,$2C
db $F8,$01,$FC,$30,$2C
.power_up_left_s
dw $0004
db $04,$00,$00,$37,$2C
db $FC,$01,$00,$36,$2C
db $04,$00,$F8,$35,$2C
db $FC,$01,$F8,$34,$2C