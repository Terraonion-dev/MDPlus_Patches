#entry at FF000
	bra PlayCode
#entry at FF004
	bra PauseResume
#entry at FF008
	nop
	nop
	nop
	nop
#for expansion
	nop
	nop
	nop
	nop

PlayCode:
	cmp.b #0xE0, %d7
	beq fadeout
	cmp.b #0x81, %d7	
	bcs skip
	cmp.b #0x90, %d7	
	bcc skip

playfromcd:
#open command overlay
	move.w #0xCD54,(0x03F7FA)

	move.b %d7,%d0
	and.w #0x007F,%d0
#send track with command 12, play with loop
	or.w #0x1200, %d0

	move.w %d0, (0x03F7FE)

#close command overlay
	move.w #0x0000,(0x03F7FA)
	rts

#play as is
skip:
	move.b %d7,(0xa01c05)
	rts

fadeout:

	move.w #0xCD54,(0x03F7FA)

#send command 13, pause and fade

	move.w #0x1380, (0x03F7FE)

	move.w #0x0000,(0x03F7FA)

	rts

PauseResume:
	cmp.b #0x80,%d0
	beq resume
	cmp.b #1,%d0
	beq pause

	move.b %d0,(0xa01c0b)
	rts

pause:

	move.w #0xCD54,(0x03F7FA)

#send command 13, pause

	move.w #0x1300, (0x03F7FE)

	move.w #0x0000,(0x03F7FA)

	rts

resume:

	move.w #0xCD54,(0x03F7FA)

#send command 14, resume

	move.w #0x1400, (0x03F7FE)

	move.w #0x0000,(0x03F7FA)

	rts
