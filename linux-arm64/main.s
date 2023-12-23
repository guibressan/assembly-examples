.section .data

str: .asciz "hello from the cpu!\n"
strlen: .word 21

.section .text

.global _start

_start:
	stp x29, x30, [sp, #-0x10]!	// Grow the stack size in 32 bytes
															// and store x29 and x30 (8 bytes each)
															// x29 is the frame pointer
															// x30 is the link register (stores the ret addr)
															// equivalent to push x; push y; mov rbp rsp
															// in x86
	sub sp, sp, #0x10						// Increase 16 bytes in the stack
															// sp must be multiple of 0x10 or 16

	mov x0, #0x3			// Set argument 1
	mov x1, #0x5			// Set argument 2
	ldr x30, =add_ret	// Load return addr into x30
	b add							// Jump to add function
add_ret:
	str w0, [sp, #16] // store the result value in the stack
										// sp + 16 -> | sp + 20
										// at this point, we still have 12 bytes unused
	bl print_msg			// Print a message.
										// Branch and link set x30 to pc before the jump
	ldr w0, [sp, #16]	// Load add result as argument to exit status code
	b exit						// jump to exit 

	// This will not be executed, sice branch to exit
	// does not return, but still here for educational
	// purpose
	ldp x29, x30, [sp], #0x20 // Restore x29 and x30,
														// incrementing sp in 0x20 after,
														// which reduces the stack size in 32 bytes
	ret

add:
	sub sp, sp, #0x10 // Advantage in relation to default
										// x86 behavior.
										// Since this is a leaf function
										// we don't need to keep track of old x29 and x30
										// less use of stack, less instructions == more speed

	stp w0, w1, [sp]	// Store w0 at sp -> | sp + 4 
										// and store w1 at at sp + 4  -> | sp + 8
										// sp + 8 -> | sp + 0x10 still unused (8 bytes)
	add w0, w0, w1		// w0 = w0 + w1
										// w0 is also our return value

	add sp, sp, #0x10
	ret								// ret jumps to address as x30
										// no usage of the stack

print_msg:
	mov x8,	#64			// Write syscall
	mov x0,	#0x0		// STDOUT_FD
	ldr x1,	=str		// Buffer
	mov w2, strlen	// Count
	svc #0x0				// Supervisor call
	ret							// Branch to the address at x30

exit:
	sub sp, sp, #0x10	// Grow the stack

	str w0, [sp, #0xc]	// Store status param in the stack
	mov x8, #93					// Linux exit syscall
	ldr w0, [sp, #0xc]	// load status argument
	svc #0x0						// Supervisor call (throw exception to EL1)		

	add sp, sp, #0x1	// Shrink the stack
	ret
