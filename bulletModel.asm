#Jack Massimi
#JVM17
#This file is the structure for bullets
.include "convenience.asm"
.include "game_settings.asm"

.data
bulletSprite: .byte
		-1 -1 -1 -1 -1
		-1 5 5 5 -1
		-1 -1 -1 -1 -1
		-1 -1 -1 -1 -1
		-1 -1 -1 -1 -1
bulletStruct: .word 0:3
#0 x position
#1 y position
#2 0: inactive, 1: going left, 2: going right

.text

#get address of bulletSprite
.globl getBulletSprite
getBulletSprite:
	enter
	
	la v0, bulletSprite
	
	leave

#get address of bulletStruct[0]
.globl getBulletX
getBulletX:
	enter
	
	la v0, bulletStruct
	
	leave
	
#get address of bulletStruct[1]
.globl getBulletY
getBulletY:
	enter
	
	la v0, bulletStruct
	add v0, v0, 4
	
	leave
	
#get address of bulletStruct[2]
.globl getBulletDirection
getBulletDirection:
	enter
	
	la v0, bulletStruct
	add v0, v0, 8
	
	leave
