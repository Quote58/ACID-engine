def do_the_things(title):
	file = open(title+".txt", "r")
	tilemap = file.read()
	tilemap = tilemap.split("\n")
	file.close()

	tiles = {"|":"$388B","/":"$387B","-":"$387C",">":"$387D","<":"$787D","\\":"$787B","]":"$F87B",
			 "=":"$B87C","[":"$B87B","_":"$0000","+":"$788B",
			 "a":"$3830","b":"$3831","c":"$3832","d":"$3833","e":"$3834","f":"$3835","g":"$3836","h":"$3837",
			 "i":"$3838","j":"$3839","k":"$383A","l":"$383B","m":"$383C","n":"$3840","o":"$3841","p":"$3842",
			 "q":"$3843","r":"$3844","s":"$3845","t":"$3846","u":"$3847","v":"$3848","w":"$3849","x":"$384A",
			 "y":"$384B","z":"$384C",".":"$384D","?":"$384E","!":"$384C",
			 "@":"$28BE,$28BE,$68BD,$2801,$38C6,$38C7,$38C8,$38C9,$38CA,$38CB,$2801,$28BD,$28BE,$28BE","*":"",
             "A":"$2D90","B":"$2D91","X":"$2D92","Y":"$2D93","S":"$2D96,$2D97","R":"$2D95","L":"$2D94","#":"$28E9,$68E9",
             "1":"$2D98,$2D99,$6D98","2":"$2D9C,$2D9B,$6D9C","3":"$2D9A","4":"$6D9A",
             "5":"$AD98,$AD99,$ED98","6":"$2D9D,$2D9E,$6D9D","7":"$2D9F","8":"$6D9F","9":"$AD9D,$AD9E,$ED9D",
			 "{":"$28E8", "}":"$A8E8"}

	text = open(title+".asm", "w")
	new_tilemap = []
	for i in tilemap:
		new_line = "dw " + tiles[i[0]]
		j = i[1:]
		for k in j:
			if (k != "*"):
				new_line += ","
				new_line += tiles[k]
		new_tilemap.append(new_line)
	
	for i in new_tilemap:
		text.write(i)
		text.write("\n")

	text.close()
	for i in tilemap:
		print(i)

do_the_things("button_config_tilemap")
























