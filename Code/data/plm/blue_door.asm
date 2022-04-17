; ::: Blue doors :::
.left_open
   %open(!C_Open_speed, $A9BF, $A9CB, $A9D7, !ClearL)

.left_close
   %close(!C_Flash_wait, !C_Close_speed, $A9D7, $A9CB, $A9BF, !ClearL)
	skip 9
	
.right_open
   %open(!C_Open_speed, $A9FB, $AA07, $AA13, !ClearR)
   
.right_close
   %close(!C_Flash_wait, !C_Close_speed, $AA13, $AA07, $A9FB, !ClearR)
	skip 9
	
.up_open
   %open(!C_Open_speed, $AA37, $AA43, $AA4F, !ClearU)

.up_close
   %close(!C_Flash_wait, !C_Close_speed, $AA4F, $AA43, $AA37, !ClearU)
	skip 9
	
.down_open
   %open(!C_Open_speed, $AA73, $AA7F, $AA8B, !ClearD)

.down_close
   %close(!C_Flash_wait, !C_Close_speed, $AA8B, $AA7F, $AA73, !ClearD)
	skip 9
; ::: ---------- :::