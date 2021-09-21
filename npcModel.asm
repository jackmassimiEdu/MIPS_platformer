#Jack Massimi
#JVM17
#This file is the struct for enemies and has funcs to access the different parts of the structure
.include "convenience.asm"
.include "game_settings.asm"

.data
npcSprite: .byte
		0 0 7 0 0
		7 7 1 7 7
		0 1 1 1 0
		0 7 7 7 0
		0 7 0 7 0
npcHitSprite: .byte
		0 0 0 0 0
		0 0 1 0 0
		0 1 1 1 0
		0 0 0 0 0
		0 0 0 0 0
npcStruct: .word 0:21
#0 x position
#1 y position
#2 direction
#3 active
#20 number of NPCS active

.text
#return address of the npc sprite
.globl getNpcSprite
getNpcSprite:

	enter
	
	la v0, npcSprite
	
	leave

#return address of the npc recently hit sprite	
.globl getNpcHitSprite
getNpcHitSprite:

	enter
	
	la v0, npcHitSprite
	
	leave


#return address of npc[a0] x position
.globl getNpcX
getNpcX:

	enter

	la v0, npcStruct
	mul a0, a0, 16
	add v0, v0, a0

	leave

#return address of npc[a0] y position
.globl getNpcY
getNpcY:

	enter

	la v0, npcStruct
	mul a0, a0, 16
	add v0, v0, a0
	add v0, v0, 4
	
	leave
	
#return address of npc[a0] direction
.globl getNpcDirection
getNpcDirection:

	enter
	
	la v0, npcStruct
	add v0, v0, 8
	mul a0, a0, 16
	add v0, v0, a0
	
	leave
	
#return address of npc[a0] active state
.globl getNpcActive
getNpcActive:

	enter
	
	la v0, npcStruct
	add v0, v0, 12
	mul a0, a0, 16
	add v0, v0, a0
	
	leave
	
.globl getTotalNpcsActive
getTotalNpcsActive:

	enter
	
	la v0, npcStruct
	add v0, v0, 80
	
	leave
