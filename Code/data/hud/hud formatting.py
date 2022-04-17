def do_the_things(title):
    file = open(title+".txt", "r")
    hud = file.read()
    hud = hud.split("\n")
    file.close()

    objects = {"a":"etanks", "b":"etanks_small", "c":"health",
               "d":"charge_bar",
               "e":"mini_map", "f":"mini_map_4x3", "g":"mini_map_3x3",
               "h":"input_display", "i":"reserves", "j":"reserves_small",
               "k":"missiles_icon", "l":"supers_icon", "m":"powers_icon",
               "n":"grapple_icon", "o":"xray_icon",
               "p":"missiles_icon_3x1", "q":"supers_icon_3x1", "r":"powers_icon_3x1",
               "s":"missiles_icon_2x1", "t":"supers_icon_2x1", "u":"powers_icon_2x1",
               "v":"grapple_icon_2x1", "w":"xray_icon_2x1",
               "x":"missiles_counter_max", "y":"supers_counter_max", "z":"powers_counter_max",
               "1":"missiles_counter", "2":"supers_counter", "3":"powers_counter",
               "4":"supers_counter_3", "5":"powers_counter_3",
               "6":"health_pro",
               "7":"game_time", "8":"magic_display",
			   "9":"health_big", "A":"health_bar",
               "B":"etanks_dynamic", "C":"etanks_retro",
               "D":"charge_bar_prime", "E":"reserves_prime", "F":"reserves_retro",
               "G":"missiles_icon_2x2", "H":"grapple_icon_2x2", "I":"powers_icon_2x2"}

    text = open(title+".asm", "w")
    widget_list = []
    index = 0
    num = 0
    for i in hud:
        print(i)
        for j in i:
            if (j != "_"):
                widget_list.append([hex(index)[2:], objects[j[0]]])
                num += 1
            index+=2
    if (num >= 1):
        num -= 1
    num = hex(num)[2:]
    text.write("db $%s\n" % num)
    for i in widget_list:
        print(i)
        text.write("db $%s : dw Hud_module_%s" % (i[0], i[1]))
        text.write("\n")
    print(num)
    text.close()

do_the_things("default")
























