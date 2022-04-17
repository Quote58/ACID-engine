lorom

; tileset pointers
; dl tiletable, tileset, palette
org $8FE6A2
	dl $C1B6F6, $BAC629, $C2AD7C	;0: Upper Crateria
	dl $C1B6F6, $BAC629, $C2AE5D	;1: Red Crateria
	dl $C1BEEE, $BAF911, $C2AF43	;2: Lower Crateria
	dl $C1BEEE, $BAF911, $C2B015	;3: Old Tourian
	dl $C1C5CF, $BBAE9E, $C2B0E7	;4: Wrecked Ship - power on
	dl $C1C5CF, $BBAE9E, $C2B1A6	;5: Wrecked Ship - power off
	dl $C1CFA6, $BBE6B0, $C2B264	;6: Green/blue Brinstar
	dl $C1D8DC, $BCA5AA, $C2B35F	;7: Red Brinstar / Kraid's lair
	dl $C1D8DC, $BCA5AA, $C2B447	;8: Pre Tourian entrance corridor
	dl $C1E361, $BDC3F9, $C2B5E4	;9: Heated Norfair
	dl $C1E361, $BDC3F9, $C2B6BB	;Ah: Unheated Norfair
	dl $C1F4B1, $BEB130, $C2B83C	;Bh: Sandless Maridia
	dl $C2855F, $BEE78D, $C2B92E	;Ch: Sandy Maridia
	dl $C29B01, $BFD414, $C2BAED	;Dh: Tourian
	dl $C29B01, $BFD414, $C2BBC1	;Eh: Mother Brain's room
	dl $C2A75E, $C0B004, $C2C104	;Fh: Blue Ceres
	dl $C2A75E, $C0B004, $C2C1E3	;10h: White Ceres
	dl $C2A75E, $C0E22A, $C2C104	;11h: Blue Ceres elevator
	dl $C2A75E, $C0E22A, $C2C1E3	;12h: White Ceres elevator
	dl $C2A75E, $C18DA9, $C2C104	;13h: Blue Ceres Ridley's room
	dl $C2A75E, $C18DA9, $C2C1E3	;14h: White Ceres Ridley's room
	dl $C2A27B, $C0860B, $C2BC9C	;15h: Map room / Tourian entrance
	dl $C2A27B, $C0860B, $C2BD7B	;16h: Wrecked Ship map room - power off
	dl $C2A27B, $C0860B, $C2BE58	;17h: Blue refill room
	dl $C2A27B, $C0860B, $C2BF3D	;18h: Yellow refill room
	dl $C2A27B, $C0860B, $C2C021	;19h: Save room
	dl $C1E189, $BCDFF0, $C2B510	;1Ah: Kraid's room
	dl $C1F3AF, $BDFE2A, $C2B798	;1Bh: Crocomire's room
	dl $C2960D, $BF9DEA, $C2BA2C	;1Ch: Draygon's room

; pointers for above table
org $8FE7A7
	dw $E6A2, $E6AB, $E6B4, $E6BD, $E6C6, $E6CF, $E6D8, $E6E1, $E6EA, $E6F3, $E6FC, $E705, $E70E, $E717, $E720
	dw $E729, $E732, $E73B, $E744, $E74D, $E756, $E75F, $E768, $E771, $E77A, $E783, $E78C, $E795, $E79E

; pointers to music tracks
org $8FE7E1
	dl $CF8000		;0   - SPC engine
	dl $D0E20D		;3   - Title sequence
	dl $D1B62A		;6   - Empty Crateria
	dl $D288CA		;9   - Lower Crateria
	dl $D2D9B6		;Ch  - Upper Crateria
	dl $D3933C		;Fh  - Green Brinstar
	dl $D3E812		;12h - Red Brinstar
	dl $D4B86C		;15h - Upper Norfair
	dl $D4F420		;18h - Lower Norfair
	dl $D5C844		;1Bh - Maridia
	dl $D698B7		;1Eh - Tourian
	dl $D6EF9D		;21h - Mother Brain
	dl $D7BF73		;24h - Boss fight 1
	dl $D899B2		;27h - Boss fight 2
	dl $D8EA8B		;2Ah - Miniboss fight
	dl $D9B67B		;2Dh - Ceres
	dl $D9F5DD		;30h - Wrecked Ship
	dl $DAB650		;33h - Zebes boom
	dl $DAD63B		;36h - Intro
	dl $DBA40F		;39h - Death
	dl $DBDF4F		;3Ch - Credits
	dl $DCAF6C		;3Fh - "The last Metroid is in captivity"
	dl $DCFAC7		;42h - "The galaxy is at peace"
	dl $DDB104		;45h - Shitroid (same as boss fight 2)
	dl $DE81C1  	;48h - Samus theme (same as upper Crateria)

org $8FE99B
; free space in bank $8F

Scroll_pointers:
; --- DSO ---
print "\n--- Door Scrolls ---"
print "Big Metroid: ", pc
.big_metroid
	STZ $0A66							;if you're shinesparking while being grabbed and also exiting the room, your movement can stay in slow motion, this fixes that
	RTS
print "--- End of Door Scrolls ---\n"

print "End of free space (8FFFFF): ",pc