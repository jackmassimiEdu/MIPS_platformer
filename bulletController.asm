#Jack Massimi
#JVM17
#This file is responsible for bullet spawning and movement.
.include "convenience.asm"
.include "game_settings.asm"

.data

.text
#spawns the bullet at x = a0, y = a1, going in direction the player was last going.
.globl spawnBullet
	
	spawnBullet:
		
		enter s0, s1, s2
		
		move s0, a0
		move s1, a1
		move s2, a2
		
		jal getBulletDirection
		sw s2, (v0)
		
		beq s2, 1, shootLeft
		beq s2, 2, shootRight
		
		shootLeft:
		sub s0, s0, 3
		jal getBulletX
		sw s0, (v0)
		
		jal getBulletY
		sw s1, (v0)
		j leaveSpawnBullet
		
		shootRight:
		add s0, s0, 3
		jal getBulletX
		sw s0, (v0)
		
		jal getBulletY
		sw s1, (v0)
		
		leaveSpawnBullet:
		leave s0, s1, s2
	
#moves the bullet left or right until it encounters a wall.	
.globl updateBullet
	updateBullet:
	
		enter s0, s1, s2
		
		jal getBulletX
		move s0, v0
		
		jal getBulletY
		move s1, v0
		
		jal getBulletDirection
		move s2, v0
		lw t0, (s2)
		
		beq t0, 0, endBulletUpdate
		beq t0, 1, moveBulletLeft
		beq t0, 2, moveBulletRight
		
		moveBulletLeft:
		lw a0, (s0)
		lw a1, (s1)
		add a1, a1, 1
		jal display_get_pixel
		beq v0, 2, endBullet #check to see if pixel to the left is orange or yellow
		beq v0, 3, endBullet
		
		lw t0, (s0)
		sub t0, t0, 2
		sw t0, (s0)
		j endBulletUpdate
		
		moveBulletRight:
		lw a0, (s0)
		lw a1, (s1)
		add a0, a0, 4
		add a1, a1, 1
		jal display_get_pixel
		beq v0, 2, endBullet #check to see if pixel to the right is orange or yellow
		beq v0, 3, endBullet
		
		lw t0, (s0)
		add t0, t0, 2
		sw t0, (s0)
		j endBulletUpdate
		
		
		endBullet:
		jal endBulletFunc
		
		
		endBulletUpdate:
		leave s0, s1, s2
		
#Despawns bullet. Sets bullet direction and players shooting state to 0.
.globl endBulletFunc
	endBulletFunc:
		enter
		jal getBulletDirection
		move t0, v0
		
		li t1, 0
		sw t1, (t0)
		
		jal getShooting
		li t0, 0
		sw t0, (v0)
		
		leave
