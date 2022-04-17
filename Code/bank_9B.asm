lorom

org $9BC09D : LDA Flare_index_right
org $9BC0A9 : LDA Flare_index_left
org $9BBFB1 : CMP !C_Max_charge
org $9BD160
; free space until E000

print "End of free space before samus tiles ($9BE000): ", pc

org $9BFDA0
; free space at the end of bank $9B

print "End of free space (9BFFFF): ", pc