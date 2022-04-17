lorom

; --- Quote58 ---
macro proj_dir(name, damage)
	dw <damage>
	dw .<name>_up
	dw .<name>_up_right, .<name>_right, .<name>_down_right
	dw .<name>_down, .<name>_down
	dw .<name>_down_left, .<name>_left, .<name>_up_left
	dw .<name>_up
endmacro

macro proj_frame(name,delay,hitbox)
.<name>
	dw $0000+<delay>, .<name>_s, <hitbox>, $0000
	dw $8239, .<name>
endmacro

macro proj_frame_2(name,delay,hitbox,hitbox1)
.<name>
	dw $0000+<delay>, .<name>_s, <hitbox1>, $0000
	dw $8239, .<name>
endmacro

macro proj_frame_3(name,delay,hitbox,hitbox1,hitbox2)
.<name>
	dw $0000+<delay>, .<name>_s, <hitbox>,  $0000
	dw $0000+<delay>, .<name>_s1, <hitbox1>, $0001
.<name>_loop
	dw $0000+<delay>, .<name>_s2, <hitbox2>, $0002
	dw $8239, .<name>_loop
endmacro

macro check_option(option)
	LDA <option> : JSL Check_option_bit : BCC .end
endmacro

macro oam_h_square(yy, xx, tt, pf)		;this creates a square of tiles that is mirrored horizontally
	db $<xx>,$00,$<yy>,$<tt>,$<pf>		;if I end up using this anywhere else, I'll toss it into macros.asm
	db $<xx>+8,$00,$<yy>,$<tt>,$<pf>+$40
	db $<xx>,$00,$<yy>+8,$<tt>,$<pf>
	db $<xx>+8,$00,$<yy>+8,$<tt>,$<pf>+$40
endmacro

macro message_vram(dst, settings, src, amt)
	LDA <dst>  : STA $2116				;destination in vram
	LDA <settings> : STA $4310			;dma settings flags
	LDA <src>  : STA $4312				;source address
	LDA #$007E : STA $4314				;source bank
	LDA <amt>  : STA $4315				;amount of bytes to transfer
	STZ $4317  : STZ $4319				;not needed for this
	SEP #$20
	LDA #$80 : STA $2115
	LDA #$02 : STA $420B
endmacro

macro door_screen_regs()
	SEP #$20
	LDA $07B3 : ORA $07B1
	BIT #$01 : BEQ +
	LDA #$10 : BRA ++
	+
	LDA #$11
	++
	STA $212C
	STZ $2130 : STZ $2131
	REP #$20
endmacro

macro gameplay_screen_regs()
	SEP #$20
	LDA $70 : STA $2130
	LDA $73 : STA $2131
	LDA $5B : STA $2109
	LDA $6A : STA $212C
	REP #$20
endmacro

macro show_perf(bright, code)
	SEP #$20							;set the screen brightness before the code
	LDA #$<bright> : STA !R_Screen_disp
	REP #$20
	<code>
	SEP #$20
	LDA #$0F : STA !R_Screen_disp		;reset the screen brightness after the code
	REP #$20
endmacro

macro decompress(bnk, src, dst)
	LDA <bnk> : STA $48
	LDA <src> : STA $47
	JSL !Decompress
	dl <dst>
endmacro

macro IRQ_DMA(src, dst, size)
	JSR !IRQ_DMA_transfer
	dl $<src>
	dw $<dst>, $<size>
endmacro

macro draw_samus_et_all()
	JSL $A08EB6							;set up enemies to process
	JSL $A08FD4							;process those enemies
	JSL $A0884D							;draw the other important sprites (samus, projectiles, etc.)
	JSR $DFC7							;something about drawing samus
endmacro

macro mod(addr, max)					;like mod_odd, but for any range
	LDA <addr> : INC : CMP <max>+1 : BMI +
	LDA #$0000
	+
	STA <addr>
endmacro

macro mod_odd(addr, max)				;easy mod operation on a range that is an odd number ex. 3, F, etc.
	LDA <addr> : INC : AND <max> : STA <addr>
endmacro

macro widget(len, dir, pos, typ)
	db $01
	dw <len>, <dir>, <pos>, <typ>
endmacro

macro list(len, size, index, pos, dir, typ)
	db $00
	dw <len> : db <size>
	dw <index>, <pos>
	dw <dir> : db <typ>
endmacro

macro dma_wram(high, mid, low, src, amt)
	SEP #$30
	LDA #$<low>  : STA !R_WRAM_low
	LDA #$<mid>  : STA !R_WRAM_mid
	LDA #$<high> : STA !R_WRAM_high
	JSL !HDMA_Transfer
	db $01, $00, $80
	dl <src>
	dw $<amt>
	LDA #$02 : STA !R_DMA
	REP #$30
endmacro

macro dma_vram(high, low, vpc, src, amt)
	SEP #$30
	LDA #$<low>  : STA !R_VRAM_low
	LDA #$<high> : STA !R_VRAM_high
	LDA #$<vpc>  : STA !R_VPORT
	JSL !HDMA_Transfer
	db $01, $01, $18
	dl <src>
	dw $<amt>
	LDA #$02 : STA !R_DMA
	REP #$30
endmacro

macro xor(addr, amt)
	LDA <addr> : EOR <amt> : STA <addr>
endmacro

macro debug_1(addr)
	LDA <addr> : STA $09C6
endmacro

macro debug_2(addr)
	LDA <addr> : STA $09CE
endmacro

macro debug_3(addr)
	LDA <addr> : STA $09CA
endmacro

macro pea(bank)
	PHB : PEA $<bank>00 : PLB : PLB
endmacro

macro pealt(bank)
	PEA $<bank>00 : PLB : PLB
endmacro

macro pea2(bank1, bank2)							;for when you need to specify both bytes of the pea
	PEA $<bank1><bank2> : PLB : PLB
endmacro

macro dec(addr, amt)							;decrements an address by a specified amount (ie. addr -= amt)
	LDA <addr> : SEC : SBC <amt> : STA <addr>
endmacro

macro inc(addr, amt)							;increments an address by a specified amount (ie. addr += amt)
	LDA <addr> : CLC : ADC <amt> : STA <addr>
endmacro

macro decalt(addr, amt)							;the alt version is for when you already cleared the counter
	LDA <addr> : SBC <amt> : STA <addr>
endmacro

macro incalt(addr, amt)
	LDA <addr> : ADC <amt> : STA <addr>
endmacro

macro dey(amt)									;decrements the Y register by a specified amount (ie. y -= amt)
	TYA : SEC : SBC <amt> : TAY
endmacro

macro iny(amt)
	TYA : CLC : ADC <amt> : TAY
endmacro

macro dex(amt)
	TXA : SEC : SBC <amt> : TAX
endmacro

macro inx(amt)
	TXA : CLC : ADC <amt> : TAX
endmacro

macro lsx(amt)
	TXA : LSR #<amt> : TAX
endmacro

macro lsy(amt)
	TYA : LSR #<amt> : TAY
endmacro

macro asx(amt)
	TXA : ASL #<amt> : TAX
endmacro

macro asy(amt)
	TYA : ASL #<amt> : TAY
endmacro

macro asl(addr, amt)
	LDA <addr> : ASL #<amt> : STA <addr>
endmacro

macro lsr(addr, amt)
	LDA <addr> : LSR #<amt> : STA <addr>
endmacro

macro sub(load, amt, store)						;substracts a value from an address by a specified amount, and stores it elsewhere
	LDA <load> : SEC : SBC <amt> : STA <store>
endmacro

macro add(load, amt, store)
	LDA <load> : CLC : ADC <amt> : STA <store>
endmacro

macro adc(amt)									;just makes it faster to add things when you also need to clear the counter
	CLC : ADC <amt>
endmacro

macro sbc(amt)
	SEC : SBC <amt>
endmacro

macro divide(dvsr, quot, rmdr)					;divides a number in A by dvsr and stores the quotient and remainder where specified
	STA !R_Dividend
	SEP #$20
	LDA <dvsr> : STA !R_Divisor : !wait_16
	REP #$20
	LDA !R_Quotient  : STA <quot>
	LDA !R_Remainder : STA <rmdr>
endmacro

macro divide_alt(dvsr)
	STA !R_Dividend
	SEP #$20
	LDA <dvsr> : STA !R_Divisor : !wait_16
	REP #$20
	LDA !R_Quotient
endmacro

macro divide_mod(dvsr)
	STA !R_Dividend
	SEP #$20
	LDA <dvsr> : STA !R_Divisor : !wait_16
	REP #$20
	LDA !R_Remainder
endmacro

macro multiply(mlp)
	SEP #$20
	STA !R_MultiplicandA
	LDA <mlp> : STA !R_MultiplicandB
   !wait_8
	REP #$20
	LDA !R_Product
endmacro

macro multiply16(mlp)
	STA !W_MultiplandA
	LDA <mlp> : STA !W_MultiplandB
	JSL !Multiply16
	LDA !W_Product
endmacro

macro right()									;moves one block to the right in the level tilemap (used for automorph and bomb collision)
	INX #2
endmacro

macro down()
	TXA
	CLC : ADC !W_Room_width : ADC !W_Room_width
	TAX
endmacro

macro left()
	DEX #2
endmacro

macro up()
	TXA
	SEC : SBC !W_Room_width : SBC !W_Room_width
	TAX
endmacro

macro dud_sprite(x,y,t)							;draws one of a few random sprites, with x/y, type t, and a palette (usually 0 since most of the sprites are from misc vram)
	LDA <x> : STA $12
	LDA <y> : STA $14
	LDA <t> : STA $16
	STZ $18
	JSL $B4BC26
endmacro

macro random(floor, ceiling, max)				;leaves a random number between floor and ceiling in A, but does not have any sort of safety fuse, so be careful, it might slow the game down if used poorly
	-
	JSL !Random_num : AND <max>					;max must be either FFFF,0FFF,00FF, or 000F, and is used to mask the part of the number needed
	CMP <floor> : BMI -							;for example, if you want a number between 55 and 61, you don't also want 155 to 161 and so on
	CMP <ceiling> : BEQ + : BPL -				;so you would set max to 00FF or 003D if you want to be extra specific
	+
endmacro

macro oam(xx,nn,yy,tt,pp)						;just making it easier to write out oam data
	db $<xx>,$<nn>,$<yy>,$<tt>,$<pp>
endmacro






























