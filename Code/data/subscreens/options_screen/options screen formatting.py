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
			 "@":"$28BE,$68BD,$2801,$38D0,$38D1,$38D2,$38D3,$38D4,$38D5,$38D6,$2801,$28BD,$28BE,$28BE","*":"",
			 "&":"$0A78,$0A6F,$0A6F,$380E,$0A78,$0A77","^":"$38CB","E":"$28C4,$28C5,$28C6",
			 "S":"$28EC,$28ED,$28EE",
			 "N":"$28FC,$28FD,$28FE",
             "B":"$2CF0,$2CF1,$2CF2,$2CF3,$2CF4,$2CF5,$2CF6",
             "P":"$2E00,$2E01,$2E02",
             "V":"$2CF7,$2CF8,$0000,$2CF9,$2CFA,$2CFB",
             "0":"$2D80,$2D81,$2D82,$2D83","1":"$2D90,$2D91,$2D92,$2D93",
             "2":"$2D84,$2D85,$2D86,$2D87","3":"$2D94,$2D95,$2D96,$2D97",
             "4":"$2E10,$2E11,$2E12", "5":"$2E40,$2E41,$2E42",
             "6":"$3D0A,$3D0B,$3D0C,$2D0D,$2D0E,$2D0F",
			 "{":"$28E8","}":"$A8E8","7":"$788C"}

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

do_the_things("options_tilemap")
























