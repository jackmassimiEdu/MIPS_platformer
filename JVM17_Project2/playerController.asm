#Jack Massimi
#JVM17
#This file is responsible for player movement and action.
.include "convenience.asm"
.include "game_settings.asm"

.data

.text
.globl playerController

playerController:

	enter s0, s1, s2, s3, s4, s5
	push s6
	
	jal handle_input
	
	#save state of all input buttons
	lw s0, right_pressed
	lw s1, down_pressed
	lw s2, left_pressed
	lw s3, up_pressed
	lw s4, action_pressed
	
	jal getXPosition
	move s5, v0
	
	jal getYPosition
	move s6, v0
	
	
	checkRight:
	bne s0, 1, checkDown
	#check pixel to the right
	#if its yellow or orange don't move
	lw a0, (s5)
	lw a1, (s6)
	add a0, a0, 5
	jal display_get_pixel
	beq v0, 2, checkDown
	beq v0, 3, checkDown
	
	lw a0, (s5)
	lw a1, (s6)
	add a0, a0, 5
	add a1, a1, 4
	jal display_get_pixel
	beq v0, 2, checkDown
	beq v0, 3, checkDown
	
	lw t0, (s5)
	add t0, t0, 1
	sw t0, (s5)
	
	jal getLastDirection
	li t0, 2
	sw t0, (v0)
	
	checkDown:
#	bne s1, 1, checkLeft
	
#	lw a0, (s5)
#	lw a1, (s6)
#	add a1, a1, 5
#	jal display_get_pixel
#	beq v0, 2, checkLeft
#	beq v0, 3, checkLeft
	
#	lw a0, (s5)
#	lw a1, (s6)
#	add a0, a0, 4
#	add a1, a1, 5
#	jal display_get_pixel
#	beq v0, 2, checkLeft
#	beq v0, 3, checkLeft
	
#	lw t0, (s6)
#	add t0, t0, 1
#	sw t0, (s6)
	
	
	#
	#
	checkLeft:
	bne s2, 1, checkUp
	#check pixel to the left
	#if its yellow or orange don't move
	lw a0, (s5)
	lw a1, (s6)
	sub a0, a0, 1
	jal display_get_pixel
	beq v0, 2, checkUp
	beq v0, 3, checkUp
	
	lw a0, (s5)
	lw a1, (s6)
	sub a0, a0, 1
	add a1, a1, 4
	jal display_get_pixel
	beq v0, 2, checkUp
	beq v0, 3, checkUp
	
	lw t0, (s5)
	sub t0, t0, 1
	sw t0, (s5)
	
	jal getLastDirection
	li t0, 1
	sw t0, (v0)
	
	
	#
	#
	checkUp:
	#check to see if the player is already jumping. 
	#If they are cont moving up until player hits a ceiling or goes up 20 pixels.
	jal getJumping
	lw t0, (v0)
	beq t0, 0, moveDown
	bge t0, 20, resetJump
	add t0, t0, 1
	sw t0, (v0)
	
	lw t0, (s6)
	sub t0, t0, 1
	blt t0, 0, checkAction
	
	lw a0, (s5)
	lw a1, (s6)
	sub a1, a1, 1
	jal display_get_pixel
	beq v0, 2, resetJump #if the top left of the player sprite hits a ceiling reset jump state to 0.
	beq v0, 3, resetJump
	
	lw a0, (s5)
	lw a1, (s6)
	add a0, a0, 4
	sub a1, a1, 1
	jal display_get_pixel
	beq v0, 2, resetJump #if the top right of the player sprite hits a ceiling reset jump state to 0.
	beq v0, 3, resetJump
	
	lw t0, (s6)
	sub t0, t0, 1
	sw t0, (s6)
	j checkAction
	
	resetJump:
	jal getJumping
	li t0, 0
	sw t0, (v0)
	
	#If the player is not jumping check underneath the player. If there is a floor skip this, if there is not move player down 1 pixel.
	moveDown:
	lw a0, (s5) 
	lw a1, (s6)
	add a1, a1, 5
	jal display_get_pixel
	bne v0, 0, checkUpButton
	
	lw a0, (s5)
	lw a1, (s6)
	add a0, a0, 4
	add a1, a1, 5
	jal display_get_pixel
	bne v0, 0, checkUpButton
	
	lw t0, (s6)
	add t0, t0, 1
	sw t0, (s6)
	
	#If the player is not jumping and is already on a floor check for jump input.
	checkUpButton:
	bne s3, 1, checkAction
	
	lw t0, (s6)
	sub t0, t0, 1
	blt t0, 0, checkAction
	
	lw a0, (s5)
	lw a1, (s6)
	add a1, a1, 5
	jal display_get_pixel
	bne v0, 0, jump
	
	lw a0, (s5)
	lw a1, (s6)
	add a0, a0, 4
	add a1, a1, 5
	jal display_get_pixel
	bne v0, 0, jump
	
	j checkAction
	
	#moves player up if the jump state is less than 20
	jump:
	jal getJumping
	li t0, 1
	sw t0, (v0)
	
	lw a0, (s5)
	lw a1, (s6)
	sub a1, a1, 1
	jal display_get_pixel
	beq v0, 2, checkAction
	beq v0, 3, checkAction
	
	lw a0, (s5)
	lw a1, (s6)
	add a0, a0, 4
	sub a1, a1, 1
	jal display_get_pixel
	beq v0, 2, checkAction
	beq v0, 3, checkAction
	
	lw t0, (s6)
	sub t0, t0, 1
	sw t0, (s6)
	
	
	#Checks for action press
	#If the player shoots it passes the players current position and direction to the bulletController file
	checkAction:
	bne s4, 1, endController
	
	jal getShooting
	lw t0, (v0)
	beq t0, 1, endController
	
	li t0, 1
	sw t0, (v0)
	
	lw a0, (s5)
	lw a1, (s6)
	jal getLastDirection
	lw a2, (v0)
	jal spawnBullet
	
endController:
	pop s6
	leave s0, s1, s2, s3, s4, s5
