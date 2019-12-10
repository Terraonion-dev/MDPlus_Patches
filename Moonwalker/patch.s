# several game addresses need to be patched (and nop adjusted):
# 1514E -> jsr 6FF00  send sound code at %d0. Codes > 0x80 are music
# 1982 -> jsr 6FF08  resume music
# 193a -> jsr 6FF04  pause music
# 14FA0 -> jsr 6FF0C  reset z80, so stop (pause) music


#entry at 6FF00
	bra PlayCode
#entry at 6FF04
	bra Pause
#entry at 6FF08
	bra Resume
#entry at 6FF0C
	bra Reset
#for expansion
	bra Interrupt
	nop
	nop

PlayCode:
#music codes
	cmp.b #0xE0,%d0
	beq Pause

	cmp.b #0x90,%d0
	bcc skip

	move.w #0xCD54,(0x03F7FA)
#hard stop current track
	move.w #0x1300, (0x03F7FE)
	move.w #0x0000,(0x03F7FA)


	cmp.b #0x86,%d0
	bcc skip

	cmp.b #0x00,(0xFFFFE0)
	bne skip2
	
	and.w #0x000F,%d0

#open command overlay
	move.w #0xCD54,(0x03F7FA)

#send track with command 12, play with loop
	or.w #0x1200, %d0

	move.w %d0, (0x03F7FE)

#close command overlay
	move.w #0x0000,(0x03F7FA)

skip2:
	move #0xE0,%d0

skip:	
#play as is
	move.l #0xFFD30A,%a1
	rts

playfromcd:

Pause:

	move.b #0x3F,(0xFFFFE0)

#open command overlay
	move.w #0xCD54,(0x03F7FA)

#Pause/stop with fade
	move.w #0x1330, %d0

	move.w %d0, (0x03F7FE)

#close command overlay
	move.w #0x0000,(0x03F7FA)

	move #0xE0,%d0

	jmp skip

	rts

Resume:

	rts

Reset:
	
#open command overlay
	move.w #0xCD54,(0x03F7FA)

#Pause/stop with fade
	move.w #0x1330, %d0

	move.w %d0, (0x03F7FE)

#close command overlay
	move.w #0x0000,(0x03F7FA)

# restore patched opcode
	move.l #0xFFDE80,%a6
	move #0,%d7

	rts


Interrupt:

	move.b (0xFFFFE0),%d0
	beq nofade

	add.b #-1,%d0
	move.b %d0,(0xFFFFE0)

nofade:

	jsr 0x60166
	rts
