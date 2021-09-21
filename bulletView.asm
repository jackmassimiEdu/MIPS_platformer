#Jack Massimi
#JVM17
#This file is responsible for printing the bullet
.include "convenience.asm"
.include "game_settings.asm"

.data

.text
.globl drawBullet
drawBullet:

	enter s0, s1, s2, s3
	
	jal getBulletX
	lw s0, (v0)
	
	jal getBulletY
	lw s1, (v0)
	
	jal getBulletSprite
	move s2, v0
	
	jal getBulletDirection
	lw s3, (v0)
	beq s3, 0, endBulletView
	
	move a0, s0
	move a1, s1
	move a2, s2
	jal display_blit_5x5_trans
	
	endBulletView:
	leave s0, s1, s2, s3
