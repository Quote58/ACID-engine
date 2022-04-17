Scroll_pointers:
print "shaktool door scroll: ",pc
.shaktool
	LDA #$000D
	JSL !Set_event
	RTS