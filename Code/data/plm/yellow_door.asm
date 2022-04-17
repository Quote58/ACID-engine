; ::: Yellow doors :::
.left_close
   %close(!C_Flash_wait, !C_Close_speed, $A78B, $A77F, $A773, !ClearL)
	skip 31

.left_flash
   %flash(!C_Flash_speed, $A9B3, $A767)

.left_open
   %open(!C_Open_speed, $A773, $A77F, $A78B, !ClearL)

.right_close
   %close(!C_Flash_wait, !C_Close_speed, $A7BB, $A7AF, $A7A3, !ClearR)
	skip 31

.right_flash
   %flash(!C_Flash_speed, $A9EF, $A797)

.right_open
   %open(!C_Open_speed, $A7A3, $A7AF, $A7BB, !ClearR)

.up_close
   %close(!C_Flash_wait, !C_Close_speed, $A7EB, $A7DF, $A7D3, !ClearU)
	skip 27

.up_flash
   %flash(!C_Flash_speed, $AA2B, $A7C7)

.up_open
   %open(!C_Open_speed, $A7D3, $A7DF, $A7EB, !ClearU)

.down_close
   %close(!C_Flash_wait, !C_Close_speed, $A81B, $A80F, $A803, !ClearD)
	skip 31

.down_flash
   %flash(!C_Flash_speed, $AA67, $A7F7)

.down_open
   %open(!C_Open_speed, $A803, $A80F, $A81B, !ClearD)
; ::: ----------- :::