; ::: Enemy Projectile Headers :::
;projectile headers are in the format:
;org $86xxxx
;dw init, main, tilemap, yyxx, contact_flags+damage, samus_contact_gfx, projectile_contact_gfx
;where the contact_flags+damage are an array in the form:
;0000 0000 0000 0000
;|||| \--------------damage value
;|||\----------------invisibility
;||\-----------------intangibility
;|\------------------invulnerability
;\-------------------collision detection with samus projectiles

; --- Begrimed (formatted by Quote58) ---
; ::: Enemy Projectile Headers :::
!SmallExplosion = $D064

;cactus spikes
org $86DAFE : dw $D992, $D9DB, $D92E, $0202, $8005, $0000, !SmallExplosion

;lava dragon fireballs
org $86B5CB : dw $B4EF, $B535, $B4BF, $0202, $800A, $0000, !SmallExplosion

;skree rock 1
org $868BC2 : dw $8ACD, $8B5D, $8ABD, $0202, $8004, $0000, !SmallExplosion

;skree rock 2
org $868BD0 : dw $8AF1, $8B5D, $8ABD, $0202, $8004, $0000, !SmallExplosion

;skree rock 3
org $868BDE : dw $8B15, $8B5D, $8ABD, $0202, $8004, $0000, !SmallExplosion

;skree rock 4
org $868BEC : dw $8B39, $8B5D, $8ABD, $0202, $8004, $0000, !SmallExplosion

;metal skree rock 1
org $868BFA : dw $8ACD, $8B5D, $8AC5, $0202, $8004, $0000, !SmallExplosion

;metal skree rock 2
org $868C08 : dw $8AF1, $8B5D, $8AC5, $0202, $8004, $0000, !SmallExplosion

;metal skree rock 3
org $868C16 : dw $8B15, $8B5D, $8AC5, $0202, $8004, $0000, !SmallExplosion

;metal skree rock 4
org $868C24 : dw $8B39, $8B5D, $8AC5, $0202, $8004, $0000, !SmallExplosion

;mini kraid spikes, left
org $869DBE : dw $9E46, $9E83, $9DE0, $0204, $8006, $0000, !SmallExplosion

;mini kraid spikes, right
org $869DCC : dw $9E4B, $9E83, $9DE6, $0204, $8006, $0000, !SmallExplosion

;mini kraid rocks
org $869DB0 : dw $9DEC, $9E1E, $9DDA, $0404, $8014, $0000, !SmallExplosion

;fune fireballs
org $86DFCA : dw $DED6, $DF39, $DE96, $0C0F, $803C, $0000, !SmallExplosion

;nami fireballs
org $86DFBC : dw $DED6, $DF39, $DE96, $0C0F, $806C, $0000, !SmallExplosion

;maridia grapple puffer spines
org $86D298 : dw $D23A, $D263, $D208, $0404, $8014, $0000, !SmallExplosion

;wrecked ship robot attack 1
org $86D2A6 : dw $D341, $D3BF, $D2EC, $0C0C, $8014, $0000, !SmallExplosion

;wrecked ship robot attack 2
org $86D2B4 : dw $D32E, $D3BF, $D2EC, $020F, $8014, $0000, !SmallExplosion

;wrecked ship robot attack 3
org $86D2C2 : dw $D30C, $D3BF, $D2EC, $0C0C, $8014, $0000, !SmallExplosion

;wrecked ship robot attack 4
org $86D2D0 : dw $D341, $D3BF, $D2EC, $0C0C, $8014, $0000, !SmallExplosion

;wrecked ship robot attack 5
org $86D2DE : dw $D30C, $D3BF, $D2EC, $0C0C, $8014, $0000, !SmallExplosion

;walking dragon fireballs
org $869E90 : dw $9EB2, $9EFF, $9E9E, $0404, $8014, $0000, !SmallExplosion

;wrecked ship falling sparks
org $86F498 : dw $F391, $F3F0, $F353, $0404, $8005, $0000, !SmallExplosion

;kihunter attack, left
org $86CF18 : dw $CF90, $CFF7, $CF34, $0802, $8014, $0000, !SmallExplosion

;kihunter attack, right
org $86CF26 : dw $CFA6, $CFF7, $CF6E, $0802, $8014, $0000, !SmallExplosion

;botwoon projectile
org $86EC48 : dw $EBC6, $EC05, $EBAE, $0202, $9060, $0000, !SmallExplosion

