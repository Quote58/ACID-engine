lorom

org $89AC00
; --- JAM (based on area palette blend patch by DSO) (reformatted by Quote58) ---
;This edit to the FX loading routine lets you change the palette for your tileset by simply changing the palette blend in the FX
;Blends 80-CF will activate the code, thus giving you 80 alternate palettes that can be shared with all your tilesets
;Palette addresses were simplified:
;-take the palette blend number
;-add $430 to it
;-and multiply by $100 (add two zeros)
;Example:
;Palette blend A5
;A5 + 430 = 4D5
;D5 * 100 = 4D500
;Location: $4D500 ($89D500)
Area_blend:
	CMP #$00D0 : BCS .over_D0
	CMP #$0080 : BCS .new_palette 
.over_D0
	JSR .normal : BRA .end
.new_palette
   %adc(#$0030)
	PHB
	XBA : TAX							;X = location
	LDA #$00FF : LDY #$C200				;Y = destination, A = size
	MVN $897E
	PLB
	NOP #2
.end

org $89AF00
; free space in bank $89
; tons of free space here!
.normal
	TAX
	LDA $89AA02,x : STA $7EC232
	LDA $89AA04,x : STA $7EC234
	LDA $89AA06,x : STA $7EC236
	RTS

print "End of free space (89FFFF): ", pc









