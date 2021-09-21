#Jack Massimi
#JVM17
#This file is responsible for printing the npcs
.include "convenience.asm"
.include "game_settings.asm"

.data

.text
.globl drawNpcs
drawNpcs:

	enter s0, s1, s2, s3
	
	li s0, -1
	
	drawNpcLoop: #loops through the 5 initial npcs
	add s0, s0, 1
	beq s0, 5, endDrawNpc
	
	move a0, s0
	jal getNpcActive #check if npc is active do not print if false
	lw t0, (v0)
	beq t0, 0, drawNpcLoop
	
	move a0, s0
	jal getNpcX
	lw s1, (v0)
	
	move a0, s0
	jal getNpcY
	lw s2, (v0)
	
	jal getNpcSprite
	move s3, v0
		
	move a0, s1
	move a1, s2
	move a2, s3
	jal display_blit_5x5
	
	bne s0, 5, drawNpcLoop
	
	endDrawNpc:
	leave s0, s1, s2, s3
