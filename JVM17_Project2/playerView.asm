#Jack Massimi
#JVM17
#This file is responsible for printing the player either in their vulnerable or invulnerable state.
.include "convenience.asm"
.include "game_settings.asm"

.data

.text
.globl drawPlayer
drawPlayer:

	enter s0, s1, s2, s3
	jal getRecentHit
	lw s0, (v0)
	
	#check to see if the player was recently hit. If they have been checks to see if this is an odd or even frame.
	beq s0, 0, playerNotHit
	li t7, 2
	div s0, t7
	mfhi t1
	bgt s0, 120, endPlayerHit
	beq t1, 0, evenF
	beq t1, 1, oddF
	
	#print the player in their vulnerable state
	playerNotHit:
	jal getXPosition
	lw s0, (v0)
	
	jal getYPosition
	lw s1, (v0)
	
	jal getPlayerSprite
	move s2, v0
	
	move a0, s0
	move a1, s1
	move a2, s2
	jal display_blit_5x5
	j endDrawPlayer
	
	#prints playerSprite on even frames
	evenF:
	jal getXPosition
	lw s1, (v0)
	
	jal getYPosition
	lw s2, (v0)
	
	jal getPlayerSprite
	move s3, v0
	
	move a0, s1
	move a1, s2
	move a2, s3
	jal display_blit_5x5
	inc s0
	jal getRecentHit
	sw s0, (v0)
	j endDrawPlayer
	
	#prints playerHitSprite on odd frames
	oddF:
	jal getXPosition
	lw s1, (v0)
	
	jal getYPosition
	lw s2, (v0)
	
	jal getPlayerHitSprite
	move s3, v0
	
	move a0, s1
	move a1, s2
	move a2, s3
	jal display_blit_5x5
	inc s0
	jal getRecentHit
	sw s0, (v0)
	j endDrawPlayer
	
	#resets player hit state to 0
	endPlayerHit:
	jal getRecentHit
	li t0, 0
	sw t0, (v0)
	j playerNotHit
	
	endDrawPlayer:
	leave s0, s1, s2, s3
