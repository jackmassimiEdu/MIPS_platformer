#Jack Massimi
#JVM17
#This file is responsible for moving the enemies left and right until they hit a wall, and then reversing direction.
#This file also checks for collision between enemies, bullets, and the player.
#This file also checks to see if the win or loss conditions have been met.
.include "convenience.asm"
.include "game_settings.asm"

.data

.text
.globl npcController

npcController:

	enter s0, s1, s2, s3, s4, s5
		
	li s0, -1
	
	#loops through the 5 initial npcs
	npcContLoop:
	add s0, s0, 1
	
	bge s0, 5, endNpcController
		
	move a0, s0
	jal getNpcActive #check to see if the npc is active
	lw t0, (v0)
	beq t0, 0, npcContLoop
		
	move a0, s0
	jal getNpcX
	move s1, v0
	
	move a0, s0
	jal getNpcY
	move s2, v0
	
	move a0, s0
	jal getNpcDirection
	move s3, v0
	lw t0, (s3)
	
	beq t0, 1, npcLeft 
	beq t0, 2, npcRight
	
	npcRight:
	#check pixel to the right
	#if its yellow or orange don't move
	lw a0, (s1)
	lw a1, (s2)
	add a0, a0, 5
	jal display_get_pixel
	beq v0, 2, changeNpcDirec
	beq v0, 3, changeNpcDirec
		
	lw t0, (s1)
	add t0, t0, 1
	sw t0, (s1)
	
	j npcCollision
	
	
	npcLeft:
	
	#check pixel to the left
	#if its yellow or orange don't move
	lw a0, (s1)
	lw a1, (s2)
	sub a0, a0, 1
	jal display_get_pixel
	beq v0, 2, changeNpcDirec
	beq v0, 3, changeNpcDirec
		
	lw t0, (s1)
	sub t0, t0, 1
	sw t0, (s1)

	j npcCollision
		
	#change direction npc is moving
	changeNpcDirec:
	lw t0, (s3)
	beq t0, 1, changeToR
	beq t0, 2, changeToL
		
		changeToR:
		li t0, 2
		sw t0, (s3)
		j npcCollision
		
		changeToL:
		li t0, 1
		sw t0, (s3)
		j npcCollision
		
	npcCollision:
	#check to see if bullet and npc collide
	checkBulletCol:
	jal getBulletDirection
	lw t0, (v0)
	
	beq t0, 0, checkPlayerCol
	
	jal getBulletX
	lw s4, (v0)
	jal getBulletY
	lw t1, (v0)
	move t0, s4
	add t0, t0, 1
	
	lw t2, (s1)
	lw t3, (s2)
	
	bne t3, t1, checkPlayerCol
	beq t2, t0, bulletCol
	add t0, t0, 1
	beq t2, t0, bulletCol
	add t0, t0, 1
	bne t2, t0, checkPlayerCol
	
	#if they have deactivate the npc, dec npc counter, and despawn bullet
	#if this was the last enemy win condition is met
	bulletCol:
	move a0, s0
	jal getNpcActive
	li t0, 0
	sw t0, (v0)
	jal getTotalNpcsActive
	lw t0, (v0)
	dec t0
	beq t0, 0, winGame
	sw t0, (v0)
	jal endBulletFunc
	
	#check if the player and an enemy collide
	checkPlayerCol:
	jal getRecentHit
	lw t0, (v0)
	
	bne t0, 0, endColCheck
	
	jal getXPosition
	lw s4, (v0)
	jal getYPosition
	lw t1, (v0)
	move t0, s4
	sub t0, t0, 1
	
	lw t2, (s1)
	lw t3, (s2)
	
	bne t3, t1, endColCheck
	beq t2, t0, playerCol
	add t0, t0, 6
	bne t2, t0, endColCheck
	
	#if they do set players recently hit state to 1
	#remove a life
	#if there are no lives to remove loss condition is met
	playerCol:
	jal getRecentHit
	li t0, 1
	sw t0, (v0)
	jal getLives
	lw t0, (v0)
	beq t0, 0, loseGame
	dec t0
	sw t0, (v0)
	
	endColCheck:
	
	bne s0, 4, npcContLoop
	
endNpcController:
	leave s0, s1, s2, s3, s4, s5
	
loseGame:
	jal lose
	
winGame:
	jal win
