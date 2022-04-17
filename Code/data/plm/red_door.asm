; ::: Red doors :::
.left_close
   %close(!C_Flash_wait, !C_Close_speed, $A90B, $A8FF, $A8F3, !ClearL)
	skip 30

.left_flash
   %flash(!C_Flash_speed, $A9B3, $A8E7)

.left_open
   %open(!C_Open_speed, $A8F3, $A8FF, $A90B, !ClearL)

.right_close
   %close(!C_Flash_wait, !C_Close_speed, $A93B, $A92F, $A923, !ClearR)
	skip 30

.right_flash
   %flash(!C_Flash_speed, $A9EF, $A917)

.right_open
   %open(!C_Open_speed, $A923, $A92F, $A93B, !ClearR)

.up_close
   %close(!C_Flash_wait, !C_Close_speed, $A96B, $A95F, $A953, !ClearU)
	skip 30

.up_flash
   %flash(!C_Flash_speed, $AA2B, $A947)

.up_open
   %open(!C_Open_speed, $A953, $A95F, $A96B, !ClearU)

.down_close
   %close(!C_Flash_wait, !C_Close_speed, $A99B, $A98F, $A983, !ClearD)
	skip 30

.down_flash
   %flash(!C_Flash_speed, $AA67, $A977)

.down_open
   %open(!C_Open_speed, $A983, $A98F, $A99B, !ClearD)
; ::: ---------- :::