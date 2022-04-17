org $A0A8B7 : JSR Store_enemy_health

; --- Quote58 ---
Store_enemy_health:
	STA $0F8C,x
	STA !W_Enemy_health
	PHX
	LDA $0F78,x : TAX
	LDA $A00004,x : STA !W_Enemy_health_max
	PLX
	RTS