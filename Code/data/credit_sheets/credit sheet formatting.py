def do_the_things(title):
	file = open(title+".txt", "r")
	sheet = file.read()
	sheet = sheet.split("\n")
	file.close()

	lower = {"a":"00","b":"01","c":"02","d":"03","e":"04","f":"05","g":"06","h":"07",
			 "i":"08","j":"09","k":"0A","l":"0B","m":"0C","n":"0D","o":"0E","p":"0F",
			 "q":"10","r":"11","s":"12","t":"13","u":"14","v":"15","w":"16","x":"17",
			 "y":"18","z":"19",".":"1A",",":"1B","\'":"1D",":":"1E","!":"1F",
			 "\"":"4B","_":"4F"}
	upper = {"a":["20","30"],"b":["21","31"],"c":["22","32"],
			 "d":["23","33"],"e":["24","34"],"f":["25","35"],
			 "g":["26","36"],"h":["27","37"],"i":["28","38"],
			 "j":["29","39"],"k":["2A","3A"],"l":["2B","3B"],
			 "m":["2C","3C"],"n":["2D","3D"],"o":["2E","3E"],
			 "p":["2F","3F"],"q":["40","50"],"r":["41","51"],
			 "s":["42","52"],"t":["43","53"],"u":["44","54"],
			 "v":["45","55"],"w":["46","56"],"x":["47","57"],
			 "y":["48","58"],"z":["49","59"],
			 "0":["60","70"],"1":["61","71"],"2":["62","72"],
			 "3":["63","73"],"4":["64","74"],"5":["65","75"],
			 "6":["66","76"],"7":["67","77"],"8":["68","78"],
			 "9":["69","79"]}
			 
	colour_value = {"pink":"$0C","orange":"$10","yellow":"$18","green":"$1C"}

	text = open(title+".asm", "w")
	lines = []
	colours = []
	for i in sheet:
		print(i)
		line = []
		l = 0
		c = i.find("[")
		colour = "$00"
		if c >= 0:
			colour = i[c+1:len(i)-1]
			colours.append(colour)
			colour = colour_value[colour]
			i = i[:c]
		else:
			colours.append(0)
		while l < len(i):
			if (i[l].isupper() == True) or (i[l].isdigit() == True):
				line.append(i[l].lower())
				line.append("+")
			#elif (i[l] == "+"):
			#	line.append("")	
			else:
				line.append(colour+lower[i[l]]+",")
			l += 1
		lines.append(line)

	line = 0
	while line < len(lines):
		c = 0
		colour = "$00"
		if colours[line] != 0:
			colour = colour_value[colours[line]]
			
		while c < len(lines[line]):
			
			if (lines[line][c] == "+"):
				lines[line+1][c-1] = colour+upper[lines[line][c-1]][1]+","
				lines[line][c-1] = colour+upper[lines[line][c-1]][0]+","
				lines[line] = lines[line][:c]+lines[line][c+1:]
			c += 1

		line +=1

	for i in lines:
		text.write("dw ")
		newtext = ""
		for j in i:
			newtext += j
		newtext = newtext[:len(newtext)-1]
		text.write(newtext)
		text.write("\n")
		
	text.close()
	print(colours)


title1 = "credit_sheet_ST"
title2 = "credit_sheet_PC"
title3 = "credit_sheet_TC"

do_the_things(title1)
do_the_things(title2)
do_the_things(title3)
























