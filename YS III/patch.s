# several game addresses need to be patched (and nop adjusted):
# 5BC -> jsr FFE00  d6: 0-> music   d6=0 && d7=FD, stop, else, d7 contains the sound track (1 to 30 with gaps)


#entry at FF000
	bra PlayCode
#entry at FF004
	nop 
	nop
#entry at FF008
	nop 
	nop
#entry at FF00C
	nop 
	nop
#for expansion
	nop	
	nop
#for expansion
	nop	
	nop


codetable:
#values: 0: play from console, 1: cdda loop play, 2: cdda non loop play
# 0 Unused
.byte 0
# 1 Dancing on the road
.byte 1
# 2 Promonition
.byte 1
# 3 WELCOME
.byte 1
# 4 Quiet moment
.byte 1
# 5 Prolog
.byte 1
# 6 Sealing Time
.byte 1
# 7 Death Beat
.byte 1
# 8 Sentimental Twilight
.byte 1
# 9 Black Monster
.byte 1
# 10 Death's Shock
.byte 1
# 11 Final Fight
.byte 1
# 12 Sarina village
.byte 1
# 13 Winged Boy
.byte 1
# 14 Be careful
.byte 1
# 15 Alcaino Ruins
.byte 1
# 16 Heated Battle
.byte 1
# 17 Black set up
.byte 1
# 18 Fighting Soul
.byte 1
# 19 Valestine Castle
.byte 1
# 20 Pray for Mercy
.byte 1
# 21 Key of light
.byte 1
# 22
.byte 0
# 23
.byte 0
# 24
.byte 0
# 25
.byte 0
# 26
.byte 0
# 27
.byte 0
# 28
.byte 0
# 29
.byte 0
# 30
.byte 0
# 31
.byte 0
# 32
.byte 0
# 33 Fate Tower
.byte 1
# 34 LOOK AT THIS!
.byte 1
# 35 Morning of the journey
.byte 1
# 36
.byte 0
# 37 Fleeting Dream
.byte 1
# 38
.byte 0
# 39
.byte 0
# 40
.byte 0
# 41
.byte 0
# 42
.byte 0
# 43 Get item
.byte 2
# 44 Introduction!!
.byte 2
# 45 The Theme of Chester
.byte 1
# 46 Wanderers from Ys
.byte 1
# 47 Dear my brother
.byte 1
# 48 My Dear Elena
.byte 1
#align
.byte 0


PlayCode:
	#d6 has some special meaning, I thought 0 was for music codes but it isn't, as some codes use different values (probably should be ignored?)
	cmp.b #0x18,%d6
	beq code18
	cmp.b #0x14,%d6
	beq code18
	cmp.b #0x40,%d6
	beq code18

	cmp.b #0x00,%d6
	bne dontskip

code18:
	cmp.b #0xFD, %d7
	beq stop

	cmp.b #0x31, %d7
	bge dontskip

	and.w #0x00FF, %d7

	move.b %pc@(codetable,%d7), %d6

#genesis tune code
	cmp.b #0x00,%d6
	beq stopfast

#stop genesis track
	move.b #0x00,0xA01FFE
	move.b #0xFE,0xA01FFF

#no loop
	cmp.b #0x02,%d6
	beq noloop

	#open command overlay
	move.w #0xCD54,(0x03F7FA)

#send track with command 12, play with loop
	or.w #0x1200, %d7
	move.w %d7, (0x03F7FE)
#close command overlay
	move.w #0x0000,(0x03F7FA)

#return without sending the commands to the z80
	rts

noloop:
	#open command overlay
	move.w #0xCD54,(0x03F7FA)
#send track with command 11, play without loop
	or.w #0x1100, %d7
	move.w %d7, (0x03F7FE)
#close command overlay
	move.w #0x0000,(0x03F7FA)

#return without sending the commands to the z80
	rts


stop:
	move.w #0xCD54,(0x03F7FA)
	# stop with 3 seconds fadeout (when implemented)
	move.w #0x1370, (0x03F7FE)
	move.w #0x0000,(0x03F7FA)

dontskip:
#send the commands to the z80
	move.b %d6,0xA01FFE
	move.b %d7,0xA01FFF

	rts

stopfast:
	move.w #0xCD54,(0x03F7FA)
	# stop without fadeout
	move.w #0x1300, (0x03F7FE)
	move.w #0x0000,(0x03F7FA)
	bra dontskip

	
# Promonition,2
# Introduction!!,44
# Sarina village,12
# WELCOME,3
# Quiet moment,4
# Prolog,5
# Winged Boy,13
# Be careful,14
# Black Monster,9
# Death's Shock,10
# Alcaino Ruins,15
# Heated Battle,16
# The Theme of Chester,45
# Black set up,17
# Fighting Soul,18
# Valestine Castle,19
# Pray for Mercy,20
# Key of light,21
# Sealing Time,6
# My Dear Elena,48
# Sentimental Twilight,8
# Death Beat,7
# Fate Tower,33
# LOOK AT THIS!,34
# Final Fight,11
# Dear my brother,47
# Morning of the journey,35
# Wanderers from Ys,46
# Get item,43
# Fleeting Dream,37
# Dancing on the road,1


