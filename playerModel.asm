#Jack Massimi
#JVM17
#This file is responsible for the players structure
.include "convenience.asm"
.include "game_settings.asm"

.data
playerSprite: .byte
		0 0 7 0 0
		7 7 5 7 7
		0 5 5 5 0
		0 7 7 7 0
		0 7 0 7 0
playerHitSprite: .byte
		0 0 0 0 0
		0 0 5 0 0
		0 5 5 5 0
		0 0 0 0 0
		0 0 0 0 0
playerStruct: .word 0:7
#0 x position
#1 y position
#2 lives
#3 jumping
#4 shooting
#5 lastDirection
#6 recently hit

.text

# address getPlayerSprite()
# returns the address of playerSprite
.globl getPlayerSprite
getPlayerSprite:
	enter
	
	la v0, playerSprite
	
	leave

.globl getPlayerHitSprite
getPlayerHitSprite:
	enter
	
	la v0, playerHitSprite
	
	leave

# address getXPosition()
# returns the address of the players X position
.globl getXPosition
getXPosition:
	enter
	
	la v0, playerStruct
	
	leave
	

# address getYPosition()
# returns the address of the players Y position
.globl getYPosition
getYPosition:
	enter
	
	la v0, playerStruct
	add v0, v0, 4
	
	leave
	

# address getLives()
# returns the address of the players lives
.globl getLives
getLives:
	enter
	
	la v0, playerStruct
	add v0, v0, 8
	
	leave
	

# address getJumping()
# returns the address of the players jumping
.globl getJumping
getJumping:
	enter
	
	la v0, playerStruct
	add v0, v0, 12
	
	leave
	

# address getShooting()
# returns the address of the players shooting
.globl getShooting
getShooting:
	enter
	
	la v0, playerStruct
	add v0, v0, 16
	
	leave


.globl getLastDirection
getLastDirection:
	enter
	
	la v0, playerStruct
	add v0, v0, 20
	
	leave

.globl getRecentHit
getRecentHit:
	enter
	
	la v0, playerStruct
	add v0, v0, 24
	
	leave
