; ::: Grey doors :::
.left_close
   %close(!C_Flash_wait, !C_Close_speed, $A6CB, $A6BF, $A6B3, !ClearL)
	skip 32

.left_flash
   %flash(!C_Flash_speed, $A9B3, $A6A7)
	skip 5

.left_open
   %open(!C_Open_speed, $A6B3, $A6BF, $A6CB, !ClearL)

.right_close
   %close(!C_Flash_wait, !C_Close_speed, $A6FB, $A6EF, $A6E3, !ClearR)
	skip 32

.right_flash
   %flash(!C_Flash_speed, $A9EF, $A6D7)
	skip 5

.right_open
   %open(!C_Open_speed, $A6E3, $A6EF, $A6FB, !ClearR)

.up_close
   %close(!C_Flash_wait, !C_Close_speed, $A72B, $A71F, $A713, !ClearU)
	skip 32

.up_flash
   %flash(!C_Flash_speed, $AA2B, $A707)
	skip 5

.up_open
   %open(!C_Open_speed, $A713, $A71F, $A72B, !ClearU)

.down_close
   %close(!C_Flash_wait, !C_Close_speed, $A75B, $A74F, $A743, !ClearD)
	skip 32

.down_flash
   %flash(!C_Flash_speed, $AA67, $A737)
	skip 5

.down_open
   %open(!C_Open_speed, $A743, $A74F, $A75B, !ClearD)
; ::: ---------- :::