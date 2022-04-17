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
dw $0006
db $00,$00,$00,$35,$2C
db $00,$00,$F8,$34,$2C
db $00,$00,$F0,$33,$2C
db $F8,$01,$F8,$34,$6C
db $F8,$01,$F0,$33,$6C
db $F8,$01,$00,$35,$6C
.power_up_right_s
dw $0004
db $F8,$01,$00,$39,$6C
db $00,$00,$00,$38,$6C
db $F8,$01,$F8,$37,$6C
db $00,$00,$F8,$36,$6C
.power_right_s
dw $0006
db $FC,$01,$F8,$32,$6C
db $FC,$01,$00,$32,$EC
db $04,$00,$F8,$31,$6C
db $0C,$00,$F8,$30,$6C
db $04,$00,$00,$31,$EC
db $0C,$00,$00,$30,$EC
.power_down_right_s
dw $0004
db $F8,$01,$F8,$39,$EC
db $00,$00,$F8,$38,$EC
db $F8,$01,$00,$37,$EC
db $00,$00,$00,$36,$EC
.power_down_s
dw $0006
db $00,$00,$F8,$35,$AC
db $00,$00,$00,$34,$AC
db $00,$00,$08,$33,$AC
db $F8,$01,$08,$33,$EC
db $F8,$01,$00,$34,$EC
db $F8,$01,$F8,$35,$EC
.power_down_left_s
dw $0004
db $00,$00,$F8,$39,$AC
db $F8,$01,$F8,$38,$AC
db $00,$00,$00,$37,$AC
db $F8,$01,$00,$36,$AC
.power_left_s
dw $0006
db $FC,$01,$F8,$32,$2C
db $FC,$01,$00,$32,$AC
db $F4,$01,$F8,$31,$2C
db $EC,$01,$F8,$30,$2C
db $F4,$01,$00,$31,$AC
db $EC,$01,$00,$30,$AC
.power_up_left_s
dw $0004
db $00,$00,$00,$39,$2C
db $F8,$01,$00,$38,$2C
db $00,$00,$F8,$37,$2C
db $F8,$01,$F8,$36,$2C