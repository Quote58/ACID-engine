; *** Super Fast Door Transitions ***
; *** Originally designed for Project Base ***
; *** Quote58 (with certain code from Kazuto and notes from PJboy) ***

; Installation Instructions:
; The door transitions come in 3 parts:
; 1. Layer scrolling routines in bank 80
; 2. IRQ routines in bank 80
; 3. Door transition routines in bank 82
;
; Part 1:
; -> simply needs to be added to the bank 80 asm file, it does not use any free space, simply overwrites small parts of the scrolling routines
; Part 2:
; -> place in free space and reference in the IRQ routine table
; -> 
; Part 3:
; -> place in free space in bank 82
; -> 

; *** quickmet related stuff ***
org $82E777 : JSR Door_transition_load_door_header
org $82E2F7 : JSR Door_transition_load_door_header
; ******************************

; ****************************************
; *** Part 1: Layer scrolling routines ***
; ****************************************
org $80AE7E
; --- Kazuto (formatting by Quote58 and comments by PJboy) ---
Door_transition_scroll:
.right
	LDX $0925							;how many times the screen has scrolled
	PHX
   %inc(!W_X_pos_sub, $092B)			;Samus X sub-position += door transition sub-speed
   %incalt(!W_X_pos, $092D) : STA $0B10	;Samus X position/previous += door transition speed
   %inc(!W_Layer1_X, !C_Scroll_speed)	;Layer 1 X position += 4
   %inc(!W_Layer2_X, !C_Scroll_speed)	;Layer 2 X position += 4
	JSL !Update_BG_scrolls				;Updates only BG1 when scrolling
	PLX
	INX : STX $0925						;Increment number of times screen has scrolled
	CPX #$0100/!C_Scroll_speed : BNE +	;if screen has scrolled 100/scroll_speed times, return clear to end scrolling
	JSL !Update_BG_scrolls
	SEC
	RTS
	+
	CLC
	RTS

.left
	LDX $0925							;how many times the screen has scrolled
	PHX
   %dec(!W_X_pos_sub, $092B)			;Samus X sub-position += door transition sub-speed
   %decalt(!W_X_pos, $092D) : STA $0B10	;Samus X position/previous += door transition speed
   %dec(!W_Layer1_X, !C_Scroll_speed)	;Layer 1 X position += 4
   %dec(!W_Layer2_X, !C_Scroll_speed)	;Layer 2 X position += 4
	JSL !Update_BG_scrolls				;Updates only BG1 when scrolling
	PLX
	INX : STX $0925						;Increment number of times screen has scrolled
	CPX #$0100/!C_Scroll_speed : BNE +	;if screen has scrolled 100/scroll_speed times, return clear to end scrolling
	SEC
	RTS
	+
	CLC
	RTS

.down
	LDX $0925							;how many times the screen has scrolled
	PHX
	BNE .down_scrolling					;if n == 0, scrolling hasn't started yet
	LDA !W_BG1_Y    : PHA				;save bg1/2 y scroll
	LDA !W_BG2_Y    : PHA
	LDA !W_Layer1_Y : PHA				;layer 1 Y -= F
   %sbc(#$000F) : STA !W_Layer1_Y
	LDA !W_Layer2_Y : PHA				;layer 2 y -= F
   %sbc(#$000F) : STA !W_Layer2_Y
	JSR $A4BB : JSR $AE10				;calculate the number of blocks scrolled, and then save that number
	DEC $0901 : DEC $0905				;previous number of blocks scrolled for layer 1/2 -= 1
	JSL !Update_BG_scrolls
	PLA : STA !W_Layer2_Y				;restore position of layer 1/2 and background 1/2
	PLA : STA !W_Layer1_Y
	PLA : STA !W_BG2_Y
	PLA : STA !W_BG1_Y
	BRA .down_end
.down_scrolling
	CPX #$00E0/!C_Scroll_speed+1
	BCS .down_end						;if it just scrolled for the final time, end it
   %inc(!W_Y_pos_sub, $092B)			;samus sub pixel y position += door transition subpixel speed
   %incalt(!W_Y_pos, $092D) : STA $0B14	;samus y position/previous += door transition speed
   %inc(!W_Layer1_Y, !C_Scroll_speed)	;layer 1 y position += 4
   %inc(!W_Layer2_Y, !C_Scroll_speed)	;layer 2 y position += 4
	JSL !Update_BG_scrolls
.down_end
	PLX
	INX : STX $0925						;inc number of times screen has scrolled
	CPX #$00E0/!C_Scroll_speed+1 : BCC +
	JSL !Update_BG_scrolls				;update just BG1 when scrolling
	SEC
	RTS
	+
	CLC
	RTS
	
.up
	LDX $0925							;how many times the screen has scrolled
	PHX
	BNE .up_scrolling					;if n == 0, scrolling hasn't started yet
	LDA !W_BG1_Y    : PHA				;save bg1/2 y scroll
	LDA !W_BG2_Y    : PHA
	LDA !W_Layer1_Y : PHA				;layer 1 Y -= F
   %sbc(#$0010) : STA !W_Layer1_Y
	LDA !W_Layer2_Y : PHA				;layer 2 y -= F
   %sbc(#$0010) : STA !W_Layer2_Y
	JSR $A4BB : JSR $AE10				;calculate the number of blocks scrolled, and then save that number
	INC $0901 : INC $0905				;previous number of blocks scrolled for layer 1/2 -= 1
	JSL !Update_BG_scrolls
	PLA : STA !W_Layer2_Y				;restore position of layer 1/2 and background 1/2
	PLA : STA !W_Layer1_Y
	PLA : STA !W_BG2_Y
	PLA : STA !W_BG1_Y
	BRA .up_end
.up_scrolling
   %dec(!W_Y_pos_sub, $092B)			;samus sub pixel y position += door transition subpixel speed
   %decalt(!W_Y_pos, $092D) : STA $0B14	;samus y position += door transition speed
   %dec(!W_Layer1_Y, !C_Scroll_speed)	;layer 1 y position += 4
   %dec(!W_Layer2_Y, !C_Scroll_speed)	;layer 2 y position += 4
	CPX #$0010/!C_Scroll_speed+1 : BCS + ;scroll counter for drawing behind the hud before scrolling
   %add(!W_Layer1_X, $091D, !W_BG1_X)
   %add(!W_Layer1_Y, $091F, !W_BG1_Y)
   %add(!W_Layer2_X, $0921, !W_BG2_X)
   %add(!W_Layer2_Y, $0923, !W_BG2_Y)
	BRA .up_end
	+
	JSL !Update_BG_scrolls
.up_end
	PLX
	INX : STX $0925						;inc number of times screen has scrolled
	CPX #$00E0/!C_Scroll_speed+1 : BNE +
	SEC
	RTS
	+
	CLC
	RTS	


; ****************************
; *** Part 2: IRQ Routines ***
; ****************************
; -> put this all in free space
; --- Quote58 ---
Interrupt:
.command_22								;vertical door transition, begin HUD drawing
	SEP #$20
	LDA #$04 : STA $212C
	STZ $2130 : STZ $2131
	REP #$20

	LDA #$0001 : STA !W_IRQ_count
	JSR Calculate_IRQ_order
	
	LDA #$0024
	LDY #$001F : LDX #$0098
	RTS
	
.command_24								;vertical door transition, set up initial order
   %door_screen_regs()
	LDA !W_First_pos : TAY
	LDA !W_First_command
	LDX #$0098
	RTS

.command_26								;vertical door transition, scrolling
	LDA $0931 : BMI +
	JSL $80AE4E
	+
	DEC !W_IRQ_count : BMI .command_end
	LDA !W_Second_pos : TAY
	LDX #$0098
	LDA #$001C
	RTS

.command_1C								;vertical door transition, vram update
	LDX $05BC : BPL +
	JSR .VRAM_update
	+
	DEC !W_IRQ_count : BMI .command_end
	LDA !W_Second_pos : TAY
	LDX #$0098
	LDA #$0026
	RTS

.command_end							;vertical door transition, end
	LDA !W_Interrupt_next : BEQ +
	STZ !W_Interrupt_next : BRA ++
	+
	LDA #$0022
	++
	LDY #$0000 : LDX #$0098
	STZ !W_NMI_request
	INC !W_NMI_request
	RTS

.command_1E
	SEP #$20
	LDA #$5A : STA $2109
	STZ $2130 : STZ $2131
	LDA #$04 : STA $212C
	REP #$20
	LDA #$0020
	LDY #$001F : LDX #$0098
	RTS

.command_20
   %gameplay_screen_regs()

	LDA !W_Colour_div : BEQ + : BPL ++
	JSR Fade_to_black_final : BRA +++	;just clearing any remaining colours from enemies
	++
	JSR Fade_to_black
	+++
	STZ !W_NMI_request
	INC !W_NMI_request
	LDA #$001E : BRA ++
	+
	LDA #$0008
	++
	LDY #$0000 : LDX #$0098
	RTS

; --- Quote58 ---
Calculate_IRQ_order:
;okay, to determine the location of the data move above a door, we can use
;(scroll_diff+$1F+scroll_amt)-[(2*|yi|)+$10]-movingamt
;the amount below a door is:
;(scroll_diff+$1F+scroll_amt+$10)
!ScrollingAmt = #$0028					;worst case amount of lines used by scrolling code
!MovingAmt 	  = #$0018
!FirstPos	  = #$2400
!FullDoor	  = #$0080						;full door is assuming 3 tiles on each end, 3*2*10 = 60, + 10 for each door cap = 80
!HalfDoor	  = #$0040						;30 + 10 for door cap
!Dummy 		  = #$FFFF

; step one: get the absolute value of the difference in scroll position from where we started + the amount of lines taken by the HUD
	LDA !W_Layer1_Y : SEC : SBC !W_Layer_offset : BPL +
	EOR #$FFFF							;if it's a negative number, make it positive
	+
	STA !W_Scroll_diff

	STZ !W_IRQ_DP1
	LDY #$0000
	LDA !W_Door_dir : AND #$0003 : CMP #$0002 : BNE +
	LDA #$00E0 : SEC : SBC !W_Scroll_diff : SBC !HalfDoor : STA !W_Scroll_diff
	BRA .moving_down
	+
	LDA !W_Scroll_diff : CLC : ADC !HalfDoor : STA !W_Scroll_diff
	LDA #$0026 : STA !W_IRQ_DP1

.moving_up
	LDA !W_Scroll_diff
	CMP .up_thresholds,y : BMI + : INY #2
	CMP .up_thresholds,y : BMI + : INY #2
	CMP .up_thresholds,y : BMI + : INY #2
	+
	BRA .moving

.moving_down
	LDA !W_Scroll_diff
	CMP .down_thresholds,y : BPL + : INY #2
	CMP .down_thresholds,y : BPL + : INY #2
	CMP .down_thresholds,y : BPL + : INY #2
	+

.moving
	TYA : ASL #2 : CLC : ADC !W_IRQ_DP1 : TAX
	LDA .down_types,x : STA !W_First_command
	
	LDA .down_types+2,x : CMP !FirstPos : BNE +
	XBA : BRA ++
	+
	CLC : ADC !W_Scroll_diff
	++
	CMP #$0024 : BPL +
	LDA #$0024
	+
	STA !W_First_pos
	
	LDA .down_types+4,x : CMP !FirstPos : BNE +
	XBA : BRA ++
	+
	CLC : ADC  !W_Scroll_diff
	++
	STA !W_Second_pos
	RTS

;remember to make those numbers variable additions/subtractions

.down_thresholds ;(going down)
	dw #$001F+!ScrollingAmt+!MovingAmt, #$001F+!MovingAmt, #$0000
.down_types
	dw #$0026, !FirstPos, #$FFE8, !Dummy
	dw #$001C, #$FFE8, #$0008, !Dummy
	dw #$0026, !FirstPos, !FullDoor, !Dummy
	dw #$001C, !FullDoor, !FullDoor+!MovingAmt+#$0008, !Dummy

.up_thresholds ;(going up)
	dw #$00E0-!ScrollingAmt-!MovingAmt, #$00E0-!MovingAmt, #$00E0
.up_types
	dw #$001C, #$0000, !MovingAmt+#$0008, !Dummy
	dw #$0026, !FirstPos, #$0000, !Dummy
	dw #$001C, #$FF68, #$FF88, !Dummy
	dw #$0026, !FirstPos, #$FF68, !Dummy

; --- Quote58 ---
Fade_to_black:							;this routine takes about half the screen's worth of time (ie. half a frame or 8ms) to finish
	LDA !W_Colour_fade : CMP #$0003 : BMI .continue
   %pea(7E)
	LDX #$01FE
	-
	LDA $C200,x : BNE +					;if the target colour is not black, then it's one of the ones being preserved
	LDA $C000,x	: AND #$001F : LSR : AND #$001F : STA !W_IRQ_DP1
	LDA $C000,x : AND #$03E0 : LSR : AND #$03E0 : STA !W_IRQ_DP2
	LDA $C000,x : AND #$7C00 : LSR : AND #$7C00 : CLC : ADC !W_IRQ_DP2 : ADC !W_IRQ_DP1
	STA $C000,x
	+
	DEX #2 : BPL -
	PLB
	LDA !W_Colour_div : DEC : BNE +
	LDA #$FFFF
	+
	STA !W_Colour_div
	STZ !W_Colour_fade : BRA .end
.continue
	INC !W_Colour_fade
.end
	RTS

.final									;this is to ensure that any enemy forced colours left in the palette after fading get zeroed
   %pea(7E)
	LDX #$01FE
	-
	LDA $C200,x : BNE +
	LDA #$0000 : STA $C000,x
	+
	DEX #2 : BPL -
	PLB
	STZ !W_Colour_div
	RTS


; ************************************
; *** Part 3: Door transition code ***
; ************************************

; --- Quote58 ---
Door_transition:
.prep_palette
   %pealt(7E)
	LDX #$00FE : LDA #$0000
	-
	STA $C200,x : STA $C300,x
	DEX #2 : BPL -
	
	LDA $C012 : STA $C212				;make sure the colours in the cre that are used for the doors and HUD are preserved
	LDA $C014 : STA $C214
	LDA $C01A : STA $C21A
	LDA $C01C : STA $C21C
	LDA $C022 : STA $C222
	LDA $C024 : STA $C224
	LDA $C026 : STA $C226
	LDA $C03A : STA $C23A

	LDA $07B3 : ORA $07B1				;special gfx bitflag for bosses that overwrite the cre
	BIT #$0001 : BNE +
	LDA $C028 : STA $C228
	LDA $C02A : STA $C22A
	LDA $C02C : STA $C22C
	LDA $C02E : STA $C22E
	LDA $C038 : STA $C238
	LDA !W_Timer_status : BEQ +			;why does the timer need to preserve colours that aren't sprite related?
	LDA $C1A2 : STA $C3A2
	LDA $C1A4 : STA $C3A4
	LDA $C1A8 : STA $C3A8
	LDA $C1BA : STA $C3BA
	JSL !Draw_timer
	+
	RTS

.load_door_header
!ScrollTemp = $00
;door header format is:
;[rrrr][ff][dd][xi][yi][xx][yy][tttt][ssss]
;  |    |   |   ||  ||  |   |    |     \--- scroll pointer
;  |    |   |   ||  ||  |   |    \--------- 'distance from door', which is actually the door transition 'speed' and determines how far samus ends up after the door
;  |    |   |   ||  ||  |   \-------------- y scroll of door
;  |    |   |   ||  ||  \------------------ x scroll of door
;  |    |   |   ||  |\--------------------- number of blocks within scroll for door plm in the Y
;  |    |   |   ||  \---------------------- y scroll of door plm
;  |    |   |   |\------------------------- number of blocks within scroll for door plm in the X
;  |    |   |   \-------------------------- x scroll of door plm
;  |    |   \------------------------------ door direction and flag for spawning door plm  (04+ = spawn door plm) (00-03 = RLDU)
;  |    \---------------------------------- bitflags for door, usually used for elevators
;  \--------------------------------------- room MDB pointer

   %pealt(83)
	LDX !W_Door_pointer
	LDA $0000,x : STA $079B
	LDA $0002,x : STA $0793 : AND #$0080 : STA $0E16
	LDA $0003,x : AND #$00FF : STA $0791

	LDA $0007,x : AND #$00FF : STA !ScrollTemp : XBA : STA !W_Room_Y_enter
	LDA $0006,x : AND #$00FF : XBA : STA !W_Room_X_enter
	CLC : ADC !ScrollTemp : STA !W_Scroll_next

	STZ $12 : STZ $14
	LDA $0008,x : BPL ++
	LDA !W_Door_dir : ROR #2 : BCS +	;checks if the door is vertical or horizontal
	LDA #$00C8 : BRA ++
	+
	LDA #$0180
	++
	ASL
	STA $13
	LDA $12 : STA $092B
	LDA $14 : STA $092D
	RTS

.init
	PHP
   %draw_samus_et_all()
	LDA #$0007 : STA $0DE0				;make samus invincible during the transition <-- is this actually needed? I don't think it is...
	SEP #$20							;wait for sounds to finish
	LDA $0646 : SEC : SBC $0643 : AND #$0F : BNE +
	LDA $0647 : SEC : SBC $0644 : AND #$0F : BNE +
	LDA $0648 : SEC : SBC $0645 : AND #$0F : BNE +
	REP #$20
	LDA #$0000 : STA !W_Door_aligned
	STA !W_Colour_total : STA !W_Colour_fade
	STA !W_Colour_div : STA !W_Scroll_current
	STA !W_Still_fading

	LDX !W_X_pos : LDA !W_Y_pos
	JSL Find_scroll : STA !W_Scroll_current
	JSR .load_door_header				;load door header
	JSR Fade_get_divisor
	LDA #$001E : STA !W_Interrupt_next
	LDA #.align_door : STA !W_Transition_state
	+
	PLP
	RTS

.align_door
   %draw_samus_et_all()
	JSR .align_screen : BCC +
	LDA #.init_room : STA !W_Transition_state
	+
	RTS

.init_room
	LDA !W_Colour_div : BEQ +
   %draw_samus_et_all()
	+
	STZ $0DE0							;make sure samus doesn't stay invincible
   %pealt(8F)
	JSR $DF99							;save explored map (for elevators)
	JSR $DE6F							;load room header
	JSR $DEF2							;load state header
	JSR $DFB6							;load new explored map (for elevators)
	JSL $82EA73							;decompress level, scroll, and cre data (this alone takes 38 frames)
	LDA #.init_scrolling : STA !W_Transition_state
	RTS
	
.init_scrolling
;No change to vram or the screen yet
	LDA !W_Colour_div : BNE ++
	JSL $8882AC							;delete hdma objects
	LDA #$8000 : TRB $18B0				;enable hdma
	JSL $8882C1							;init FX for new room
   %pealt(8F)
	STZ $B5 : STZ $B7
	STZ $07E9
	LDA !W_Door_dir : AND #$0003 : CMP #$0002 : BNE +
	INC !W_BG1_Y						;this seems to prevent the game from getting the wrong line at the bottom of the scroll?
	+
	LDA $0791 : AND #$0003 : CMP #$0003 : BEQ +
	STZ $0925
	+
	JSL $80AD30							;why does this add 1 block before the scrolling starts when moving up???
	LDA !W_X_pos : AND #$00FF : CLC : ADC !W_Layer1_X : STA !W_X_pos : STA !W_X_pos_prev
	LDA !W_Y_pos : AND #$00FF : CLC : ADC !W_Layer1_Y : STA !W_Y_pos : STA !W_Y_pos_prev
	LDA #.main : STA !W_Transition_state
	++
	RTS

.main
	LDA !W_Layer1_Y : STA !W_Layer_offset
	STZ $0931 : STZ $05BC
	
	LDA !W_Door_dir : AND #$0003 : CMP #$0002 : BMI +
	LDA !W_Elevator_state : BNE +
	LDA #$0022 : BRA ++
	+
	LDA #$0016
	++
	STA !W_Interrupt_next
	JSR $DF69							;wait until the end of a v-blank
	
	LDA $07B3 : BIT #$0002 : BEQ +		;special gfx bitflag 02 means the cre needs to be reloaded
	LDA $078D : CMP #$947A : BEQ +

   %decompress(#$B900, #$8000, $7E7000)	;cre tiles
	+
   %decompress($07C4, $07C3, $7E2000)	;room tiles
   %decompress($07C7, $07C6, $7EC200)	;room palettes

   %IRQ_DMA(7E2000, 0000, 1000)			;normally this only takes 3 transfers, but I needed to break it up a little bit more to fit
   %IRQ_DMA(7E3000, 0800, 1000)
   
   %IRQ_DMA(7E4000, 1000, 1000)			;there's $7000 bytes of them!
   %IRQ_DMA(7E5000, 1800, 1000)
   
   %IRQ_DMA(7E6000, 2000, 1000)
	
	LDA $07B3 : BIT #$0006 : BEQ +
	LDA $078D : CMP #$947A : BEQ +
   %IRQ_DMA(7E7000, 2800, 1000)			;cre tiles now! ($3000 bytes!)
   %IRQ_DMA(7E8000, 3000, 1000)			;this is normally 1 transfer, but 2000 bytes is a lot of screen space and this needs to be applicable to any speed the hacker gives it
   %IRQ_DMA(7E9000, 3800, 1000) 
	+
  %IRQ_DMA(9ABD00, 4580, 0300)			;and the layer 3 tiles ($800 bytes normally, but with the modular hud we're only transfering the FX tiles which is $300)

	JSR $DFD1							;load enemy gfx data
	JSL $878016							;Clear animated tiles objects
	JSL $8DC4D8							;Clear palette FX objects
	LDA #.finish_init : STA !W_Transition_state
	RTS

.finish_init
	PHP
	JSL $82E071							;Load room music
	JSL $868016							;Clear enemy projectiles
	JSL $8483C3							;Clear PLMs
	JSL $82EB6C							;Create PLMs, execute door ASM, room setup ASM and set elevator status
	JSL $89AB82							;load fx header
	JSR $E8EB  							;Spawn door closing PLM
	JSL $90AC8D							;Update beam graphics
	JSL $82E139							;Load target colours for common sprites, beams and flashing enemies / pickups	
	JSL $A08A1E							;Load enemies
	JSL $A08A9E							;Initialise enemies
	JSL $90AD22							;Reset projectile data
	JSL $91DEE6							;Load Samus' target colours based on suit
	PLP

   %pealt(8F)
	JSR $E566							;clear layer 3 for fx <-- does this need to happen?
	LDA #$8A00 : STA $05C1				;move the fx tilemap to vram
	LDA $1964 : BEQ + : STA $05C0
	LDA #$5BE0 : STA $05BE
	LDA #$0840 : STA $05C3
	LDA #$8000 : TSB $05BC
	-
	BIT $05BC : BMI -					;wait for signal
	+

	LDX $07BB
	LDY $0016,x : BPL +
	
	-
	LDX $0000,y : INY #2				;run background function
	JSR ($E5C7,x)
	BCC -

	+
	REP #$30
	-
	LDA $0931 : BPL -					;wait for scrolling to finish	

	LDA #$3BE0 : STA $7EC188
	JSL $88D865 : LDA #$8000 : TSB $18B0 ;set up hdma stuff
	JSL $8485B4
	JSL $808338
	LDA !W_Door_dir : BIT #$0002 : BNE ++ : BEQ +
	LDA #$0007 : TRB $0AF6 : BRA ++
	+
	LDA #$0007 : TSB $0AF6
	++
	LDA #$E659 : STA !W_Transition_state
	RTS

.prep_for_IRQ
!ScrollTemp = $00
!FullDoor = #$0060						;full door is assuming 3 tiles on each end, 3*2*10 = 60

	LDA !W_Layer1_Y : STA !W_Layer_offset	;save the initial Y offset before scrolling starts so we can get the difference each frame
	LDA !W_Scroll_current : CMP #$0001 : BEQ ++
	LDA !W_Scroll_next : AND #$00FF : STA !ScrollTemp
	LDA !W_Room_width : LSR #4
   %multiply(!ScrollTemp) : STA !ScrollTemp
	LDA !W_Scroll_next : AND #$FF00 : XBA
	CLC : ADC !ScrollTemp : TAX
	SEP #$30
	LDA !W_Room_scroll,x
	REP #$30 : BEQ +					;if we somehow came from a red scroll (00), we're going to pretend it was green
	AND #$0001
	++
	ASL #5								;02 & 01 = 00, 01 & 01 = 01
	+
	STA !W_Scroll_next
	RTS

; --- Quote58 (also thanks to kazuto) ---
Door_transition_align_screen:
	LDA !W_Door_dir : BIT #$0002 : BNE .vertical
	LDA !W_Layer1_Y-1 : BIT #$FF00 : BEQ .end
	PHP : LDX #$0004 : PLP
	BRA .move
.vertical
	LDA !W_Layer1_X-1 : BIT #$FF00 : BEQ .end
	PHP : LDX #$0000 : PLP
.move
	SEP #$20 : BMI +
	LDA !W_Layer1_X,x : CMP.b #$00+!C_Transition_speed : BPL .positive
	BRA ++
	+
	LDA !W_Layer1_X,x : CMP.b #$00-!C_Transition_speed : BMI .negative
	INC $0912,x
	++
	STZ !W_Layer1_X,x
	REP #$20 : BRA .move_end
.positive
	REP #$20 : LDA.w #$0000-!C_Transition_speed : BRA +
.negative
	REP #$20 : LDA.w #$0000+!C_Transition_speed
	+
	CLC : ADC !W_Layer1_X,x : STA !W_Layer1_X,x
.move_end
	JSL $80A3AB
	CLC
	RTS
.end
	JSL $80A3AB
	LDA !W_Door_dir : AND #$0003 : CMP #$0003 : BNE +
	JSL $80AD1D							;fix doors moving up
	+
	SEC
	RTS

Fade_get_divisor:
   %pea(7E)
	STZ $00
	LDX #$01FE
	-
	LDA $C000,x : AND #$001F : CMP $00 : BMI + : STA $00
	+
	LDA $C000,x : AND #$03E0 : LSR #4 : CMP $00 : BMI + : STA $00
	+
	LDA $C000,x : AND #$7C00 : XBA : CMP $00 : BMI + : STA $00
	+
	DEX #2 : BPL -
	LDY #$0000
	LDA $00
	-
	LSR : BEQ +
	INY : BRA -
	+
	TYA : STA !W_Colour_div
	PLB
	RTS
