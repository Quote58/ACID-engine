
; :::							 :::
; ::: Decompression Optimization :::
; :::							 :::
org $C29AF1 : DB $FE					;if the decompression optimization is being applied, and the level data for Draygon has not been changed, include this
org $80B0FF
;Decompression optimization by Kejardon (with some additional comments and formatting by Quote58/PJboy)
;saves 0x14D bytes and a ton of cycles per loop
;this is almost entirely due to using an indirect load instead of an indexed one
;ie. lda (addr) : inc addr
;instead of:
;    phx : ldx addr
;	 lda 0000,x : inx
;	 stx addr : plx
;
; -- Decompression in super metroid --
;Compression/decompression is essentially like a simple compiler/program, this is because
;data is stored as a series of instructions and arguments (usually only one, for size) for how to reconstruct the data
;and as a result, to decompress it, this routine reads instructions with their arguments and performs operations accordingly (creates a set of data), like a program
;for example, if you wanted to store 0,1,2,3,4,5, then you would use instruction 3, which will decompress as an accending sequence
;in total, there are 8 instructions that can be used to compress data, not including the terminator instruction (marks the end of data)
;However, instructions 4,5,6, and 7 are all similar enough that they are combined into one function with internal branches
; -- Breakdown of instructions and their bit storage (credit to Pjboy for this table) --
;t = 0 | (111000ss ssssssss / 000sssss)                   | Direct copy                | Copies the next s + 1 bytes from ROM as uncompressed data
;t = 1 | (111001ss ssssssss / 001sssss) llllllll          | Byte fill                  | Copies the byte l s + 1 times (a la RLE)
;t = 2 | (111010ss ssssssss / 010sssss) llllllll hhhhhhhh | Word fill                  | Copies the word hl for s + 1 bytes ((s + 1) / 2 words and the byte l if s + 1 is odd)
;t = 3 | (111011ss ssssssss / 011sssss) bbbbbbbb          | Sequence                   | Writes an ascending sequence starting with b for s + 1 bytes (good for tilemaps)
;t = 4 | (111100ss ssssssss / 100sssss) pppppppppppppppp  | Indirect copy              | Copies the decompressed data beginning at offset p from the start for s + 1 bytes
;t = 5 | (111101ss ssssssss / 101sssss) pppppppppppppppp  | Negated indirect copy      | Copies the decompressed data beginning at offset p from the start and negates it (XORs it with FFh) for s + 1 bytes
;t = 6 | (111110ss ssssssss / 110sssss) oooooooooooooooo  | Sliding dictionary         | Copies the decompressed data beginning o bytes previous of the current position for s + 1 bytes (a la LZ77)
;t = 7 |  111111ss ssssssss             oooooooooooooooo  | Negated sliding dictionary | Copies the decompressed data beginning o bytes previous of the current position and negates it for s + 1 bytes
;      |  11111111                                        | Terminator                 | Ends compressed data

Decompress:
	LDA $02,s : STA $45
	LDA $01,s : STA $44					;address of target address for data into $44
	CLC : ADC #$0003
	STA $01,s							;skip target address for RTL
	LDY #$0001
	LDA [$44],y : STA $4C
	INY
	LDA [$44],y : STA $4D
.alt
	PHP : PHB
	SEP #$20 : REP #$10					;only useful if JSL goes to Decompress_alt
	LDA $49 : PHA
	PLB
	STZ $50
	LDY #$0000 : BRA .next_byte
.end
	PLB : PLP
	RTL
	
.next_byte
	LDA ($47) : INC $47
	BNE +
	JSR .inc_bank_2
	+
	STA $4A
	CMP #$FF : BEQ .end
	CMP #$E0 : BCC ++
	ASL #3
	AND #$E0 : PHA
	LDA $4A
	AND #$03 : XBA
	LDA ($47) : INC $47
	BNE +
	JSR .inc_bank_2
	+
	BRA +++
	++
	AND #$E0 : PHA
	TDC									;transfers the direct page register to A
	LDA $4A : AND #$1F
	+++
	TAX : INX
		  PLA : BMI .instr_4567			;determines which instruction to use (using BMI saves extra cycles)
			    BEQ .instr_copy
	CMP #$20  : BEQ .instr_fill_byte
	CMP #$40  : BEQ .instr_fill_word

.instr_sequence							;X = 3; Store an ascending number (starting with the value of the next byte) Y times
	LDA ($47) : INC $47
	BNE +
	JSR .inc_bank_2
	+ -
	STA [$4C],y
	INC : INY
	DEX : BNE -
	JMP .next_byte

.instr_copy								;X = 0; Directly copy Y bytes
	LDA ($47) : INC $47
	BNE +
	JSR .inc_bank_2
	+
	STA [$4C],y
	INY
	DEX : BNE .instr_copy
	JMP .next_byte

.instr_fill_byte						;X = 1; Copy the next byte Y times
	LDA ($47) : INC $47
	BNE +
	JSR .inc_bank_2
	+ -
	STA [$4C],y
	INY
	DEX : BNE -
	JMP .next_byte
	
.instr_fill_word						;X = 2; Copy the next two bytes, one at a time, for the next Y bytes
	LDA ($47) : INC $47
	BNE +
	JSR .inc_bank_2
	+
	XBA									;grab the second byte
	LDA ($47) : INC $47
	BNE +
	JSR .inc_bank_2
	+
	XBA
	REP #$20
	-
	STA [$4C],y
	INY
	DEX : BEQ ++
	INY
	DEX : BNE -
	++
	SEP #$20
	JMP .next_byte

.instr_4567								;X = 4; Copy Y bytes starting from a given address in the decompressed data
										;X = 5; || but also invert the bytes
										;X = 6 or 7; see branch below
	CMP #$C0 : AND #$20 : STA $4F
	BCS +++

	LDA ($47) : INC $47
	BNE +
	JSR .inc_bank_2
	+
	XBA
	LDA ($47) : INC $47
	BNE +
	JSR .inc_bank_2
	+
	XBA
	REP #$21
	ADC $4C : STY $44
	SEC
	--
	SBC $44 : STA $44
	SEP #$20
	LDA $4E : BCS +
	DEC
	+
	STA $46
	+									;when would this ever branch???
	LDA $4F : BNE +						;inverted
	-
	LDA [$44],y : STA [$4C],y
	INY
	DEX : BNE -
	JMP .next_byte
	+ -
	LDA [$44],y : EOR #$FF : STA [$4C],y
	INY
	DEX : BNE -
	JMP .next_byte
	+++									;X = 6; Copy Y bytes starting from a given number of bytes ago in the decompressed data
										;X = 7; || but also invert the bytes
	TDC
	LDA ($47) : INC $47
	BNE +
	JSR .inc_bank_2
	+
	REP #$20
	STA $44
	LDA $4C : BRA --

.inc_bank_2
	INC $48 : BNE +
	PHA
	PHB
	PLA : INC : PHA
	PLB
	LDA #$80 : STA $48
	PLA
	+
	RTS