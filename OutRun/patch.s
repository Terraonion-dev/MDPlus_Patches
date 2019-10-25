# several game addresses need to be patched (and nop adjusted):
# 228C -> jsr FF000  send sound code at %d0. Codes > 0x80 are music
# 1982 -> jsr FF008  resume music
# 193a -> jsr FF004  pause music
# 6668 -> jsr FF00C  reset z80, so stop (pause) music


#entry at FF000
	bra PlayCode
#entry at FF004
	bra Pause
#entry at FF008
	bra Resume
	bra Reset
#for expansion
	nop
	nop
	nop
	nop

PlayCode:
#magical sound shower
	cmp.b #0x81, %d0	
	bne nextcode1
	#remap to cd track 1
	move.b #0x1, %d0	
	jmp playfromcd

nextcode1:
#splash wave
	cmp.b #0x82, %d0	
	bne nextcode2
	#remap to cd track 2
	move.b #0x2, %d0	
	jmp playfromcd

nextcode2:
#passing breeze
	cmp.b #0x83, %d0	
	bne nextcode3
	#remap to cd track 3
	move.b #0x3, %d0	
	jmp playfromcd

nextcode3:
#last wave
	cmp.b #0x84, %d0	
	bne nextcode4
	#remap to cd track 4
	move.b #0x4, %d0	
	jmp playfromcd

nextcode4:	
#play as is
	move.b %d0,(0xa01c0a)
	rts

playfromcd:
#open command overlay
	move.w #0xCD54,(0x03F7FA)

#send track with command 12, play with loop
	or.w #0x1200, %d0

	move.w %d0, (0x03F7FE)

#close command overlay
	move.w #0x0000,(0x03F7FA)
	rts


Pause:
#call the patched opcode @ 193A
	move.b  #1,(0xA01C10)

Pause2:
	move.w #0xCD54,(0x03F7FA)

#send command 13, pause

	move.w #0x1300, (0x03F7FE)

	move.w #0x0000,(0x03F7FA)

	rts

Resume:

	move.w #0xCD54,(0x03F7FA)

#send command 14, resume

	move.w #0x1400, (0x03F7FE)

	move.w #0x0000,(0x03F7FA)

#call the patched opcode @ 1982
	move.b  #0x80,(0xA01C10)	

	rts

Reset:
	move.w #0,0xa11200
	bra Pause2
