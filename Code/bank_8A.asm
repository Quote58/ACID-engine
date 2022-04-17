lorom

; the reason these tilemaps are written out here instead of just data in the rom, is that for the hud to have as much space as possible in as convenient a way as possible
; I felt it made sense to move the location of the animated tiles, and the water/fog tiles in vram
; this also means that the message boxes can cleanly swap out the FX gfx with the extra text for the messages

; *note: these tilemaps could be produced dynamically using instructions for repeating patterns (and for rain/spore it could be partially randomized!)
; so if space in 8A is ever needed, there's a shit ton of it here if you rewrite the FX loading routine to use patterns instead of full tilemaps

; if you want to change how the tilemaps look through smile, just remember the tile numbers have changed, so it'll be a little more difficult to do so...
incsrc Code/data/misc/FX_tilemaps.asm

org $8AE980
; free space in bank $8A

print "End of free space (8AFFFF): ", pc