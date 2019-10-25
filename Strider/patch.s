# several game addresses need to be patched (and nop adjusted):
# B0790 -> jsr FF000  play sound code, >0x80 is music. Sound codes at a0
# xxxx -> jsr FF008  resume music
# xxxx -> jsr FF004  pause music
# B08CE -> jsr FF00C  reset z80, so stop (pause) music


#entry at FF000
	bra PlayCode
#entry at FF004
	bra Pause
#entry at FF008
	bra Resume
#entry at FF00C
	bra Reset
#for expansion
	nop
	nop
	nop
	nop

PlayCode:
	subi.b #0x81, %d0
	bcs  continue

	addi.b #0x1, %d0

	#open command overlay
	move.w #0xCD54,(0x03F7FA)

	and.w #0x00FF, %d0
#send track with command 12, play with loop
	or.w #0x1200, %d0

	move.w %d0, (0x03F7FE)

#close command overlay
	move.w #0x0000,(0x03F7FA)



continue:	
	jmp 0xB05FC

	rts


#unused
Pause:
#call the patched opcode @ 193A

	move.w #0xCD54,(0x03F7FA)

#send command 13, pause

	move.w #0x1300, (0x03F7FE)

	move.w #0x0000,(0x03F7FA)

	rts

#unused
Resume:

	move.w #0xCD54,(0x03F7FA)

#send command 14, resume

	move.w #0x1400, (0x03F7FE)

	move.w #0x0000,(0x03F7FA)


	rts

Reset:
	
	move.w #0xCD54,(0x03F7FA)
	move.w #0x1300, (0x03F7FE)
	move.w #0x0000,(0x03F7FA)

	move.b #0x2B,%d0
	move.b #0x80,%d1
	rts
