; --- Scyzer (with macro by Quote58) ---

;for each item, you just need to specify which type of sound, followed by which effect
;example: %play("Special", "Explode") will play an explosion sound ($25) from the SpecialFX library

macro play(type, effect)
	dw !Instr<type>FX : db !Arg<effect>
endmacro

; ::: Open Item PLMs :::
org $84E0B3 : %play("Item", "Click")	;Energy Tank
org $84E0D8 : %play("Item", "Click") 	;Missile
org $84E0FD : %play("Item", "Click")	;Super Missile
org $84E122 : %play("Item", "Click")	;Powerbomb
org $84E14F : %play("Item", "Click")	;Bombs
org $84E17D : %play("Item", "Click")	;Charge beam
org $84E1AB : %play("Item", "Click")	;Ice Beam
org $84E1D9 : %play("Item", "Click")	;High Jump
org $84E207 : %play("Item", "Click")	;Speed Booster
org $84E235 : %play("Item", "Click")	;Wave Beam
org $84E263 : %play("Item", "Click")	;Spazer Beam
org $84E291 : %play("Item", "Click")	;Spring Ball
org $84E2C3 : %play("Item", "Click")	;Varia Suit (I put no sound here because it plays after the message box)
org $84E2F8 : %play("Item", "Click")	;Gravity Suit
org $84E32D : %play("Item", "Click")	;X-ray
org $84E35A : %play("Item", "Click")	;Plasma Beam
org $84E388 : %play("Item", "Click")	;Grapple Beam
org $84E3B5 : %play("Item", "Click")	;Space Jump
org $84E3E3 : %play("Item", "Click")	;Screw Attack
org $84E411 : %play("Item", "Click")	;Morph Ball
org $84E43F : %play("Item", "Click")	;Reserve Tank

; ::: Item PLMs in Chozo Ball :::
org $84E46F : %play("Item", "Click")	;Chozo Energy Tank
org $84E4A1 : %play("Item", "Click")	;Chozo Missile
org $84E4D3 : %play("Item", "Click")	;Chozo Super Missile
org $84E505 : %play("Item", "Click")	;Chozo Powerbomb
org $84E53F : %play("Item", "Click")	;Chozo Bombs
org $84E57A : %play("Item", "Click")	;Chozo Charge Beam
org $84E5B5 : %play("Item", "Click")	;Chozo Ice Beam
org $84E5F0 : %play("Item", "Click")	;Chozo High Jump
org $84E62B : %play("Item", "Click")	;Chozo Speed Booster
org $84E66F : %play("Item", "Click")	;Chozo Wave Beam
org $84E6AA : %play("Item", "Click")	;Chozo Spazer Beam
org $84E6E5 : %play("Item", "Click")	;Chozo Spring Ball
org $84E720 : %play("Item", "Click")	;Chozo Varia Suit
org $84E762 : %play("Item", "Click")	;Chozo Gravity Suit
org $84E7A4 : %play("Item", "Click")	;Chozo X-ray
org $84E7DE : %play("Item", "Click")	;Chozo Plasma Beam
org $84E819 : %play("Item", "Click")	;Chozo Grapple Beam
org $84E853 : %play("Item", "Click")	;Chozo Space Jump
org $84E88E : %play("Item", "Click")	;Chozo Screw Attack
org $84E8C9 : %play("Item", "Click")	;Chozo Morph Ball
org $84E904 : %play("Item", "Click")	;Chozo Reserve Tank

; ::: Item PLMs Hidden in Scenery :::
org $84E93A : %play("Item", "Click")	;Scenery Energy Tank
org $84E972 : %play("Item", "Click")	;Scenery Missile
org $84E9AA : %play("Item", "Click")	;Scenery Super Missile
org $84E9E2 : %play("Item", "Click")	;Scenery Powerbomb
org $84EA22 : %play("Item", "Click")	;Scenery Bombs
org $84EA63 : %play("Item", "Click")	;Scenery Charge Beam
org $84EAA4 : %play("Item", "Click")	;Scenery Ice Beam
org $84EAE5 : %play("Item", "Click")	;Scenery High Jump
org $84EB26 : %play("Item", "Click")	;Scenery Speed Booster
org $84EB67 : %play("Item", "Click")	;Scenery Wave Beam
org $84EBA8 : %play("Item", "Click")	;Scenery Spazer Beam
org $84EBE9 : %play("Item", "Click")	;Scenery Spring Ball
org $84EC2A : %play("Item", "Click")	;Scenery Varia Suit
org $84EC72 : %play("Item", "Click")	;Scenery Gravity Suit
org $84ECBA : %play("Item", "Click")	;Scenery X-ray
org $84ECFA : %play("Item", "Click")	;Scenery Plasma Beam
org $84ED3B : %play("Item", "Click")	;Scenery Grapple Beam
org $84ED7B : %play("Item", "Click")	;Scenery Space Jump
org $84EdbC : %play("Item", "Click")	;Scenery Screw Attack
org $84EDFD : %play("Item", "Click")	;Scenery Morph Ball
org $84EE3E : %play("Item", "Click")	;Scenery Reserve Tank