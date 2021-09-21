#Jack Massimi
#JVM17
#This file is responsible for printing the board.
.include "convenience.asm"
.include "game_settings.asm"

.data
blockSprite: .byte
		2 3 2 3 3
		3 2 2 3 2
		2 3 2 3 2
		3 2 2 3 3
		3 2 3 2 2

.text
.globl boardPrint
boardPrint:
draw_Board:
	enter s0, s1, s2
	li a0, 0
	li a1, 0
	li a2, 2
	li a3, 64
	li v1, 3
	jal display_fill_rect
	li a0, 62
	li a1, 0
	li a2, 2
	li a3, 64
	li v1, 3
	jal display_fill_rect
	li a0, 2
	li a1, 55
	li a2, 60
	li a3, 2
	li v1, 3
	jal display_fill_rect
	
	li s0, 2
	
	floor_loop:
	
	move a0, s0
	li a1, 50
	la a2, blockSprite
	jal display_blit_5x5
	add s0, s0, 5
	
	blt s0, 61, floor_loop
	li s0, 7
	
	second_platform_loop:
	
	move a0, s0
	li a1, 40
	la a2, blockSprite
	jal display_blit_5x5
	add s0, s0, 5
	
	blt s0, 56, second_platform_loop

	li a0, 12
	li a1, 35
	la a2, blockSprite
	jal display_blit_5x5
	
	li a0, 47
	li a1, 35
	la a2, blockSprite
	jal display_blit_5x5
	
	
	li a0, 27
	li a1, 30
	la a2, blockSprite
	jal display_blit_5x5
	
	li a0, 32
	li a1, 30
	la a2, blockSprite
	jal display_blit_5x5
	
	li a0, 22
	li a1, 25
	la a2, blockSprite
	jal display_blit_5x5
	
	li a0, 37
	li a1, 25
	la a2, blockSprite
	jal display_blit_5x5
	
	
	li a0, 12
	li a1, 20
	la a2, blockSprite
	jal display_blit_5x5
	
	li a0, 7
	li a1, 20
	la a2, blockSprite
	jal display_blit_5x5
	
	li a0, 7
	li a1, 15
	la a2, blockSprite
	jal display_blit_5x5
	
	li s0, 17
	
	top_platform:
	
	move a0, s0
	li a1, 10
	la a2, blockSprite
	jal display_blit_5x5
	add s0, s0, 5
	
	blt s0, 47, top_platform
	
	li a0, 17
	li a1, 5
	la a2, blockSprite
	jal display_blit_5x5
	add s0, s0, 5
	
	li a0, 42
	li a1, 5
	la a2, blockSprite
	jal display_blit_5x5
	add s0, s0, 5
	
	
	#printing number of lives the player has
	drawLives:
	li s0, 4
	jal getLives
	lw s1, 0(v0)
	
	beq s1, 0, endDrawLivesLoop
	
	jal getPlayerSprite
	move s2, v0
	
	draw_lives_loop:
	move a0, s0
	li a1, 58
	move a2, s2
	jal display_blit_5x5
	
	sub s1, s1, 1
	add s0, s0, 7
	bgt s1, 0, draw_lives_loop
	
	endDrawLivesLoop:
	leave s0, s1, s2
