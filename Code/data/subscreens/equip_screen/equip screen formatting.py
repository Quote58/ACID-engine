def do_the_things(title):
	file = open(title+".txt", "r")
	tilemap = file.read()
	tilemap = tilemap.split("\n")
	file.close()

	tiles = {"A":"$3A20","l":"$1A21","?":"$3A21","L":"$1A22","#":"$3A23","|":"$388B","/":"$387B",
			 "-":"$387C",">":"$387D","<":"$787D","\\":"$787B","]":"$F87B","=":"$B87C",
			 "[":"$B87B","R":"$3A40,$3A41,$3A42,$3A43","S":"$3A47,$3A48,$3A49",
			 "B":"$3A44,$3A45,$3A46","O":"$2E4D,$2E4E,$2E4F","M":"$3A4A,$3A4B,$3A4C",
			 "I":"$3A5D,$3A5E,$3A5F","_":"$0000","+":"$788B",
			 "%":"$3A02",".":"$28CD",":":"$28CC","@":"$28BE,$28BE,$68BD,$2801,$38D0,$38D1,$38D2,$38D3,$38D4,$38D5,$2801,$28BD,$28BE,$28BE","*":""}

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

do_the_things("equip_tilemap")
























