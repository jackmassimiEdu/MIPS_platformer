# YOUR_USERNAME_HERE
# YOUR_FULL_NAME_HERE

.include "convenience.asm"
.include "game_settings.asm"


#	Defines the number of frames per second: 16ms -> 60fps
.eqv	GAME_TICK_MS		16

.data
# don't get rid of these, they're used by wait_for_next_frame.
last_frame_time:  .word 0
frame_counter:    .word 0
loseMessage: .asciiz "YOU LOSE!"
winMessage: .asciiz "YOU WON IN"
winMessage2: .asciiz "SECONDS!"


.text
# --------------------------------------------------------------------------------------------------

.globl game
game:
	# set up anything you need to here,
	# and wait for the user to press a key to start.
	
	# set initial lives
	jal getLives
	li t0, 3
	sw t0, (v0)
	
	# set initial position
	jal getXPosition
	li t0, 30
	sw t0, (v0)
	jal getYPosition
	li t0, 25
	sw t0, (v0)
	
	# set initial npcs
	# npc 1
	li a0, 0
	jal getNpcX
	li t0, 5
	sw t0, (v0)
	
	li a0, 0
	jal getNpcY
	li t0, 45
	sw t0, (v0)
	
	li a0, 0
	jal getNpcActive
	li t0, 1
	sw t0, (v0)
	
	# npc 2
	li a0, 1
	jal getNpcX
	li t0, 55
	sw t0, (v0)
	
	li a0, 1
	jal getNpcY
	li t0, 45
	sw t0, (v0)
	
	li a0, 1
	jal getNpcActive
	li t0, 1
	sw t0, (v0)
	
	# npc 3
	li a0, 2
	jal getNpcX
	li t0, 15
	sw t0, (v0)
	
	li a0, 2
	jal getNpcY
	li t0, 35
	sw t0, (v0)
	
	li a0, 2
	jal getNpcActive
	li t0, 1
	sw t0, (v0)
	
	# npc 4
	li a0, 3
	jal getNpcX
	li t0, 25
	sw t0, (v0)
	
	li a0, 3
	jal getNpcY
	li t0, 35
	sw t0, (v0)
	
	li a0, 3
	jal getNpcActive
	li t0, 1
	sw t0, (v0)
	
	# npc 5
	li a0, 4
	jal getNpcX
	li t0, 30
	sw t0, (v0)
	
	li a0, 4
	jal getNpcY
	li t0, 5
	sw t0, (v0)
	
	li a0, 4
	jal getNpcActive
	li t0, 1
	sw t0, (v0)
	
	jal getTotalNpcsActive
	li t0, 5
	sw t0, (v0)
	# Wait for a key input
	
	
_game_wait:
	jal	input_get_keys
	beqz	v0, _game_wait

_game_loop:
	# check for input,
	jal     handle_input

	# update everything,

	# draw everything
	jal	boardPrint
	jal	playerController
	jal	drawPlayer
	jal	updateBullet
	jal	drawBullet
	jal	npcController
	jal	drawNpcs
	jal	display_update_and_clear

	## This function will block waiting for the next frame!
	jal	wait_for_next_frame
	b	_game_loop

_game_over:
	exit



# --------------------------------------------------------------------------------------------------
# call once per main loop to keep the game running at 60FPS.
# if your code is too slow (longer than 16ms per frame), the framerate will drop.
# otherwise, this will account for different lengths of processing per frame.

wait_for_next_frame:
	enter	s0
	lw	s0, last_frame_time
_wait_next_frame_loop:
	# while (sys_time() - last_frame_time) < GAME_TICK_MS {}
	li	v0, 30
	syscall # why does this return a value in a0 instead of v0????????????
	sub	t1, a0, s0
	bltu	t1, GAME_TICK_MS, _wait_next_frame_loop

	# save the time
	sw	a0, last_frame_time

	# frame_counter++
	lw	t0, frame_counter
	inc	t0
	sw	t0, frame_counter
	leave	s0

# --------------------------------------------------------------------------------------------------

.globl lose
lose:
	enter
	
	li a0, 8
	li a1, 15
	la a2, loseMessage
	jal display_draw_text
	jal display_update
	
	exit
	
.globl win
win:
	enter
	
	li a0, 2
	li a1, 15
	la a2, winMessage
	jal display_draw_text
	
	lw t0, frame_counter
	li t1, 60
	div t0, t1
	mflo a2
	li a0, 31
	li a1, 21
	jal display_draw_int
	
	li a0, 2
	li a1, 27
	la a2, winMessage2
	jal display_draw_text
	
	jal display_update
	
	exit
