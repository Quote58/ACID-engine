org $939FBF
bomb_all:
	dw $0005, bomb_sprite_frame_1, $0404, $0000
	dw $0005, bomb_sprite_frame_2, $0404, $0000
	dw $0005, bomb_sprite_frame_3, $0404, $0000
	dw $0005, bomb_sprite_frame_4, $0404, $0000
	dw $8239, bomb_all
bomb_all_fast:
	dw $0001, bomb_sprite_frame_1, $0404, $0000
	dw $0001, bomb_sprite_frame_2, $0404, $0000
	dw $0001, bomb_sprite_frame_3, $0404, $0000
	dw $0001, bomb_sprite_frame_4, $0404, $0000
	dw $8239, bomb_all_fast






bomb_sprite_frame_1:    dw $0001 : db $FC, $01, $FC, $4C, $3A		;outside part of bomb (uses misc palette)
bomb_sprite_frame_2:    dw $0002 : db $FC, $01, $FC, $CE, $3C		;inside part of bomb (uses beam palette)
								   db $FC, $01, $FC, $4D, $3A
bomb_sprite_frame_3:    dw $0002 : db $FC, $01, $FC, $CF, $3C
								   db $FC, $01, $FC, $4E, $3A
bomb_sprite_frame_4:    dw $0002 : db $FC, $01, $FC, $BF, $3C
								   db $FC, $01, $FC, $4F, $3A