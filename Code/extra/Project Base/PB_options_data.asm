.settings_saved
	dw "______[##save#options###]_______"
	dw "______[##and#settings?##]_______"
	dw "______[##%T%O####%O#####]_______", .arrow, .option_yes, .option_no

.auto_morph
	dw "___[#######auto-morph#######]___"
	dw "___[##%T%T%T#L####%T%T%T#R##]___"
	dw "___[########################]___"
	dw "___[########################]___", .samus, .auto_morph_1, .hold, .samus, .auto_morph_2, .hold

.beam_flicker
   %text_yellow()
	dw "___[######beam#flicker######]___"
   %text_blue()
	dw "___[#beam#sprite#only#draws#]___"
	dw "___[##every#other#frame#to##]___"
	dw "___[##increase#performance##]___"

.beam_trails
   %text_yellow()
	dw "___[######beam#trails#######]___"
   %text_blue()
	dw "___[#particle#effects#that##]___"
	dw "___[#follow#beam#sprites####]___"
	dw "___[#disable#to#reduce#lag##]___"

.morph_flash
   %text_yellow()
	dw "___[######morph#flash#######]___"
   %text_blue()
	dw "___[########################]___"
	dw "___[####samus#will#flash####]___"
	dw "___[#####when#morphing######]___"

.spark_exit
   %text_yellow()
	dw "___[####shinespark#exit#####]___"
   %text_blue()
	dw "___[##press#A#to#exit#into##]___"
	dw "___[#####a#spinjump#and#####]___"
	dw "___[#####hold#B#to#fall#####]___"

.low_health
   %text_yellow()
	dw "___[####low#health#alert####]___"
   %text_blue()
	dw "___[########################]___"
	dw "___[#a#sound#will#play#when#]___"
	dw "___[###health#is#critical###]___"

.screen_shake
   %text_yellow()
	dw "___[######screen#shake######]___"
   %text_blue()
	dw "___[###disable#to#prevent###]___"
	dw "___[##screen#from#shaking###]___"
	dw "___[###during#explosions####]___"

.keep_speed
   %text_yellow()
	dw "___[#######keep#speed#######]___"
   %text_blue()
	dw "___[##samus#will#preserve###]___"
	dw "___[##momentum#and#speed####]___"
	dw "___[#####upon#landing#######]___"

.quick_booster
   %text_yellow()
	dw "___[#####quick#booster######]___"
   %text_blue()
	dw "___[########################]___"
	dw "___[##samus#will#gain#speed#]___"
	dw "___[##echoes#twice#as#fast##]___"

.auto_run
   %text_yellow()
	dw "___[########auto#run########]___"
   %text_blue()
	dw "___[########################]___"
	dw "___[#samus#will#run#without#]___"
	dw "___[#holding#the#run#button#]___"

.backflip
   %text_yellow()
	dw "___[########backflip########]___"
   %text_blue()
	dw "___[#to#perform#a#backflip##]___"
	dw "___[##crouch#while#holding##]___"
	dw "___[##run#and#press#jump####]___"

.respin
   %text_yellow()
	dw "___[########re-spin#########]___"
   %text_blue()
	dw "___[########################]___"
	dw "___[#press#A#while#falling##]___"
	dw "___[##to#enter#a#spinjump###]___"

.quickmorph
   %text_yellow()
	dw "___[######quick#morph#######]___"
   %text_blue()
	dw "___[##%T####################]___"
	dw "___[#####%T#Y#&#%T##down####]___"
	dw "___[###%T%T#################]___", .samus, .hold, .press, .arrow, .morphball

.cannon_tint
   %text_yellow()
	dw "___[######cannon#tint#######]___"
   %text_blue()
	dw "___[########################]___"
	dw "___[#samus#arm#cannon#will##]___"
	dw "___[#match#her#beam#colour##]___"

.time_attack
   %text_yellow()
	dw "___[######time#attack#######]___"
   %text_blue()
	dw "___[##map#screen#displays###]___"
	dw "___[#-game#time#-items#found]___"
	dw "___[###-item#percentage#####]___"

.moon_walk
   %text_yellow()
	dw "___[#######moon#walk########]___"
   %text_blue()
	dw "___[########################]___"
	dw "___[##hold#X#and#walk#back##]___"

.upspin
   %text_yellow()
	dw "___[########up-spin#########]___"
   %text_blue()
	dw "___[###################%T###]___"
	dw "___[#####%T#B#&#%T##A#######]___"
	dw "___[##############%T%T######]___", .samus, .hold, .press, .morphball, .arrow

.speed_echoes
   %text_yellow()
	dw "___[######speed#echoes######]___"
   %text_blue()
	dw "___[##%T%T%T%T#after#images#]___"
	dw "___[###########when#moving##]___"
	dw "___[###########fast#enough##]___", .samus_echo, .samus_echo, .samus_echo, .samus

.auto_save
   %text_yellow()
	dw "___[#######auto#save########]___"
   %text_blue()
	dw "___[########################]___"
	dw "___[##skip#save#dialog#in###]___"
	dw "___[#####save#capsules######]___"

.clear_msg
   %text_yellow()
	dw "___[##clear#message#boxes###]___"
   %text_blue()
	dw "___[########################]___"
	dw "___[###message#boxes#have###]___"
	dw "___[#####transparency#######]___"

.screw_attack_glow
   %text_yellow()
	dw "___[###screw#attack#glow####]___"
   %text_blue()
	dw "___[########################]___"
	dw "___[###screw#attack#will####]___"
	dw "___[######glow#green########]___"
