; ::: Green doors :::
.left_close
   %close(!C_Flash_wait, !C_Close_speed, $A84B, $A83F, $A833, !ClearL)
	skip 27

.left_flash
   %flash(!C_Flash_speed, $A9B3, $A827)

.left_open
   %open(!C_Open_speed, $A833, $A83F, $A84B, !ClearL)

.right_close
   %close(!C_Flash_wait, !C_Close_speed, $A87B, $A86F, $A863, !ClearR)
	skip 27

.right_flash
   %flash(!C_Flash_speed, $A9EF, $A857)

.right_open
   %open(!C_Open_speed, $A863, $A86F, $A87B, !ClearR)

.up_close
   %close(!C_Flash_wait, !C_Close_speed, $A8AB, $A89F, $A893, !ClearU)
	skip 27

.up_flash
   %flash(!C_Flash_speed, $AA2B, $A887)

.up_open
   %open(!C_Open_speed, $A893, $A89F, $A8AB, !ClearU)

.down_close
   %close(!C_Flash_wait, !C_Close_speed, $A8DB, $A8CF, $A8C3, !ClearD)
	skip 27

.down_flash
   %flash(!C_Flash_speed, $AA67, $A8B7)

.down_open
   %open(!C_Open_speed, $A8C3, $A8CF, $A8DB, !ClearD)
; ::: ----------- :::