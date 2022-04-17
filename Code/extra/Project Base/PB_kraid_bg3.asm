;alright, to explain: Kraid has 3 points that affect BG3
;1. background pointer
;		\-> this uses instruction index 0008 (instruction 4), which calls instruction index 0002 and then sets the BG3 base pointer to 2000 instead of 4000
;2. fade in regular background during init ai
;		\-> this is done in 4 parts, 400 bytes at a time. Why is this needed? Because!
;3. unpause hook for when kraid is dead
;		\-> nice and simple, a standard dma transfer using the general (h)dma transfer routine at 8091A9
;the background pointer change is handled in 82, calling a special routine instead of instruction 0002
;the 4 part background fade dma transfer is altered here in A7 to pull the correct gfx each time with the same routine
;lastly, the standard dma transfer is changed to the dynamic one

;- enter door transition
;- background pointer runs special command that both moves the bg3 gfx to 2000 instead of 4000, and changes the base address to 2000
;- kraid's init ai runs, which fades in the background, as well as moving bg3 gfx to 4000
;- kraid overwrites the 4000 gfx
;- kraid dies, runs a command to move bg3 to 4000
;- enter door transition
;- base tile address switched back to 4000
;- whatever gfx are at 4000 at this point are used for layer 3

;oh but don't forget the pause screen
;- pause the game
; -> transfer the hud gfx to 4000 while setting up vram for the subscreen, including setting the address to 2000
;- unpause the game
; -> run a mirror of the background pointer command and transfer hud gfx to 2000 while setting the address to 2000
; -> if kraid is dead, transfer the hud gfx to 4000 so that the door transition will work later

org $A7C78B : JSR Kraid_bg3 : ADC #$0000 : STA $D2,x : NOP #2
org $A7C7B1 : JSR Kraid_bg3 : ADC #$0400 : STA $D2,x : NOP #2
org $A7C7D7 : JSR Kraid_bg3 : ADC #$0800 : STA $D2,x : NOP #2
org $A7C7FD : JSR Kraid_bg3 : ADC #$0C00 : STA $D2,x : NOP #2

; insert into free space
Kraid_bg3:
	LDA !W_Hud_gfx_bnk : XBA : STA $D4,x
	LDA !W_Hud_gfx_src
	RTS

org $A7C23A
	JSL HDMA_Transfer_alt
	db $01,$01,$18
	NOP #5