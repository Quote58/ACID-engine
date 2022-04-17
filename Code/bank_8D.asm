lorom

; --- Quote58 ---
; this is the sprite for the small energy pickup, it needed to be adjusted for the extra beam space
org $8DC064 : dw $0001 : %oam(FC,01,FC,43,3A)
			  dw $0001 : %oam(FC,01,FC,40,3A)
			  dw $0001 : %oam(FC,01,FC,41,3A)
			  dw $0001 : %oam(FC,01,FC,42,3A)
org $8DFFF1
; free space in bank $8D

print "End of free space (8DFFFF): ", pc