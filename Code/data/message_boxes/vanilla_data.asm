.energy_tank
	dw "______####energy#tank####_______"

.missile_tank
	dw "___#########missile##########___"
	dw "___##########################___"
	dw "___######%T##################___"
	dw "___##%T######&#%T#%T#X%T#####___", .missile_icon, .select, .press, .the, .button

.super_tank
	dw "___######super#missile#######___"
	dw "___##########################___"
	dw "___#######%T#################___"
	dw "___###%T#####&#%T#%T#X%T#####___", .super_icon, .select, .press, .the, .button

.power_tank
	dw "___########power#bomb########___"
	dw "___##########################___"
	dw "___#####%T###################___"
	dw "___#%T#####&#%T####%T#X%T####___", .power_icon, .select, .setitwith, .the, .button

.grapple
	dw "___######grappling#beam######___"
	dw "___##########################___"
	dw "___#####%T###################___"
	dw "___#%T#####%T######%T#X%T####___", .grapple_icon, .select, .press_hold, .the, .button

.xray
	dw "___########x-ray#scope#######___"
	dw "___##########################___"
	dw "___#####%T###################___"
	dw "___#%T#####%T######%T#B%T####___", .xray_icon, .select, .press_hold, .the, .button

.varia
	dw "______####varia#suit#####_______"
	
.spring_ball
	dw "______####spring#ball####_______"
	
.morph_ball
	dw "______#####morph#ball####_______"
	
.screw_attack
	dw "______###screw#attack####_______"
	
.hi_jump
	dw "______##high#jump#boots##_______"
	
.space_jump
	dw "______####space#jump#####_______"

.speed_booster
	dw "___######speed#booster#######___"
	dw "___##########################___"
	dw "___##%T#######%T#B%T###%T####___", .press_hold, .the, .button, .to_run

.charge_beam
	dw "______####charge#beam####_______"
	
.ice_beam
	dw "______######ice#beam#####_______"
	
.wave_beam
	dw "______#####wave#beam#####_______"
	
.spazer_beam
	dw "______####spazer#beam####_______"
	
.plasma_beam
	dw "______####plasma#beam####_______"

.bombs
	dw "___##########bomb############___"
	dw "___##%T######################___"
	dw "___##########################___"
	dw "___###%T%T&#%T####%T#X%T#####___", .samus, .arrow, .morphball, .setitwith, .the, .button

.map_data
   %text_yellow()
	dw "______##map#data#access##_______"
    dw "______###################_______"
    dw "______####completed######_______"

.energy_recharge
	dw "______##energy#recharge##_______"
    dw "______###################_______"
    dw "______####completed######_______"

.missile_reload
	dw "______##missile#reload###_______"
    dw "______###################_______"
    dw "______####completed######_______"

.save_option
	dw "______##would#you#like###_______"
    dw "______##to#save?#########_______"
    dw "______##%T%O#####%O######_______", .arrow, .option_yes, .option_no

.save_completed
	dw "______##save#completed.##_______"

.reserve_tank
   %text_purple()
	dw "______####reserve#tank###_______"

.gravity_suit
	dw "______####gravity#suit###_______"